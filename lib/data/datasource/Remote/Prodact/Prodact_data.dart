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
    int diff, [
    File? image,
  ]) async {
    final uuid = data["uuid"] as String;

    // تحديث الصورة (كما عندك، ما نبدلوش)
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

    // 1️⃣ تحديث المنتج
    final result = await sqldb.update(
      "products",
      data,
      "uuid = ? AND user_id = ?",
      [uuid, id],
    );

    if (result <= 0) return false;

    //  تحديث آخر سطر sales فقط
    if (diff != 0) {
      final sales = await sqldb.readData(
        """
    SELECT uuid, quantity, unit_price
    FROM sales
    WHERE product_uuid = ? AND user_id = ?
    ORDER BY created_at DESC
    LIMIT 1
    """,
        [uuid, id],
      );

      if (sales.isEmpty) return true;

      final sale = sales.first;
      final saleUuid = sale["uuid"];
      final oldSaleQty = sale["quantity"] as int;
      final unitPrice = double.tryParse(sale["unit_price"].toString()) ?? 0;

      final newSaleQty = oldSaleQty + diff;

      if (newSaleQty <= 0) {
        // إذا وصلت الكمية 0 → نحذف آخر حركة
        await sqldb.delete(
          "sales",
          "uuid = ?",
          [saleUuid],
        );
      } else {
        // تعديل آخر سطر فقط
        await sqldb.update(
          "sales",
          {
            "quantity": newSaleQty,
            "subtotal": newSaleQty * unitPrice,
            "updated_at": DateTime.now().toIso8601String(),
          },
          "uuid = ?",
          [saleUuid],
        );
      }
    }

    // sync
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
      "SELECT * FROM products WHERE  user_id = ? AND product_name LIKE ? AND categorie_id = ? ",
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
        "SELECT * FROM products WHERE product_quantity <= 0 AND user_id = ? ",
        [id],
      );
    } else {
      result = await sqldb.readData(
        "SELECT * FROM products WHERE categorie_id = ? AND user_id = ?",
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
        "SELECT * FROM products WHERE product_quantity <= 0 AND categoris_uuid = ? AND user_id = ?",
        [categorisuuId, id],
      );
    } else {
      result = await sqldb.readData(
        "SELECT * FROM products WHERE categorie_id = ? AND categoris_uuid = ? AND user_id = ?  ",
        [categorieId, categorisuuId, id],
      );
    }

    return result;
  }

  Future<List<Map<String, Object?>>> ShwoProdact(Map data) async {
    final uuid = data['uuid'];

    final result = await sqldb.readData(
      "SELECT * FROM products WHERE user_id = ? AND uuid = ?",
      [id, uuid],
    );

    return result;
  }

  Future<bool> deleteProdact(Map<String, Object?> data) async {
    final uuid = data["uuid"]?.toString().trim();

    if (uuid == null || uuid.isEmpty) return false;

    try {
      // 1️⃣ تأكد المنتج موجود
      final product = await sqldb.readData(
        "SELECT uuid FROM products WHERE uuid = ? AND user_id = ? LIMIT 1",
        [uuid, id],
      );

      if (product.isEmpty) {
        print("❌ المنتج غير موجود");
        return false;
      }

      // 2️⃣ حساب الكمية المباعة (type_sales = 2)
      final soldResult = await sqldb.readData(
        '''
      SELECT SUM(quantity) AS total_sold
      FROM sales
      WHERE product_uuid = ?
        AND user_id = ?
        AND type_sales = 2
      ''',
        [uuid, id],
      );

      final int soldQty = (soldResult.first["total_sold"] as int?) ?? 0;

      // 3️⃣ جلب سطر الإدخال (type_sales = 3)
      final stockRow = await sqldb.readData(
        '''
      SELECT uuid
      FROM sales
      WHERE product_uuid = ?
        AND user_id = ?
        AND type_sales = 3
      LIMIT 1
      ''',
        [uuid, id],
      );

      if (stockRow.isNotEmpty) {
        final stockUuid = stockRow.first["uuid"] as String;

        if (soldQty == 0) {
          // ❌ ما كاش مبيعات → نحذف الإدخال
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
        } else {
          // ✅ كاين مبيعات → نعدّل الإدخال بالكمية المباعة
          await sqldb.update(
            "sales",
            {
              "quantity": soldQty,
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
              "quantity": soldQty,
              "updated_at": DateTime.now().toIso8601String(),
            },
          );
        }
      }

      // 4️⃣ حذف المنتج
      await sqldb.delete(
        "products",
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

      print("✅ تم حذف المنتج بنجاح");
      return true;
    } catch (e, st) {
      print("❌ خطأ أثناء حذف المنتج: $e");
      print(st);
      return false;
    }
  }
}
