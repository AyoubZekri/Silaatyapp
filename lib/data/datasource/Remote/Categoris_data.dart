import 'dart:io';
import 'package:Silaaty/core/class/Crud.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/class/Sqldb.dart';
import '../../../core/class/SyncServer.dart';
import '../../../core/services/Services.dart';

class CategorisData {
  Crud crud;
  final SQLDB _db = SQLDB();
  final SyncService _syncService = SyncService();

  int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");

  CategorisData(this.crud);

  /// ✅ عرض البيانات من SQLite
  viewdata() async {
    try {
      if (id == null) {
        print("❌ user_id not found in local storage");
        return [];
      }

      final result = await _db.readData(
        "SELECT * FROM categoris WHERE user_id = ? AND is_delete = 0 ORDER BY created_at ASC",
        [id],
      );

      return result;
    } catch (e) {
      print("❌ viewdata error: $e");
      return [];
    }
  }

  /// ✅ إضافة فئة جديدة
  Future<bool> Adddata(String nameAr, String nameFr, [File? file]) async {
    String? savedImagePath;
    final String uuid = Uuid().v4();

    try {
      if (file != null) {
        final dir = await getApplicationDocumentsDirectory();
        final imagePath =
            "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.png";
        await file.copy(imagePath);
        savedImagePath = imagePath;
      }

      final data = {
        "uuid": uuid,
        "user_id": id,
        "categoris_name": nameAr,
        "categoris_name_fr": nameFr,
        "categoris_image": savedImagePath,
        "created_at": DateTime.now().toIso8601String(),
        "updated_at": DateTime.now().toIso8601String(),
      };

      final result = await _db.insert("categoris", data);

      if (result > 0) {
        await _syncService.addToQueue("categoris", uuid, "insert", data);
        return true;
      }
      return false;
    } catch (e) {
      print("❌ Adddata error: $e");
      return false;
    }
  }

  /// ✅ تعديل فئة
  Future<bool> Updatecat(
    String uuid,
    String nameAr,
    String nameFr, [
    File? file,
  ]) async {
    try {
      String? savedImagePath;

      if (file != null) {
        final dir = await getApplicationDocumentsDirectory();
        final imagePath =
            "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.png";
        await file.copy(imagePath);
        savedImagePath = imagePath;
      }

      final data = {
        "categoris_name": nameAr,
        "categoris_name_fr": nameFr,
        "updated_at": DateTime.now().toIso8601String(),
        if (savedImagePath != null) "categoris_image": savedImagePath,
      };

      final result = await _db.update("categoris", data, "uuid = ?", [uuid]);

      if (result > 0) {
        await _syncService.addToQueue("categoris", uuid, "update", {
          "uuid": uuid,
          ...data,
        });
        return true;
      }
      return false;
    } catch (e) {
      print("❌ Updatecat error: $e");
      return false;
    }
  }

  /// ✅ حذف فئة
  Future<bool> deletecat(String uuid) async {
    try {
      // 1️⃣ جلب الفئة للتأكد من وجودها وغير محذوفة
      final cat = await _db.readData(
          "SELECT id FROM categoris WHERE uuid = ? AND is_delete=0", [uuid]);

      if (cat.isEmpty) return false;

      // 2️⃣ تحديث الفئة → محذوفة
      final result = await _db.update(
          "categoris",
          {
            "uuid": uuid,
            "is_delete": 1,
            "updated_at": DateTime.now().toIso8601String(),
          },
          "uuid = ?",
          [uuid]);

      if (result <= 0) return false;

      // 3️⃣ Sync الفئة
      await _syncService.addToQueue("categoris", uuid, "update", {
        "uuid": uuid,
        'is_delete': 1,
        'updated_at': DateTime.now().toIso8601String(),
      });

      // 4️⃣ جلب كل المنتجات التابعة للفئة
      final products = await _db.readData(
          "SELECT uuid, product_quantity FROM products WHERE categoris_uuid = ? AND user_id = ?",
          [uuid, id]);

      for (var p in products) {
        final productUuid = p["uuid"] as String;
        int remainingQty = int.tryParse(p["product_quantity"].toString()) ?? 0;

        // 5️⃣ جلب كل سطور البيع من type_sales = 3 (stock) من الأخير للأول
        final stockRows = await _db.readData(
          '''
      SELECT uuid, quantity
      FROM sales
      WHERE product_uuid = ?
        AND user_id = ?
        AND type_sales = 3
      ORDER BY created_at DESC
      ''',
          [productUuid, id],
        );

        for (final row in stockRows) {
          if (remainingQty <= 0) break;

          final stockUuid = row["uuid"] as String;
          final stockQty = int.tryParse(row["quantity"].toString()) ?? 0;

          if (stockQty > remainingQty) {
            final newQty = stockQty - remainingQty;

            await _db.update(
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
            // حذف السطر
            await _db.delete("sales", "uuid = ?", [stockUuid]);

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

        // 6️⃣ حذف المنتج نفسه
        await _db.update(
          "products",
          {
            "uuid": productUuid,
            "is_delete": 1,
            "updated_at": DateTime.now().toIso8601String(),
          },
          "uuid = ? AND user_id = ?",
          [productUuid, id],
        );

        await _syncService.addToQueue(
          "products",
          productUuid,
          "update",
          {
            "uuid": productUuid,
            "is_delete": 1,
            "updated_at": DateTime.now().toIso8601String(),
          },
        );
      }

      return true;
    } catch (e, st) {
      print("❌ deletecat error: $e");
      print(st);
      return false;
    }
  }
}
