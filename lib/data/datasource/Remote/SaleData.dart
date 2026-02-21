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
          final type = sale["type_sales"] as int;

          await txn.rawUpdate(
            '''
          UPDATE products
          SET product_quantity = MAX(product_quantity - ?, 0)
          WHERE uuid = ?
          ''',
            [quantitySold, type == 1 ? 0 : productUuid],
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
      final type = sale['type_sales'] as int;

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
        final diffs = currentProductQty - (type == 1 ? 0 : diff);
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

      int newProductQty = currentProductQty - (type == 1 ? 0 : diff);
      if (diff > 0) {
        newProductQty = currentProductQty - (type == 1 ? 0 : diff);
      } else {
        print("====================diff$diff");
        newProductQty = currentProductQty + (type == 1 ? 0 : (-diff));
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
      final sale = (await db.read('sales')).firstWhere(
          (e) => e['uuid'] == uuidSale,
          orElse: () => <String, dynamic>{});

      if (sale.isEmpty) {
        return {"status": 0, "error": "Sale not found"};
      }
      final int qty = sale['quantity'] as int;
      final String productUuid = sale['product_uuid'];
      final String invoiceUuid = sale['invoie_uuid'];
      final int type = sale['type_sales'] as int;

      final double unitPrice =
          double.tryParse(sale['unit_price']?.toString() ?? '0') ?? 0;

      final double subtotal = unitPrice * qty;

      /// 2. جلب المنتج
      final product = (await db.read('products')).firstWhere(
          (e) => e['uuid'] == productUuid,
          orElse: () => <String, dynamic>{});

      if (product.isNotEmpty) {
        final newProduct = {
          'uuid': productUuid,
          'product_quantity': (type == 1 ? 0 : qty),
          'is_delete': 0,
          'updated_at': DateTime.now().toIso8601String(),
        };

        await db.update(
          'products',
          newProduct,
          "uuid = ? AND user_id = ?",
          [productUuid, id],
        );

        await _syncService.addToQueue(
          'products',
          productUuid,
          'update',
          newProduct,
        );

        final String categoryUuid = product['categoris_uuid']?.toString() ?? '';

        if (categoryUuid.isNotEmpty) {
          final category = (await db.read('categoris')).firstWhere(
            (e) => e['uuid'] == categoryUuid && e['user_id'] == id,
            orElse: () => <String, dynamic>{},
          );

          if (category.isNotEmpty) {
            final isDeleted =
                category['is_delete'] == 1 || category['is_delete'] == "1";

            if (isDeleted) {
              // Restore الفئة
              await db.update(
                'categoris',
                {
                  'is_delete': 0,
                  'updated_at': DateTime.now().toIso8601String(),
                },
                'uuid = ? AND user_id = ?',
                [categoryUuid, id],
              );

              await _syncService.addToQueue(
                'categoris',
                categoryUuid,
                'update',
                {
                  'uuid': categoryUuid,
                  'is_delete': 0,
                },
              );
            }
          }
        }
      }

      final int currentQty =
          int.tryParse(product['product_quantity']?.toString() ?? '0') ?? 0;

      final int newProductQty = currentQty + (type == 1 ? 0 : qty);

      /// 3. جلب الفاتورة
      final invoice = (await db.read('invoies')).firstWhere(
          (e) => e['uuid'] == invoiceUuid,
          orElse: () => <String, dynamic>{});

      if (invoice.isEmpty) {
        return {"status": 0, "error": "Invoice not found"};
      }

      double paymentPrice =
          double.tryParse(invoice['Payment_price']?.toString() ?? '0') ?? 0;

      paymentPrice -= subtotal;
      if (paymentPrice < 0) paymentPrice = 0;

      /// تحقق واش باقي أي منتجات في الفاتورة
      final remainingSales = (await db.read('sales'))
          .where((e) => e['invoie_uuid'] == invoiceUuid)
          .toList();

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

      /// 5. تحديث الفاتورة أو حذفها إذا ما بقى حتى منتج
      int resultInvoice = 1;

      if (remainingSales.length <= 1) {
        // آخر منتج، نحذف الفاتورة
        resultInvoice = await db.delete('invoies', 'uuid = ?', [invoiceUuid]);

        // Sync: حذف الفاتورة
        await _syncService.addToQueue(
          'invoies',
          invoiceUuid,
          'delete',
          {
            'uuid': invoiceUuid,
            'is_delete': 1,
            'updated_at': DateTime.now().toIso8601String(),
          },
        );
      } else {
        // باقي منتجات، نحدث المبلغ فقط
        resultInvoice = await db.update(
          'invoies',
          {
            'Payment_price': paymentPrice,
            'updated_at': DateTime.now().toIso8601String(),
          },
          'uuid = ?',
          [invoiceUuid],
        );

        // Sync: تحديث الفاتورة
        await _syncService.addToQueue(
          'invoies',
          invoiceUuid,
          'update',
          {
            'uuid': invoiceUuid,
            'Payment_price': paymentPrice,
          },
        );
      }

      /// 6. حذف البيع
      final resultSale = await db.delete('sales', 'uuid = ?', [uuidSale]);

      // Sync: حذف البيع
      await _syncService.addToQueue(
        "sales",
        uuidSale,
        "update",
        {
          "uuid": uuidSale,
          'is_delete': 1,
          'updated_at': DateTime.now().toIso8601String(),
        },
      );

      // Sync: تحديث المخزون المنتج
      await _syncService.addToQueue(
        'products',
        productUuid,
        'update',
        {
          'uuid': productUuid,
          'product_quantity': newProductQty,
        },
      );

      if (resultProduct > 0 && resultInvoice > 0 && resultSale > 0) {
        return {
          "status": 1,
          "msg": remainingSales.length <= 1 ? "true" : "false"
        };
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
      final invoice = (await db.read('invoies')).firstWhere(
        (e) => e['uuid'] == invoiceUuid,
        orElse: () => <String, dynamic>{}, // <-- هنا
      );

      print("===================invoice$invoiceUuid");
      if (invoice.isEmpty) {
        return {"status": 0, "error": "Invoice not found"};
      }

      /// 2. جلب جميع أسطر البيع المرتبطة بالفاتورة
      final sales = (await db.read('sales'))
          .where((e) => e['invoie_uuid'] == invoiceUuid)
          .toList();

      print("===================$sales");

      if (sales.isEmpty) {
        /// ما فيهاش منتجات → نحذف الفاتورة مباشرة
        await db.delete('invoies', 'uuid = ?', [invoiceUuid]);

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

        return {"status": 1};
      }

      /// 3. معالجة كل منتج
      for (final sale in sales) {
        final int qty = sale['quantity'] as int;
        final String productUuid = sale['product_uuid'];
        final int type = sale['type_sales'] as int;

        /// جلب المنتج
        final product = (await db.read('products')).firstWhere(
          (e) => e['uuid'] == productUuid,
          orElse: () => <String, dynamic>{},
        );
        if (product.isNotEmpty) {
          final newProduct = {
            'uuid': productUuid,
            'product_quantity': (type == 1 ? 0 : qty),
            'is_delete': 0,
            'updated_at': DateTime.now().toIso8601String(),
          };

          await db.update(
            'products',
            newProduct,
            "uuid = ? AND user_id = ?",
            [productUuid, id],
          );

          await _syncService.addToQueue(
            'products',
            productUuid,
            'update',
            newProduct,
          );

          final String categoryUuid =
              product['categoris_uuid']?.toString() ?? '';

          if (categoryUuid.isNotEmpty) {
            final category = (await db.read('categoris')).firstWhere(
              (e) => e['uuid'] == categoryUuid && e['user_id'] == id,
              orElse: () => <String, dynamic>{},
            );

            if (category.isNotEmpty) {
              final isDeleted =
                  category['is_delete'] == 1 || category['is_delete'] == "1";

              if (isDeleted) {
                // Restore الفئة
                await db.update(
                  'categoris',
                  {
                    'is_delete': 0,
                    'updated_at': DateTime.now().toIso8601String(),
                  },
                  'uuid = ? AND user_id = ?',
                  [categoryUuid, id],
                );

                await _syncService.addToQueue(
                  'categoris',
                  categoryUuid,
                  'update',
                  {
                    'uuid': categoryUuid,
                    'is_delete': 0,
                  },
                );
              }
            }
          }
        }

        final int currentQty =
            int.tryParse(product['product_quantity']?.toString() ?? '0') ?? 0;

        final int newQty = currentQty + (type == 1 ? 0 : qty);

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
          productUuid,
          'update',
          {
            'uuid': productUuid,
            'product_quantity': newQty,
          },
        );

        await _syncService.addToQueue(
          "sales",
          sale['uuid'],
          "update",
          {
            "uuid": sale['uuid'],
            'is_delete': 1,
            'updated_at': DateTime.now().toIso8601String(),
          },
        );
      }

      /// 4. حذف الفاتورة نفسها
      await db.delete('invoies', 'uuid = ?', [invoiceUuid]);

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

      return {"status": 1};
    } catch (e, st) {
      print("❌ Return full invoice error: $e\n$st");
      return {"status": 0, "error": e.toString()};
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
