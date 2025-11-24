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
        "SELECT * FROM categoris WHERE user_id = ? ORDER BY created_at ASC",
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
      final cat =
          await _db.readData("SELECT id FROM categoris WHERE uuid = ?", [uuid]);

      if (cat.isEmpty) return false;

      final result = await _db.delete("categoris", "uuid = ?", [uuid]);

      if (result > 0) {
        await _syncService.addToQueue("categoris", uuid, "update", {
          "uuid": uuid,
          'is_delete': 1,
          'updated_at': DateTime.now().toIso8601String(),
        });

        final products = await _db.readData(
            "SELECT uuid FROM products WHERE categoris_uuid = ?", [uuid]);

        for (var p in products) {
          await _syncService
              .addToQueue("products", p["uuid"] as String, "update", {
            "uuid": p["uuid"] as String,
            'is_delete': 1,
            'updated_at': DateTime.now().toIso8601String(),
          });
        }

        await _db.delete("products", "categoris_uuid = ?", [uuid]);

        return true;
      }

      return false;
    } catch (e) {
      print("❌ deletecat error: $e");
      return false;
    }
  }
}
