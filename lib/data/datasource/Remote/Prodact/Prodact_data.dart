import 'dart:io';

import 'package:Silaaty/core/class/Crud.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/class/Sqldb.dart';
import '../../../../core/class/SyncServer.dart';
import '../../../../core/services/Services.dart';

class ProdactData {
  Crud crud;
  final SQLDB sqldb = SQLDB();
  final SyncService _syncService = SyncService();

  int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");

  ProdactData(this.crud);

  Future<String?> _saveImage(File? file) async {
    if (file == null) return null;

    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.png";

    await file.copy(path);
    return path;
  }

  Future<bool> addProduct(Map<String, Object?> data, Map<String, Object?> sale,
      [File? image]) async {
    final String uuid = Uuid().v4();
    data["uuid"] = uuid;
    sale["product_uuid"] = uuid;

    final imagePath = await _saveImage(image);
    if (imagePath != null) {
      data["Product_image"] = imagePath;
    }

    final result = await sqldb.insert("products", data);
    final resultsale = await sqldb.insert("sales", sale);

    if (result > 0 && resultsale > 0) {
      await _syncService.addToQueue("products", uuid, "insert", data);
      await _syncService.addToQueue(
        "sales",
        sale["uuid"] as String,
        "insert",
        sale,
      );
      return true;
    }
    return false;
  }

