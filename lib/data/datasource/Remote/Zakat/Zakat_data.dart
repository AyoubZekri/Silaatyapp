// import 'package:get/get.dart';

// import '../../../../core/class/Sqldb.dart';
// import '../../../../core/class/SyncServer.dart';
// import '../../../../core/services/Services.dart';

// class ZakatData {
//   final SQLDB db = SQLDB();
//   final SyncService _syncService = SyncService();
//   int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");


//   Future<Map<String, dynamic>> getZakat() async {
//     final zakatRes = await db.readData(
//       "SELECT * FROM zakats WHERE user_id = ? LIMIT 1",
//       [id],
//     );

//     if (zakatRes.isEmpty) {
//       return {"status": 0, "message": "حساب الزكاة غير موجود"};
//     }

//     return {
//       "status": 1,
//       "message": "تم جلب البيانات بنجاح",
//       "data": {"data": zakatRes.first},
//     };
//   }

//   Future<Map<String, Object?>> addCashliquidity(
//       Map<String, Object?> data) async {
//     // تحديث السيولة
//     final result = await db.update(
//       "zakats",
//       data,
//       "user_id = ?",
//       [id],
//     );

//     await calculateZakat(id!);

//     if (result > 0) {
//       await _syncService.addToQueue(
//           "zakats", data['uuid'] as String, "update", data);
//       return {
//         "status": 1,
//       };
//     }

//     return {
//       "status": 0,
//     };
//   }

//   Future<Map<String, dynamic>> calculateZakat(int userId) async {
//     try {
//       // 1. البضائع (categorie_id = 1 فقط)
//       final goodsRes = await db!.readData('''
//         SELECT SUM(product_price_total) as total_goods
//         FROM products
//         WHERE user_id = ?
//         AND categorie_id = 1
//       ''', [userId]);

//       double totalGoods = (goodsRes.first['total_goods'] ?? 0) as double;

//       // 2. ديون الزبائن (transactions = 2, Status = 0)
//       final debtorsRes = await db.readData('''
//         SELECT i.id, i.Payment_price, 
//                (SELECT SUM(product_price_total) FROM products p WHERE p.invoies_uuid = i.uuid AND p.user_id = ?) as products_total
//         FROM invoies i
//         JOIN transactions t ON t.uuid = i.Transaction_uuid
//         WHERE i.user_id = ? AND t.transactions = 2 AND t.Status = 0
//       ''', [userId, userId]);

//       double totalDebtors = 0;
//       for (var row in debtorsRes) {
//         double productsTotal =
//             double.parse((row['products_total'] ?? 0).toString());
//         double paid = double.parse((row['Payment_price'] ?? 0).toString());
//         double netDue = productsTotal - paid;

//         if (netDue > 0) {
//           totalDebtors += netDue;
//         } else if (netDue < 0) {
//           totalDebtors -= netDue.abs(); // خصم
//         }
//       }

//       // 3. ديون الموردين (transactions = 1)
//       final suppliersRes = await db.readData('''
//         SELECT i.id, i.Payment_price, 
//                (SELECT SUM(product_price_total_purchase) FROM products p WHERE p.invoies_uuid = i.uuid AND p.user_id = ?) as products_total
//         FROM invoies i
//         JOIN transactions t ON t.uuid = i.Transaction_uuid
//         WHERE i.user_id = ? AND t.transactions = 1
//       ''', [userId, userId]);

//       double totalSuppliers = 0;
//       for (var row in suppliersRes) {
//         double productsTotal =
//             double.parse((row['products_total'] ?? 0).toString());
//         double paid = double.parse((row['Payment_price'] ?? 0).toString());
//         double netDue = productsTotal - paid;

//         if (netDue > 0) {
//           totalSuppliers += netDue; // عليا دين
//         } else if (netDue < 0) {
//           totalSuppliers -= netDue.abs(); // أصل
//         }
//       }

//       // 4. السيولة النقدية
//       final zakatRes = await db.readData('''
//         SELECT * FROM zakats WHERE user_id = ? LIMIT 1
//       ''', [userId]);

//       if (zakatRes.isEmpty) {
//         return {"status": 0, "message": "حساب الزكاة غير موجود"};
//       }

//       var zakatRow = zakatRes.first;
//       double cash = (zakatRow['zakat_Cash_liquidity'] ?? 0) as double;
//       double zakatPercent = (zakatRow['zakat_due_amount'] ?? 2.5) as double;

//       // 5. إجمالي الأصول
//       double totalAssets = totalGoods + totalDebtors + cash;

//       // 6. خصم ديون الموردين
//       double zakatMal = totalAssets - totalSuppliers;

//       // 7. حساب الزكاة
//       double zakatDue = (zakatMal * zakatPercent) / 100;

//       // 8. تحديث الجدول
//       final result = await db.update(
//         "zakats",
//         {
//           "zakat_total_asset_value": totalGoods,
//           "zakat_total_debts_value": totalSuppliers,
//           "zakat_total_deborts_value": totalDebtors,
//           "zakat_Cash_liquidity": cash,
//           "zakat_due": zakatDue,
//           "updated_at": DateTime.now().toIso8601String()
//         },
//         "id = ?",
//         [zakatRow['id']],
//       );

//       if (result > 0) {
//         await _syncService
//             .addToQueue("zakats", zakatRow['uuid'] as String, "update", {
//           "uuid": zakatRow['uuid'],
//           "id": zakatRow['id'],
//           "zakat_total_asset_value": totalGoods,
//           "zakat_total_debts_value": totalSuppliers,
//           "zakat_total_deborts_value": totalDebtors,
//           "zakat_Cash_liquidity": cash,
//           "zakat_due": zakatDue,
//           "updated_at": DateTime.now().toIso8601String()
//         });
//         return {
//           "status": 1,
//           "message": "تم حساب الزكاة بنجاح",
//           "zakat_mal": zakatMal,
//           "zakat_due": zakatDue,
//         };
//       }

//       return {
//         "status": 0,
//         "message": "فشل حساب الزكاة بنجاح",
//       };
//     } catch (e) {
//       return {
//         "status": 0,
//         "message": "خطأ أثناء حساب الزكاة",
//         "error": e.toString(),
//       };
//     }
//   }
// }
