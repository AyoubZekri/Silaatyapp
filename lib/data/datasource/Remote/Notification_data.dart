import 'package:Silaaty/core/class/Crud.dart';
import 'package:get/get.dart';

import '../../../core/class/Sqldb.dart';
import '../../../core/class/SyncServer.dart';
import '../../../core/services/Services.dart';

class NotificationData {
  Crud crud;

  NotificationData(this.crud);
  SQLDB db = SQLDB();
  SyncService syncService = SyncService();

  int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");

  Future<Map<String, Object?>> deleteNotification(
      Map<String, Object?> data) async {
    final uuid = data["uuid"] as String;
    try {
      final result = await db.update(
          "notifications",
          {
            'is_delete': 1,
            'updated_at': DateTime.now().toIso8601String(),
          },
          "uuid = ?",
          [uuid]);

      if (result > 0) {
        await syncService.addToQueue("notifications", uuid, "update", data);
        return {"status": 1};
      }
      return {"status": 0};
    } catch (e) {
      print("Errer delete_data $e");
      return {"status": 0};
    }
  }

  Future<Map<String, Object?>> ShwoNotification() async {
    try {
      final result = await db.readData(
          "SELECT * FROM notifications Where user_id = ? AND is_delete = 0",
          [id]);
      return {
        "status": 1,
        "data": {"Notifications": result}
      };
    } catch (e) {
      print("❌ viewdata error: $e");
      return {"status": 0};
    }
  }

  Future<Map<String, Object?>> ShwoinfoNotification(
      Map<String, Object?> data) async {
    final uuid = data["uuid"];
    try {
      final result = await db.readData(
          "SELECT * FROM notifications Where user_id = ? AND uuid = ? AND is_delete = 0 LIMIT 1",
          [id, uuid]);
      return {
        "status": 1,
        "data": {"Notifications": result}
      };
    } catch (e) {
      print("❌ viewdata error: $e");
      return {"status": 0};
    }
  }
}
