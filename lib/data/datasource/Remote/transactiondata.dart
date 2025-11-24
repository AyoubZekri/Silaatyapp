import 'package:Silaaty/core/class/Crud.dart';
import 'package:get/get.dart';

import '../../../core/class/Sqldb.dart';
import '../../../core/class/SyncServer.dart';
import '../../../core/services/Services.dart';

class Transactiondata {
  Crud crud;
  final SQLDB _db = SQLDB();
  final SyncService _syncService = SyncService();

  int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");
  Transactiondata(this.crud);

  Future<bool> addtransaction(Map<String, Object?> data) async {
    final uuid = data["uuid"] as String;
    try {
      final result = await _db.insert("transactions", data);

      if (result > 0) {
        await _syncService.addToQueue("transactions", uuid, "insert", data);
        return true;
      }
      return false;
    } catch (e) {
      print("❌ Adddata error: $e");
      return false;
    }
  }

  Future<bool> edittransaction(Map<String, Object?> data) async {
    final uuid = data["uuid"] as String;
    try {
      final updateData = Map<String, Object?>.from(data)..remove("uuid");

      final result = await _db.update(
        "transactions",
        updateData,
        "uuid = ?",
        [uuid],
      );

      if (result > 0) {
        await _syncService.addToQueue("transactions", uuid, "update", data);
        return true;
      }
      return false;
    } catch (e) {
      print("❌ Editdata error: $e");
      return false;
    }
  }

  Future<bool> deletetransaction(Map<String, Object?> data) async {
    final uuid = data["uuid"] as String;
    try {
      final result = await _db.update(
        "transactions",
        {
          'is_delete': 1,
          'updated_at': DateTime.now().toIso8601String(),
        },
        "uuid = ?",
        [uuid],
      );

      await _db.delete(
        "transactions",
        "uuid = ?",
        [uuid],
      );

      if (result > 0) {
        await _syncService.addToQueue("transactions", uuid, "update", {
          "uuid": uuid,
          'is_delete': 1,
          'updated_at': DateTime.now().toIso8601String(),
        });
        return true;
      }
      return false;
    } catch (e) {
      print("❌ DeleteData error: $e");
      return false;
    }
  }

  Future<List<Map<String, Object?>>> showTransactions(
      Map<String, Object?> data) async {
    try {
      final query = data["query"];
      final type = data["transactions"];

      String sql = "SELECT * FROM transactions WHERE 1=1";
      List<dynamic> args = [];

      if (type != null && type.toString().isNotEmpty) {
        sql += " AND transactions = ?";
        args.add(type);
      }

      if (id != null) {
        sql += " AND user_id = ?";
        args.add(id);
      }

      if (query != null && query.toString().isNotEmpty) {
        sql += " AND (name LIKE ? OR family_name LIKE ?)";
        args.addAll(["%$query%", "%$query%"]);
      }

      sql += " ORDER BY updated_at DESC";

      final transactions = await _db.readData(sql, args);

      List<Map<String, Object?>> results = [];

      for (var t in transactions) {
        final transactionId = t["uuid"];

        final invoiesRows = await _db.readData(
          "SELECT id, Payment_price, discount, uuid FROM invoies WHERE user_id = ? AND Transaction_uuid = ?",
          [id, transactionId],
        );

        final invoiceIds = invoiesRows.map((e) => e["uuid"]).toList();

        // حساب مجموع الأسعار من sales لكل الفواتير
        double sumPrice = 0;
        if (invoiceIds.isNotEmpty) {
          final placeholders = List.filled(invoiceIds.length, "?").join(",");
          final salesRows = await _db.readData(
            "SELECT subtotal as price, invoie_uuid FROM sales WHERE invoie_uuid  IN ($placeholders)",
            invoiceIds,
          );

          // جمع الأسعار لكل فاتورة
          for (var sale in salesRows) {
            sumPrice += (sale["price"] as num?)?.toDouble() ?? 0;
          }
        }

        // طرح المدفوعات والخصومات لكل فاتورة
        double totalPaidAndDiscount = 0;
        for (var inv in invoiesRows) {
          double payment = (inv["Payment_price"] as num?)?.toDouble() ?? 0;
          double discount = (inv["discount"] as num?)?.toDouble() ?? 0;
          totalPaidAndDiscount += payment + discount;
        }

        double finalSumPrice = sumPrice - totalPaidAndDiscount;

        results.add({
          "transaction": t,
          "sum_price": double.parse(finalSumPrice.toStringAsFixed(2)),
        });
      }

      return results;
    } catch (e) {
      print("Error in showTransactions: $e");
      return [];
    }
  }
}
