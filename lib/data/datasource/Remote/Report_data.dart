import 'package:Silaaty/core/class/Crud.dart';
import 'package:Silaaty/core/class/Sqldb.dart';
import 'package:Silaaty/core/class/SyncServer.dart';
import 'package:get/get.dart';

import '../../../core/services/Services.dart';

class ReportData {
  Crud crud;
  SQLDB db = SQLDB();
  SyncService syncService = SyncService();
  ReportData(this.crud);

  int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");

  Future<Map<String, Object?>> addReport(Map<String, Object?> data) async {
    try {
      final result = await db.insert("reports", data);

      if (result > 0) {
        await syncService.addToQueue(
            "reports", data["uuid"] as String, "insert", data);
        return {"status": 1};
      }
      return {"status": 0};
    } catch (e) {
      print("errer add_data $e");
      return {"status": 0};
    }
  }

  Future<Map<String, Object?>> EditReport(Map<String, Object?> data) async {
    final uuid = data["uuid"] as String;
    try {
      final result = await db.update("reports", data, "uuid = ?", [uuid]);

      if (result > 0) {
        await syncService.addToQueue("reports", uuid, "update", data);
        return {"status": 1};
      }
      return {"status": 0};
    } catch (e) {
      print("Errer Updateç_data $e");
      return {"status": 0};
    }
  }

  Future<Map<String, Object?>> deleteReport(Map<String, Object?> data) async {
    final uuid = data["uuid"] as String;
    try {
      final result = await db.delete(
          "reports",
          "uuid = ?",
          [uuid]);

      if (result > 0) {
        await syncService.addToQueue("reports", uuid, "update", data);
        return {"status": 1};
      }
      return {"status": 0};
    } catch (e) {
      print("Errer delete_data $e");
      return {"status": 0};
    }
  }

  Future<Map<String, Object?>> ShwoReport() async {
    try {
      final result = await db.readData(
          "SELECT * FROM reports Where report_id = ?", [id]);
      return {
        "status": 1,
        "data": {"Report": result}
      };
    } catch (e) {
      print("❌ viewdata error: $e");
      return {"status": 0};
    }
  }

  Future<Map<String, Object?>> ShwoinfoReport(Map<String, Object?> data) async {
    final uuid = data["uuid"];
    try {
      final result = await db.readData(
          "SELECT * FROM reports Where report_id = ? AND uuid = ? LIMIT 1",
          [id, uuid]);
      return {
        "status": 1,
        "data": {"Report": result}
      };
    } catch (e) {
      print("❌ viewdata error: $e");
      return {"status": 0};
    }
  }
}
