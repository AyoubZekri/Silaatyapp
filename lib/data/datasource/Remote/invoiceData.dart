import 'package:Silaaty/core/class/Crud.dart';
import 'package:get/get.dart';

import '../../../core/class/Sqldb.dart';
import '../../../core/class/SyncServer.dart';
import '../../../core/services/Services.dart';

class Invoicedata {
  Crud crud;
  final SQLDB db = SQLDB();
  final SyncService _syncService = SyncService();

  int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");

  Invoicedata(this.crud);

  Future<Map<String, dynamic>> addinvoice(Map<String, Object?> data) async {
    final result = await db.insert("invoies", data);
    if (result > 0) {
      await _syncService.addToQueue(
          "invoies", data["uuid"] as String, "insert", data);
      return {"status": 1};
    }

    return {"status": 0};
  }

  Future<bool> Editinvoise(Map<String, Object?> data) async {
    final uuid = data["uuid"] as String;

    final result = await db.update(
      "invoies",
      data,
      "uuid='$uuid'",
    );

    if (result > 0) {
      await _syncService.addToQueue("invoies", uuid, "update", data);
      return true;
    }

    return false;
  }

  Future<Map<String, dynamic>> deleteinvoice(Map<String, Object?> data) async {
    final uuid = data["uuid"] as String;

    // 1. نجيب ID الفاتورة
    final invoice =
        await db.readData("SELECT id FROM invoies WHERE uuid = ?", [uuid]);

    if (invoice.isEmpty) {
      return {"status": 0};
    }

    final result = await db.delete(
      "invoies",
      "uuid = ?",
      [uuid],
    );

    if (result > 0) {
      await _syncService.addToQueue("invoies", uuid, "update", {
        "uuid": uuid,
        'is_delete': 1,
        'updated_at': DateTime.now().toIso8601String(),
      });

      final salesRows = await db
          .readData("SELECT uuid FROM sales WHERE invoie_uuid = ?", [uuid]);

      for (var row in salesRows) {
        await _syncService
            .addToQueue("sales", row["uuid"] as String, "update", {
          "uuid": row["uuid"] as String,
          'is_delete': 1,
          'updated_at': DateTime.now().toIso8601String(),
        });
      }

      await db.delete(
        "sales",
        "invoie_uuid = ?",
        [uuid],
      );

      return {"status": 1};
    }

    return {"status": 0};
  }

  Future<Map<String, dynamic>> allinvoise() async {
    final dbClient = await db.db;
    if (dbClient == null) throw Exception("Database connection is null");

    final invoices = await dbClient.rawQuery('''
  SELECT 
    i.uuid AS invoice_uuid,
    i.Transaction_uuid,
    i.discount,
    i.invoies_numper,
    i.invoies_date,
    i.Payment_price,
    i.user_id,
    IFNULL(SUM(s.subtotal), 0) AS total_sales,
    (IFNULL(SUM(s.subtotal), 0) - IFNULL(i.discount, 0)) AS total_after_discount,
    ((IFNULL(SUM(s.subtotal), 0) - IFNULL(i.discount, 0)) - IFNULL(i.Payment_price, 0)) AS debt,
    t.name,
    t.transactions,
    t.family_name,
    t.phone_number
  FROM invoies i
  LEFT JOIN transactions t 
  ON t.uuid = i.Transaction_uuid        
  LEFT JOIN sales s 
      ON s.invoie_uuid = i.uuid 
      AND s.type_sales = 2                     
  WHERE i.user_id = ?
  GROUP BY i.uuid
  ORDER BY i.invoies_date DESC;
''', [id]);
    return {
      "data": {
        "invoices": invoices,
      }
    };
  }