  Future<bool> updateProduct(
    Map<String, Object?> data,
    int oldQty,
    int newQty, [
    File? image,
  ]) async {
    final uuid = data["uuid"] as String;

    // تحديث الصورة
    if (image != null) {
      final oldResult = await sqldb.readData(
        "SELECT Product_image FROM products WHERE uuid = ? AND user_id = ?",
        [uuid, id],
      );

      if (oldResult.isNotEmpty) {
        final oldPath = oldResult.first["Product_image"] as String?;
        if (oldPath != null && File(oldPath).existsSync()) {
          try {
            await File(oldPath).delete();
          } catch (_) {}
        }
      }

      final imagePath = await _saveImage(image);
      if (imagePath != null) {
        data["Product_image"] = imagePath;
      }
    }

    // 1️⃣ تحديث المنتج نفسه
    final result = await sqldb.update(
      "products",
      data,
      "uuid = ? AND user_id = ?",
      [uuid, id],
    );

    if (result <= 0) return false;
    final int diff = newQty - oldQty;

    if (diff != 0) {
      // جلب جميع سجلات type_sales = 3 المرتبطة بالمنتج بترتيب التاريخ تنازلي
      final sales = await sqldb.readData(
        '''
    SELECT uuid, quantity, unit_price
    FROM sales
    WHERE product_uuid = ? AND user_id = ? AND type_sales = 3
    ORDER BY datetime(created_at) DESC
    ''',
        [uuid, id],
      );

      int remainingDiff = diff.abs();

      // ➕ إذا الكمية الجديدة أكبر من القديمة
      if (diff > 0) {
        if (sales.isNotEmpty) {
          // زد الفرق في آخر سجل فقط
          final sale = sales.first;
          final saleUuid = sale["uuid"] as String;
          int saleQty = sale["quantity"] as int;
          final unitPrice = double.tryParse(sale["unit_price"].toString()) ?? 0;

          saleQty += remainingDiff;

          await sqldb.update(
            "sales",
            {
              "quantity": saleQty,
              "subtotal": saleQty * unitPrice,
              "product_name": data["product_name"],
              "unit_price": data["product_price"],
              "product_price_purchase": data["product_price_purchase"],
              "updated_at": DateTime.now().toIso8601String(),
            },
            "uuid = ?",
            [saleUuid],
          );
          await _syncService.addToQueue("sales", saleUuid, "update", {
            "quantity": saleQty,
            "subtotal": saleQty * unitPrice,
            "product_name": data["product_name"],
            "unit_price": data["product_price"],
            "product_price_purchase": data["product_price_purchase"],
            "updated_at": DateTime.now().toIso8601String(),
          });
        } else {
          // لا يوجد سجلات type_sales = 3 → يمكن إنشاء سجل جديد هنا إذا أردت
        }
      }
      // ➖ إذا الكمية الجديدة أصغر من القديمة
      else {
        // نقص الفرق تدريجياً من كل سجل من الأحدث للأقدم
        for (var sale in sales) {
          if (remainingDiff <= 0) break;

          final saleUuid = sale["uuid"] as String;
          int saleQty = int.tryParse(sale["quantity"]?.toString() ?? '0') ?? 0;
          final unitPrice =
              double.tryParse(data["product_price"].toString()) ?? 0;

          if (saleQty >= remainingDiff) {
            saleQty -= remainingDiff;
            remainingDiff = 0;
          } else {
            remainingDiff -= saleQty;
            saleQty = 0;
          }

          if (saleQty <= 0) {
            await sqldb.delete("sales", "uuid = ?", [saleUuid]);
            await _syncService.addToQueue("sales", saleUuid, "update", {
              "uuid": saleUuid,
              "is_delete": 1,
              "updated_at": DateTime.now().toIso8601String(),
            });
          } else {
            await sqldb.update(
              "sales",
              {
                "quantity": saleQty,
                "subtotal": saleQty * unitPrice,
                "product_name": data["product_name"],
                "unit_price": data["product_price"],
                "product_price_purchase": data["product_price_purchase"],
                "updated_at": DateTime.now().toIso8601String(),
              },
              "uuid = ?",
              [saleUuid],
            );
            await _syncService.addToQueue("sales", saleUuid, "update", {
              "quantity": saleQty,
              "subtotal": saleQty * unitPrice,
              "product_name": data["product_name"],
              "unit_price": data["product_price"],
              "product_price_purchase": data["product_price_purchase"],
              "updated_at": DateTime.now().toIso8601String(),
            });
          }
        }
      }
    }
    if (diff == 0) {
      final unitPrice = double.tryParse(data["product_price"].toString()) ?? 0;

      // جلب uuid و quantity لجميع سجلات type_sales = 3
      final sale12 = await sqldb.readData(
        '''
    SELECT uuid, quantity
    FROM sales
    WHERE product_uuid = ? AND user_id = ? AND type_sales = 3
    ''',
        [uuid, id],
      );

      for (var s in sale12) {
        // الآن quantity موجود
        int saleQty = int.tryParse(s["quantity"]?.toString() ?? '0') ?? 0;

        await sqldb.update(
          "sales",
          {
            "subtotal": saleQty * unitPrice,
            "product_name": data["product_name"],
            "unit_price": data["product_price"],
            "product_price_purchase": data["product_price_purchase"],
            "updated_at": DateTime.now().toIso8601String(),
          },
          "uuid = ?",
          [s["uuid"]],
        );

        await _syncService.addToQueue(
          "sales",
          s["uuid"] as String,
          "update",
          {
            "product_name": data["product_name"],
            "unit_price": data["product_price"],
            "product_price_purchase": data["product_price_purchase"],
            "updated_at": DateTime.now().toIso8601String(),
          },
        );
      }
    }

    // تعديل سجلات type_sales = 1 و 2: الاسم + سعر الشراء فقط
    final sale12 = await sqldb.readData(
      '''
    SELECT uuid FROM sales
    WHERE product_uuid = ? AND user_id = ? AND type_sales IN (1,2)
    ''',
      [uuid, id],
    );

    for (var s in sale12) {
      await sqldb.update(
        "sales",
        {
          "product_name": data["product_name"],
          "product_price_purchase": data["product_price_purchase"],
          "updated_at": DateTime.now().toIso8601String(),
        },
        "uuid = ?",
        [s["uuid"]],
      );
      await _syncService.addToQueue("sales", s["uuid"] as String, "update", {
        "product_name": data["product_name"],
        "product_price_purchase": data["product_price_purchase"],
        "updated_at": DateTime.now().toIso8601String(),
      });
    }

    // sync المنتج نفسه
    await _syncService.addToQueue("products", uuid, "update", data);

    return true;
  }

  Future<bool> updateQuantityProduct(
      Map<String, Object?> data, Map<String, Object?> sale,
      [File? image]) async {
    final uuid = data["uuid"] as String;

    final result = await sqldb.update(
      "products",
      data,
      "uuid = ? AND user_id = ?",
      [uuid, id],
    );

    final resultsale = await sqldb.insert("sales", sale);

    if (result > 0 && resultsale > 0) {
      await _syncService.addToQueue("products", uuid, "update", data);
      await _syncService.addToQueue(
        "sales",
        sale["uuid"] as String,
        "insert",
        sale,
      );
      return true;
    }

    return false;
  }

  Future<List<Map<String, Object?>>> search(Map data) async {
    final categorieId = data["Categorie_id"];
    final query = data["query"];

    final result = await sqldb.readData(
      "SELECT * FROM products WHERE  user_id = ? AND product_name LIKE ? AND categorie_id = ? AND is_delete=0",
      [id, '%$query%', categorieId],
    );
    return result;
  }

