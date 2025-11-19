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
      Map<String, Object?> data, Map<String, Object?> sale,
      [File? image]) async {
    final uuid = data["uuid"] as String;
    final quantity = sale["quantity"] as int;

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
          } catch (e) {
            print("⚠️ Failed to delete old image: $e");
          }
        }
      }

      final imagePath = await _saveImage(image);
      if (imagePath != null) {
        data["Product_image"] = imagePath;
      }
    }

    final result = await sqldb.update(
      "products",
      data,
      "uuid = ? AND user_id = ?",
      [uuid, id],
    );

    int resultsale = 2;

    if (quantity > 0) {
      resultsale = await sqldb.insert("sales", sale);
    }
    if (result > 0 && resultsale > 0) {
      await _syncService.addToQueue("products", uuid, "update", data);
      if (resultsale == 1) {
        await _syncService.addToQueue(
          "sales",
          sale["uuid"] as String,
          "insert",
          sale,
        );
      }
      return true;
    }

    return false;
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
      "SELECT * FROM products WHERE  user_id = ? AND product_name LIKE ? AND categorie_id = ? AND is_delete = 1 ",
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
        "SELECT * FROM products WHERE product_quantity <= 0 AND user_id = ? AND is_delete = 0 ",
        [id],
      );
    } else {
      result = await sqldb.readData(
        "SELECT * FROM products WHERE categorie_id = ? AND user_id = ? AND is_delete = 0 ",
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
        "SELECT * FROM products WHERE product_quantity <= 0 AND categoris_uuid = ? AND user_id = ? AND is_delete = 0",
        [categorisuuId, id],
      );
    } else {
      result = await sqldb.readData(
        "SELECT * FROM products WHERE categorie_id = ? AND categoris_uuid = ? AND user_id = ? AND is_delete = 0 ",
        [categorieId, categorisuuId, id],
      );
    }

    return result;
  }

  Future<List<Map<String, Object?>>> ShwoProdact(Map data) async {
    final uuid = data['uuid'];

    final result = await sqldb.readData(
      "SELECT * FROM products WHERE user_id = ? AND uuid = ? AND is_delete = 0 ",
      [id, uuid],
    );

    return result;
  }

  Future<bool> deleteProdact(Map<String, Object?> data) async {
    final uuid = data["uuid"]?.toString().trim(); // تأكد string نظيف
    try {
      // 1️⃣ نتأكد المنتج موجود
      final result = await sqldb.readData(
        "SELECT * FROM products WHERE uuid = ? AND user_id = ? LIMIT 1",
        [uuid, id],
      );

      if (result.isEmpty) {
        print("❌ المنتج غير موجود");
        return false;
      }

      final lastSale = await sqldb.readData('''
      SELECT created_at, uuid FROM sales 
      WHERE product_uuid = ? 
        AND user_id = ? 
        AND type_sales = 3
      ORDER BY created_at DESC 
      LIMIT 1
    ''', [uuid, id]);

      if (lastSale.isNotEmpty) {
        final lastDateStr = lastSale.first["created_at"]?.toString() ?? "";
        final lastDate = DateTime.tryParse(lastDateStr);

        if (lastDate != null) {
          final now = DateTime.now();
          final difference = now.difference(lastDate).inHours;

          if (difference < 24) {
            final result = await sqldb.update(
              "sales",
              {
                'is_delete': 1,
                'updated_at': DateTime.now().toIso8601String(),
              },
              "product_uuid = ? AND user_id = ? AND type_sales = 3",
              [uuid, id],
            );

            if (result > 0) {
              await _syncService.addToQueue(
                  "sales", lastSale.first["uuid"] as String, "update", {
                "uuid": lastSale.first["uuid"] as String,
                'is_delete': 1,
                'updated_at': DateTime.now().toIso8601String(),
              });
            }
          }
        }
      }

      final resultup = await sqldb.update(
          "products",
          {
            'is_delete': 1,
          },
          "uuid = ? AND user_id = ?",
          [uuid, id]);

      if (resultup > 0) {
        await _syncService.addToQueue("products", uuid!, "update", {
          "uuid": uuid,
        });
        print("✅ تم حذف المنتج بنجاح");
        return true;
      }
      return false;
    } catch (e) {
      print("❌ خطأ أثناء التحديث: $e");
      return false;
    }
  }
}