  Future<Map<String, dynamic>> getMyInvoicesByTransaction(
      Map<String, Object?> data) async {
    final transactionuuId = data["transaction_uuid"];

    final invoices = await db.readData(
      "SELECT * FROM invoies WHERE user_id = ? AND Transaction_uuid = ? ",
      [id, transactionuuId],
    );

    // 2. مجموع الدفع
    final sumPaymentResult = await db.readData(
      "SELECT SUM(Payment_price) as total FROM invoies WHERE user_id = ? AND Transaction_uuid = ? ",
      [id, transactionuuId],
    );
    final sumPaymentPrice = (sumPaymentResult.first["total"] ?? 0) as num;

    // final sumDiscountResult = await db.readData(
    //   "SELECT SUM(discount) as total FROM invoies WHERE user_id = ? AND Transaction_uuid = ?",
    //   [id, transactionuuId],
    // );
    // final sumDiscount = (sumDiscountResult.first["total"] ?? 0) as num;

    // 3. نجيب الترانزكشن
    final transactionResult = await db.readData(
      "SELECT * FROM transactions WHERE user_id = ? AND uuid = ? LIMIT 1 ",
      [id, transactionuuId],
    );

    if (transactionResult.isEmpty) {
      throw Exception("المعاملة غير موجودة");
    }

    final transaction = transactionResult.first;
    // final isPurchase = transaction["transactions"] == 1;

    double sumPrice = 0;
    List<Map<String, dynamic>> invoicesWithSum = [];

    for (var inv in invoices) {
      final invoiceuuId = inv["uuid"];

      final salesSumResult = await db.readData("""
    SELECT SUM(subtotal) as total
    FROM sales
    WHERE invoie_uuid = ? 
  """, [invoiceuuId]);

      final invoiceSum = (salesSumResult.first["total"] ?? 0) as num;
      final invoiceDiscount = (inv["discount"] ?? 0) as num;
      final invoiceFinal = invoiceSum - invoiceDiscount;

      sumPrice += invoiceFinal;

      invoicesWithSum.add({
        ...inv,
        "invoice_sum": invoiceSum,
        "invoice_final": invoiceFinal,
      });
    }

    return {
      "data": {
        "transaction": transaction,
        "invoices": invoicesWithSum,
        "sum_price": sumPrice,
        "sum_payment_Price": sumPaymentPrice,
      }
    };
  }

  Future<Map<String, dynamic>> showInvoice(Map<String, Object?> data) async {
    final invoiceUuid = data["uuid"] as String;

    try {
      final salesRows = await db.readData(
        '''
      SELECT 
        s.uuid,
        s.quantity,
        s.unit_price,
        s.subtotal,
        p.product_name,
        p.product_price
      FROM sales AS s
      INNER JOIN products AS p ON s.product_uuid = p.uuid
      WHERE s.invoie_uuid = ? AND s.is_delete = 0
      ''',
        [invoiceUuid],
      );
      final invoies = await db.readData("""
          SELECT Payment_price,discount
          FROM invoies
          WHERE uuid = ?
        """, [invoiceUuid]);

      double paymentprice = 0.0;
      double discount = 0.0;

      if (invoies.isNotEmpty) {
        paymentprice = double.parse(invoies.first["Payment_price"].toString());
        discount = double.parse(invoies.first["discount"].toString());
      }

      if (salesRows.isEmpty) {
        return {
          "status": 0,
          "message": "لا توجد منتجات مبيوعة في هذه الفاتورة"
        };
      }

      double totalSum = 0;
      for (var item in salesRows) {
        totalSum += double.tryParse(item["subtotal"].toString()) ?? 0;
      }

      return {
        "status": 1,
        "data": {
          "Product": salesRows,
          "sum_price": totalSum,
          "Payment_price": paymentprice,
          "discount": discount,
        }
      };
    } catch (e) {
      return {
        "status": 0,
        "error": "حدث خطأ أثناء جلب المنتجات المبيوعة",
        "message": e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> switchStatus(Map<String, Object?> data) async {
    try {
      final uuid = data['uuid'] as String;

      final existing =
          await db.readData("SELECT * FROM transactions WHERE uuid = '$uuid'");

      if (existing.isEmpty) {
        return {"status": 0, "message": "المعاملة غير موجودة"};
      }

      final currentStatus = existing.first["Status"] ?? 0;
      final newStatus = currentStatus == 0 ? 1 : 0;

      // 2. قلب الحالة وحدثها
      final res = await db.update(
        "transactions",
        {
          "status": newStatus,
          "updated_at": DateTime.now().toIso8601String(),
        },
        "uuid='$uuid'",
      );

      if (res > 0) {
        await _syncService.addToQueue("transactions", uuid, "update", data);
        return {"status": 1, "new_status": newStatus};
      }

      return {"status": 0};
    } catch (e) {
      print("❌ switchStatus local failed: $e");
      return {"status": 0, "message": "خطأ محلي"};
    }
  }
}