  Future<List<Map<String, Object?>>> getProdact(
      Map<String, Object?> data) async {
    final categorieId = data["Categoris_id"];
    final List<Map<String, Object?>> result;
    if (categorieId == 2) {
      result = await sqldb.readData(
        "SELECT * FROM products WHERE product_quantity <= 0 AND user_id = ? AND is_delete=0",
        [id],
      );
    } else {
      result = await sqldb.readData(
        "SELECT * FROM products WHERE categorie_id = ? AND user_id = ? AND is_delete=0",
        [categorieId, id],
      );
    }

    return result;
  }

  Future<List<Map<String, Object?>>> getCatProdactbytype(
      Map<String, Object?> data) async {
    final categorieId = data["Categorie_id"];
    final categorisuuId = data["Categoris_uuid"];
    print("========$categorisuuId");
    final List<Map<String, Object?>> result;
    if (categorieId == 2) {
      print("======n");
      result = await sqldb.readData(
        "SELECT * FROM products WHERE product_quantity <= 0 AND categoris_uuid = ? AND user_id = ? AND is_delete=0",
        [categorisuuId, id],
      );
    } else {
      result = await sqldb.readData(
        "SELECT * FROM products WHERE categorie_id = ? AND categoris_uuid = ? AND user_id = ? AND is_delete=0 ",
        [categorieId, categorisuuId, id],
      );
    }

    return result;
  }

  Future<List<Map<String, Object?>>> ShwoProdact(Map data) async {
    final uuid = data['uuid'];

    final result = await sqldb.readData(
      "SELECT * FROM products WHERE user_id = ? AND uuid = ? AND is_delete=0",
      [id, uuid],
    );

    return result;
  }

  Future<bool> deleteProdact(Map<String, Object?> data) async {
    final uuid = data["uuid"]?.toString().trim();
    if (uuid == null || uuid.isEmpty) return false;

    try {
      // 1️⃣ جلب المنتج
      final productRes = await sqldb.readData(
        "SELECT product_quantity FROM products WHERE uuid = ? AND user_id = ? LIMIT 1",
        [uuid, id],
      );

      if (productRes.isEmpty) return false;

      int remainingQty =
          int.parse(productRes.first["product_quantity"].toString());

      // جلب إدخالات stock (type_sales = 3) من الأخير للأول
      final stockRows = await sqldb.readData(
        '''
      SELECT uuid, quantity
      FROM sales
      WHERE product_uuid = ?
        AND user_id = ?
        AND type_sales = 3
      ORDER BY created_at DESC
      ''',
        [uuid, id],
      );

      for (final row in stockRows) {
        if (remainingQty <= 0) break;

        final stockUuid = row["uuid"] as String;
        final stockQty = int.parse(row["quantity"].toString());

        if (stockQty > remainingQty) {
          final newQty = stockQty - remainingQty;

          await sqldb.update(
            "sales",
            {
              "quantity": newQty,
              "updated_at": DateTime.now().toIso8601String(),
            },
            "uuid = ?",
            [stockUuid],
          );

          await _syncService.addToQueue(
            "sales",
            stockUuid,
            "update",
            {
              "uuid": stockUuid,
              "quantity": newQty,
              "updated_at": DateTime.now().toIso8601String(),
            },
          );

          remainingQty = 0;
        } else {
          //  احذف السطر وكمل
          await sqldb.delete(
            "sales",
            "uuid = ?",
            [stockUuid],
          );

          await _syncService.addToQueue(
            "sales",
            stockUuid,
            "update",
            {
              "uuid": stockUuid,
              "is_delete": 1,
              "updated_at": DateTime.now().toIso8601String(),
            },
          );

          remainingQty -= stockQty;
        }
      }

      // 3️⃣ حذف المنتج
      await sqldb.update(
        "products",
        {
          "uuid": uuid,
          "is_delete": 1,
          "updated_at": DateTime.now().toIso8601String(),
        },
        "uuid = ? AND user_id = ?",
        [uuid, id],
      );

      await _syncService.addToQueue(
        "products",
        uuid,
        "update",
        {
          "uuid": uuid,
          "is_delete": 1,
          "updated_at": DateTime.now().toIso8601String(),
        },
      );

      return true;
    } catch (e, st) {
      print("❌ deleteProdact error: $e");
      print(st);
      return false;
    }
  }

}
