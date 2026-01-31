import 'package:get/get.dart';
import '../../../core/class/Sqldb.dart';
import '../../../core/class/SyncServer.dart';
import '../../../core/services/Services.dart';

class Saledata {
  final SQLDB db = SQLDB();
  final SyncService _syncService = SyncService();

  int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");

  /// إضافة فاتورة مع منتجاتها
  Future<Map<String, dynamic>> addSale(
    Map<String, Object?> invoiceData,
    List<Map<String, Object?>> salesData,
  ) async {
    try {
      final dbClient = await db.db;
      if (dbClient == null) throw Exception("Database connection is null");

      await dbClient.transaction((txn) async {
        int invoiceResult = await txn.insert("invoies", invoiceData);
        if (invoiceResult <= 0) throw Exception("Failed to insert invoice");
        for (var sale in salesData) {
          await txn.insert("sales", sale);

          final productUuid = sale["product_uuid"] as String;
          final quantitySold = sale["quantity"] as int;

          await txn.rawUpdate(
            '''
          UPDATE products
          SET product_quantity = MAX(product_quantity - ?, 0)
          WHERE uuid = ?
          ''',
            [quantitySold, productUuid],
          );
        }
      });

      await _syncService.addToQueue(
        "invoies",
        invoiceData["uuid"] as String,
        "insert",
        invoiceData,
      );

      for (var sale in salesData) {
        await _syncService.addToQueue(
          "sales",
          sale["uuid"] as String,
          "insert",
          sale,
        );
        final productUuid = sale["product_uuid"] as String;
        final result = await db.readData(
          '''
          SELECT product_quantity 
          from products
          WHERE uuid = ?
          ''',
          [productUuid],
        );

        final currentQuantity = result[0]["product_quantity"] as String;
        final updatedProductData = {
          "uuid": productUuid,
          "product_quantity": currentQuantity,
        };

        await _syncService.addToQueue(
          "products",
          productUuid,
          "insert",
          updatedProductData,
        );
      }

      print("✅ Transaction completed successfully");
      return {"status": 1};
    } catch (e, st) {
      print("❌ Database error: $e\n$st");
      return {"status": 0, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateSaleQuantity(
      String uuidSale, int newQty, double RemainingAmount) async {
    try {
      final sale = (await db.read(
        'sales',
      ))
          .firstWhere((e) => e['uuid'] == uuidSale);

      if (sale.isEmpty) {
        return {"status": 0, "error": "Sale not found"};
      }

      final oldQty = sale['quantity'] as int;
      final productUuid = sale['product_uuid'] as String;
      final invoiceUuid = sale['invoie_uuid'] as String;

      final double unitPrice =
          double.tryParse(sale['unit_price']?.toString() ?? "0") ?? 0;

      final product = (await db.read('products'))
          .firstWhere((e) => e['uuid'] == productUuid);

      if (product.isEmpty) {
        return {"status": 0, "error": "Product not found"};
      }

      final currentProductQty =
          int.tryParse(product['product_quantity']?.toString() ?? "0") ?? 0;

      final invoice = (await db.read("invoies")).firstWhere(
          (e) => e["uuid"] == invoiceUuid,
          orElse: () => <String, Object?>{});

      if (invoice.isEmpty) {
        return {"status": 0, "error": "Invoice not found"};
      }

      double paymentPrice =
          double.tryParse(invoice['Payment_price']?.toString() ?? "0") ?? 0;

      final diff = newQty - oldQty;

      if (diff > 0) {
        final diffs = currentProductQty - diff;
        if (diffs < 0) {
          return {"status": 2};
        }
      }

      final result1 = await db.update(
        'sales',
        {
          'quantity': newQty,
          "subtotal": unitPrice * newQty,
          'updated_at': DateTime.now().toIso8601String(),
        },
        'uuid = ?',
        [uuidSale],
      );

      int newProductQty = currentProductQty - diff;
      if (diff > 0) {
        newProductQty = currentProductQty - diff;
      } else {
        print("====================diff$diff");
        newProductQty = currentProductQty + (-diff);
        final subtotal = unitPrice * (-diff);
        if (RemainingAmount == 0) {
          paymentPrice -= subtotal;
        } else if (subtotal > RemainingAmount) {
          paymentPrice -= (subtotal - RemainingAmount);
        } else {}
      }

      final result2 = await db.update(
        'products',
        {
          'product_quantity': newProductQty,
          'updated_at': DateTime.now().toIso8601String()
        },
        'uuid = ?',
        [productUuid],
      );

      final resultInv = await db.update(
        "invoies",
        {
          "Payment_price": paymentPrice,
          "updated_at": DateTime.now().toIso8601String(),
        },
        "uuid = ?",
        [invoiceUuid],
      );

      if (result2 > 0 && result1 > 0 && resultInv > 0) {
        await _syncService.addToQueue(
          "sales",
          "update",
          uuidSale,
          {
            "uuid": uuidSale,
            'quantity': newQty,
            "subtotal": unitPrice * newQty,
            'updated_at': DateTime.now().toIso8601String(),
          },
        );
        await _syncService.addToQueue(
          "products",
          "update",
          productUuid,
          {
            "uuid": productUuid,
            'product_quantity': newProductQty,
            'updated_at': DateTime.now().toIso8601String()
          },
        );

        await _syncService.addToQueue(
          "invoies",
          invoiceUuid,
          "update",
          {
            "uuid": invoiceUuid,
            "Payment_price": paymentPrice,
          },
        );

        return {"status": 1};
      }

      return {"status": 0};
    } catch (e, st) {
      print("❌ Update Sale error: $e\n$st");
      return {"status": 0, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> returnSaleProduct(String uuidSale) async {
    try {
      /// 1. جلب عملية البيع
      final sale = (await db.read('sales'))
          .firstWhere((e) => e['uuid'] == uuidSale, orElse: () => {});

      if (sale.isEmpty) {
        return {"status": 0, "error": "Sale not found"};
      }

      final int qty = sale['quantity'] as int;
      final String productUuid = sale['product_uuid'];
      final String invoiceUuid = sale['invoie_uuid'];

      final double unitPrice =
          double.tryParse(sale['unit_price']?.toString() ?? '0') ?? 0;

      final double subtotal = unitPrice * qty;

      /// 2. جلب المنتج
      final product = (await db.read('products'))
          .firstWhere((e) => e['uuid'] == productUuid, orElse: () => {});

      if (product.isEmpty) {
        return {"status": 0, "error": "Product not found"};
      }

      final int currentQty =
          int.tryParse(product['product_quantity']?.toString() ?? '0') ?? 0;

      final int newProductQty = currentQty + qty;

      /// 3. جلب الفاتورة
      final invoice = (await db.read('invoies'))
          .firstWhere((e) => e['uuid'] == invoiceUuid, orElse: () => {});

      if (invoice.isEmpty) {
        return {"status": 0, "error": "Invoice not found"};
      }

      double paymentPrice =
          double.tryParse(invoice['Payment_price']?.toString() ?? '0') ?? 0;

      paymentPrice -= subtotal;
      if (paymentPrice < 0) paymentPrice = 0;

      /// 4. تحديث المخزون
      final resultProduct = await db.update(
        'products',
        {
          'product_quantity': newProductQty,
          'updated_at': DateTime.now().toIso8601String(),
        },
        'uuid = ?',
        [productUuid],
      );

      /// 5. تحديث الفاتورة
      final resultInvoice = await db.update(
        'invoies',
        {
          'Payment_price': paymentPrice,
          'updated_at': DateTime.now().toIso8601String(),
        },
        'uuid = ?',
        [invoiceUuid],
      );

      /// 6. حذف البيع
      final resultSale = await db.delete('sales', 'uuid = ?', [uuidSale]);

      if (resultProduct > 0 && resultInvoice > 0 && resultSale > 0) {
        /// Sync
        await _syncService.addToQueue(
          'sales',
          'delete',
          uuidSale,
          {'uuid': uuidSale},
        );

        await _syncService.addToQueue(
          'products',
          'update',
          productUuid,
          {
            'uuid': productUuid,
            'product_quantity': newProductQty,
          },
        );

        await _syncService.addToQueue(
          'invoies',
          'update',
          invoiceUuid,
          {
            'uuid': invoiceUuid,
            'Payment_price': paymentPrice,
          },
        );

        return {"status": 1};
      }

      return {"status": 0};
    } catch (e, st) {
      print("❌ Return Sale error: $e\n$st");
      return {"status": 0, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> returnFullInvoice(String invoiceUuid) async {
    try {
      /// 1. جلب الفاتورة
      final invoice = (await db.read('invoies'))
          .firstWhere((e) => e['uuid'] == invoiceUuid, orElse: () => {});

      if (invoice.isEmpty) {
        return {"status": 0, "error": "Invoice not found"};
      }

      /// 2. جلب جميع أسطر البيع المرتبطة بالفاتورة
      final sales = (await db.read('sales'))
          .where((e) => e['invoie_uuid'] == invoiceUuid)
          .toList();

      if (sales.isEmpty) {
        /// ما فيهاش منتجات → نحذف الفاتورة مباشرة
        await db.delete('invoies', 'uuid = ?', [invoiceUuid]);

        await _syncService.addToQueue(
          'invoies',
          'delete',
          invoiceUuid,
          {'uuid': invoiceUuid},
        );

        return {"status": 1};
      }

      /// 3. معالجة كل منتج
      for (final sale in sales) {
        final int qty = sale['quantity'] as int;
        final String productUuid = sale['product_uuid'];

        /// جلب المنتج
        final product = (await db.read('products'))
            .firstWhere((e) => e['uuid'] == productUuid, orElse: () => {});

        if (product.isEmpty) continue;

        final int currentQty =
            int.tryParse(product['product_quantity']?.toString() ?? '0') ?? 0;

        final int newQty = currentQty + qty;

        /// تحديث المخزون
        await db.update(
          'products',
          {
            'product_quantity': newQty,
            'updated_at': DateTime.now().toIso8601String(),
          },
          'uuid = ?',
          [productUuid],
        );

        /// حذف سطر البيع
        await db.delete('sales', 'uuid = ?', [sale['uuid']]);

        /// Sync
        await _syncService.addToQueue(
          'products',
          'update',
          productUuid,
          {
            'uuid': productUuid,
            'product_quantity': newQty,
          },
        );

        await _syncService.addToQueue(
          'sales',
          'delete',
          sale['uuid'],
          {'uuid': sale['uuid']},
        );
      }

      /// 4. حذف الفاتورة نفسها
      await db.delete('invoies', 'uuid = ?', [invoiceUuid]);

      await _syncService.addToQueue(
        'invoies',
        'delete',
        invoiceUuid,
        {'uuid': invoiceUuid},
      );

      return {"status": 1};
    } catch (e, st) {
      print("❌ Return full invoice error: $e\n$st");
      return {"status": 0, "error": e.toString()};
    }
  }

  Future<bool> deleteProdact(Map<String, Object?> data) async {
    final uuid = data["uuid"]?.toString().trim();
    final RemainingAmount = data["RemainingAmount"] as double;

    try {
      final salesList = await db.read('sales');
      final sale = salesList.firstWhere(
        (e) => e['uuid'] == uuid,
        orElse: () => <String, Object?>{},
      );

      if (sale.isEmpty) return false;

      final int qty = int.tryParse(sale['quantity']?.toString() ?? "0") ?? 0;
      final double? subtotal =
          double.tryParse(sale['subtotal']?.toString() ?? "0");
      final String productuuId = sale['product_uuid'] as String;
      final String invoiceUuid = sale['invoie_uuid'] as String;

      final invoices = await db.read('invoies');
      final invoice = invoices.firstWhere(
        (i) => i['uuid'] == invoiceUuid,
        orElse: () => <String, Object?>{},
      );

      if (invoice.isEmpty) return false;

      final products = await db.read('products');
      final product = products.firstWhere((p) => p['uuid'] == productuuId,
          orElse: () => <String, Object?>{});

      if (product.isEmpty) {
        return false;
      }
      double paymentPrice =
          double.tryParse(invoice['Payment_price']?.toString() ?? "0") ?? 0;
      final currentQty =
          int.tryParse(product['product_quantity']?.toString() ?? "0") ?? 0;
      final newQty = currentQty + qty;
      print("===================quan$currentQty");
      print("===================quan$newQty");

      await db.update(
        'products',
        {
          'product_quantity': newQty,
          'updated_at': DateTime.now().toIso8601String(),
        },
        'uuid = ?',
        [productuuId],
      );

      if (RemainingAmount == 0) {
        // نقص كامل الـ subtotal
        paymentPrice -= subtotal!;
      } else if (subtotal! > RemainingAmount) {
        // نقص مقدار الفرق فقط
        paymentPrice -= (subtotal - RemainingAmount);
      } else {
        // لا شيء
      }

      if (paymentPrice < 0) paymentPrice = 0;

      final resultup = await db.delete("sales", "uuid = ?", [uuid]);

      await db.update(
        "invoies",
        {
          "Payment_price": paymentPrice,
          "updated_at": DateTime.now().toIso8601String(),
        },
        "uuid = ?",
        [invoiceUuid],
      );

      final remainingSalesForInvoice = await db.readData(
        "SELECT COUNT(*) as cnt FROM sales WHERE invoie_uuid = ?",
        [invoiceUuid],
      );

      final int count = remainingSalesForInvoice.first['cnt'] as int;

      if (count == 0) {
        await db.delete("invoies", "uuid = ?", [invoiceUuid]);

        await _syncService.addToQueue(
          "invoies",
          invoiceUuid,
          "update",
          {
            "uuid": invoiceUuid,
            'is_delete': 1,
            'updated_at': DateTime.now().toIso8601String(),
          },
        );
      }

      if (resultup > 0) {
        await _syncService.addToQueue(
          "sales",
          uuid!,
          "update",
          {
            "uuid": uuid,
            'is_delete': 1,
            'updated_at': DateTime.now().toIso8601String(),
          },
        );
        await _syncService.addToQueue(
          "products",
          productuuId,
          "update",
          {
            "uuid": productuuId,
            'product_quantity': newQty,
            'updated_at': DateTime.now().toIso8601String(),
          },
        );

        if (count != 0) {
          await _syncService.addToQueue(
            "invoices",
            invoiceUuid,
            "update",
            {
              "uuid": invoiceUuid,
              "Payment_price": paymentPrice,
              "updated_at": DateTime.now().toIso8601String(),
            },
          );
        }
        return true;
      }
      return false;
    } catch (e) {
      print("❌ Error deleting sale: $e");
      return false;
    }
  }

  Future<List<Map<String, Object?>>> searchpro(Map data) async {
    final query = data["codepar"];

    final result = await db.readData(
      "SELECT * FROM products WHERE  user_id = ? AND codepar LIKE ? ",
      [id, '%$query%'],
    );
    return result;
  }
}
