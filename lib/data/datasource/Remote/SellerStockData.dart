import 'dart:math';
import 'package:Silaaty/core/class/Crud.dart';
import 'package:get/get.dart';
import '../../../core/class/Sqldb.dart';
import '../../../core/class/SyncServer.dart';
import '../../../core/services/Services.dart';

class SellerStockData {
  Crud crud;
  final SQLDB db = SQLDB();
  final SyncService _syncService = SyncService();

  int? adminId = Get.find<Myservices>().sharedPreferences?.getInt("id");

  SellerStockData(this.crud);

  String _generateUuid() {
    var random = Random();
    var values = List<int>.generate(16, (i) => random.nextInt(256));
    return values.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  // Fetch admin products
  Future<List<Map<String, dynamic>>> getAdminProducts() async {
    final dbClient = await db.db;
    if (dbClient == null) throw Exception("Database connection is null");

    return await dbClient.rawQuery(
        'SELECT uuid, product_name, product_quantity, type, items_per_carton FROM products WHERE is_delete = 0');
  }

  // Fetch seller stock
  Future<List<Map<String, dynamic>>> getSellerStock(String sellerUuid) async {
    final dbClient = await db.db;
    if (dbClient == null) throw Exception("Database connection is null");

    return await dbClient.rawQuery('''
      SELECT s.uuid, s.product_uuid, s.quantity, p.product_name, p.type, p.items_per_carton 
      FROM seller_stocks s
      LEFT JOIN products p ON s.product_uuid = p.uuid
      WHERE s.seller_id = ? AND s.user_id = ?
    ''', [sellerUuid, adminId]);
  }

  // Fetch seller stock transfers
  Future<List<Map<String, dynamic>>> getSellerTransfers(String sellerUuid) async {
    final dbClient = await db.db;
    if (dbClient == null) throw Exception("Database connection is null");

    return await dbClient.rawQuery('''
      SELECT t.*, p.product_name, p.type, p.items_per_carton
      FROM stock_transfers t
      LEFT JOIN products p ON t.product_uuid = p.uuid
      WHERE t.seller_id = ? AND t.user_id = ?
      ORDER BY t.created_at DESC
    ''', [sellerUuid, adminId?.toString() ?? "0"]);
  }

  // Send stock to seller
  Future<bool> sendStockToSeller(
      String sellerUuid, String productUuid, double quantityToSend) async {
    final dbClient = await db.db;
    if (dbClient == null) return false;

    bool success = false;
    String adminIdStr = adminId?.toString() ?? "0";

    List<Future<void> Function()> syncOperations = [];

    await dbClient.transaction((txn) async {
      // 1. Check if admin has enough stock
      var productResult = await txn.rawQuery(
          'SELECT product_quantity FROM products WHERE uuid = ?',
          [productUuid]);
      if (productResult.isEmpty) throw Exception("Product not found");

      double currentAdminQty =
          double.tryParse(productResult.first['product_quantity'].toString()) ??
              0.0;
      if (currentAdminQty < quantityToSend)
        throw Exception("Not enough quantity in main stock");

      // 2. Deduct from admin stock
      String updatedAdminQty = (currentAdminQty - quantityToSend).toString();
      await txn.rawUpdate(
          'UPDATE products SET product_quantity = ? WHERE uuid = ?',
          [updatedAdminQty, productUuid]);
      syncOperations.add(() => _syncService.addToQueue('products', productUuid, 'update', {
        'product_quantity': updatedAdminQty
      }));

      // 3. Add to seller stock
      var sellerStockResult = await txn.rawQuery(
          'SELECT id, uuid, quantity FROM seller_stocks WHERE seller_id = ? AND product_uuid = ? AND user_id = ?',
          [sellerUuid, productUuid, adminIdStr]);

      if (sellerStockResult.isEmpty) {
        // Insert new record
        String newSellerStockUuid = _generateUuid();
        String now = DateTime.now().toIso8601String();
        await txn.rawInsert('''
          INSERT INTO seller_stocks (uuid, user_id, seller_id, product_uuid, quantity, created_at, updated_at) 
          VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', [
          newSellerStockUuid,
          adminId,
          sellerUuid,
          productUuid,
          quantityToSend,
          now,
          now
        ]);
        syncOperations.add(() => _syncService.addToQueue('seller_stocks', newSellerStockUuid, 'insert', {
          'user_id': adminId,
          'seller_id': sellerUuid,
          'product_uuid': productUuid,
          'quantity': quantityToSend,
          'created_at': now,
          'updated_at': now
        }));
      } else {
        // Update existing record
        String existingUuid = sellerStockResult.first['uuid'].toString();
        double currentSellerQty =
            double.parse(sellerStockResult.first['quantity'].toString());
        String now = DateTime.now().toIso8601String();
        double updatedQty = currentSellerQty + quantityToSend;
        await txn.rawUpdate(
            'UPDATE seller_stocks SET quantity = ?, updated_at = ? WHERE seller_id = ? AND product_uuid = ? AND user_id = ?',
            [
              updatedQty,
              now,
              sellerUuid,
              productUuid,
              adminIdStr
            ]);
        syncOperations.add(() => _syncService.addToQueue('seller_stocks', existingUuid, 'update', {
          'quantity': updatedQty,
          'updated_at': now
        }));
      }

      // 4. Record transfer
      String transferUuid = _generateUuid();
      String transferNow = DateTime.now().toIso8601String();
      await txn.rawInsert('''
        INSERT INTO stock_transfers (uuid, user_id, seller_id, product_uuid, quantity_sent, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?)
      ''', [
        transferUuid,
        adminIdStr,
        sellerUuid,
        productUuid,
        quantityToSend,
        transferNow,
        transferNow
      ]);
      syncOperations.add(() => _syncService.addToQueue('stock_transfers', transferUuid, 'insert', {
        'user_id': adminIdStr,
        'seller_id': sellerUuid,
        'product_uuid': productUuid,
        'quantity_sent': quantityToSend,
        'created_at': transferNow,
        'updated_at': transferNow
      }));

      success = true;
    });

    if (success) {
      for (var op in syncOperations) {
        await op();
      }
    }

    return success;
  }

  // Return stock from seller
  Future<bool> returnStockFromSeller(
      String sellerUuid, String productUuid, double quantityToReturn) async {
    final dbClient = await db.db;
    if (dbClient == null) return false;

    bool success = false;
    String adminIdStr = adminId?.toString() ?? "0";

    List<Future<void> Function()> syncOperations = [];

    await dbClient.transaction((txn) async {
      // 1. Check if seller has enough stock
      var sellerStockResult = await txn.rawQuery(
          'SELECT uuid, quantity FROM seller_stocks WHERE seller_id = ? AND product_uuid = ? AND user_id = ?',
          [sellerUuid, productUuid, adminIdStr]);
      if (sellerStockResult.isEmpty)
        throw Exception("Seller does not have this product");

      String existingUuid = sellerStockResult.first['uuid'].toString();
      double currentSellerQty =
          double.parse(sellerStockResult.first['quantity'].toString());
      if (currentSellerQty < quantityToReturn)
        throw Exception("Seller does not have enough quantity to return");

      // 2. Deduct from seller stock
      String now = DateTime.now().toIso8601String();
      double updatedSellerQty = currentSellerQty - quantityToReturn;
      await txn.rawUpdate(
          'UPDATE seller_stocks SET quantity = ?, updated_at = ? WHERE seller_id = ? AND product_uuid = ? AND user_id = ?',
          [
            updatedSellerQty,
            now,
            sellerUuid,
            productUuid,
            adminIdStr
          ]);
      syncOperations.add(() => _syncService.addToQueue('seller_stocks', existingUuid, 'update', {
        'quantity': updatedSellerQty,
        'updated_at': now
      }));

      // 3. Add back to admin stock
      var productResult = await txn.rawQuery(
          'SELECT product_quantity FROM products WHERE uuid = ?',
          [productUuid]);
      if (productResult.isNotEmpty) {
        double currentAdminQty = double.tryParse(
                productResult.first['product_quantity'].toString()) ??
            0.0;
        String updatedAdminQty = (currentAdminQty + quantityToReturn).toString();
        await txn.rawUpdate(
            'UPDATE products SET product_quantity = ? WHERE uuid = ?',
            [updatedAdminQty, productUuid]);
        syncOperations.add(() => _syncService.addToQueue('products', productUuid, 'update', {
          'product_quantity': updatedAdminQty
        }));
      }

      // 4. Record transfer (negative quantity represents return)
      String transferUuid = _generateUuid();
      String transferNow = DateTime.now().toIso8601String();
      await txn.rawInsert('''
        INSERT INTO stock_transfers (uuid, user_id, seller_id, product_uuid, quantity_sent, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?)
      ''', [
        transferUuid,
        adminIdStr,
        sellerUuid,
        productUuid,
        -quantityToReturn,
        transferNow,
        transferNow
      ]);
      syncOperations.add(() => _syncService.addToQueue('stock_transfers', transferUuid, 'insert', {
        'user_id': adminIdStr,
        'seller_id': sellerUuid,
        'product_uuid': productUuid,
        'quantity_sent': -quantityToReturn,
        'created_at': transferNow,
        'updated_at': transferNow
      }));

      success = true;
    });

    if (success) {
      for (var op in syncOperations) {
        await op();
      }
    }

    return success;
  }
}
