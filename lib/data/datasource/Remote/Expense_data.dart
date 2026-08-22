import 'package:Silaaty/core/class/Crud.dart';
import 'package:Silaaty/core/class/Sqldb.dart';
import 'package:Silaaty/core/class/SyncServer.dart';
import 'package:get/get.dart';

import '../../../core/services/Services.dart';

class ExpenseData {
  Crud crud;
  SQLDB db = SQLDB();
  SyncService syncService = SyncService();
  ExpenseData(this.crud);

  int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");

  Future<Map<String, Object?>> addExpense(Map<String, Object?> data) async {
    try {
      final result = await db.insert("expenses", data);

      if (result > 0) {
        await syncService.addToQueue(
            "expenses", data["uuid"] as String, "insert", data);
        return {"status": 1};
      }
      return {"status": 0};
    } catch (e) {
      print("errer add_data $e");
      return {"status": 0};
    }
  }

  Future<Map<String, Object?>> EditExpense(Map<String, Object?> data) async {
    final uuid = data["uuid"] as String;
    try {
      final result = await db.update("expenses", data, "uuid = ?", [uuid]);

      if (result > 0) {
        await syncService.addToQueue("expenses", uuid, "update", data);
        return {"status": 1};
      }
      return {"status": 0};
    } catch (e) {
      print("Errer Update_data $e");
      return {"status": 0};
    }
  }

  Future<Map<String, Object?>> deleteExpense(Map<String, Object?> data) async {
    final uuid = data["uuid"] as String;
    try {
      final updateData = {
        "uuid": uuid,
        "is_delete": 1,
        "updated_at": DateTime.now().toIso8601String(),
      };
      
      final result = await db.update("expenses", updateData, "uuid = ?", [uuid]);

      if (result > 0) {
        await syncService.addToQueue("expenses", uuid, "update", updateData);
        return {"status": 1};
      }
      return {"status": 0};
    } catch (e) {
      print("Errer delete_data $e");
      return {"status": 0};
    }
  }

  Future<Map<String, Object?>> ShwoExpense() async {
    try {
      final result = await db.readData(
          "SELECT * FROM expenses Where user_id = ? AND is_delete = 0", [id]);
      return {
        "status": 1,
        "data": {"Expense": result}
      };
    } catch (e) {
      print("❌ viewdata error: $e");
      return {"status": 0};
    }
  }

  Future<Map<String, Object?>> ShwoinfoExpense(Map<String, Object?> data) async {
    final uuid = data["uuid"];
    try {
      final result = await db.readData(
          "SELECT * FROM expenses Where user_id = ? AND uuid = ? LIMIT 1",
          [id, uuid]);
      return {
        "status": 1,
        "data": {"Expense": result}
      };
    } catch (e) {
      print("❌ viewdata error: $e");
      return {"status": 0};
    }
  }
}
