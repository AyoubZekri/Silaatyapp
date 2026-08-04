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
      FROM seller_stock s
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
      await txn.rawUpdate(
          'UPDATE products SET product_quantity = ? WHERE uuid = ?',
          [(currentAdminQty - quantityToSend).toString(), productUuid]);

      // 3. Add to seller stock
      var sellerStockResult = await txn.rawQuery(
          'SELECT id, quantity FROM seller_stock WHERE seller_id = ? AND product_uuid = ? AND user_id = ?',
          [sellerUuid, productUuid, adminIdStr]);

      if (sellerStockResult.isEmpty) {
        // Insert new record
        await txn.rawInsert('''
          INSERT INTO seller_stock (uuid, user_id, seller_id, product_uuid, quantity, created_at, updated_at) 
          VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', [
          _generateUuid(),
          adminId,
          sellerUuid,
          productUuid,
          quantityToSend,
          DateTime.now().toIso8601String(),
          DateTime.now().toIso8601String()
        ]);
      } else {
        // Update existing record
        double currentSellerQty =
            double.parse(sellerStockResult.first['quantity'].toString());
        await txn.rawUpdate(
            'UPDATE seller_stock SET quantity = ?, updated_at = ? WHERE seller_id = ? AND product_uuid = ? AND user_id = ?',
            [
              currentSellerQty + quantityToSend,
              DateTime.now().toIso8601String(),
              sellerUuid,
              productUuid,
              adminIdStr
            ]);
      }

      // 4. Record transfer
      await txn.rawInsert('''
        INSERT INTO stock_transfers (uuid, user_id, seller_id, product_uuid, quantity_sent, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?)
      ''', [
        _generateUuid(),
        adminIdStr,
        sellerUuid,
        productUuid,
        quantityToSend,
        DateTime.now().toIso8601String(),
        DateTime.now().toIso8601String()
      ]);

      success = true;
    });

    return success;
  }

  // Return stock from seller
  Future<bool> returnStockFromSeller(
      String sellerUuid, String productUuid, double quantityToReturn) async {
    final dbClient = await db.db;
    if (dbClient == null) return false;

    bool success = false;
    String adminIdStr = adminId?.toString() ?? "0";

    await dbClient.transaction((txn) async {
      // 1. Check if seller has enough stock
      var sellerStockResult = await txn.rawQuery(
          'SELECT quantity FROM seller_stock WHERE seller_id = ? AND product_uuid = ? AND user_id = ?',
          [sellerUuid, productUuid, adminIdStr]);
      if (sellerStockResult.isEmpty)
        throw Exception("Seller does not have this product");

      double currentSellerQty =
          double.parse(sellerStockResult.first['quantity'].toString());
      if (currentSellerQty < quantityToReturn)
        throw Exception("Seller does not have enough quantity to return");

      // 2. Deduct from seller stock
      await txn.rawUpdate(
          'UPDATE seller_stock SET quantity = ?, updated_at = ? WHERE seller_id = ? AND product_uuid = ? AND user_id = ?',
          [
            currentSellerQty - quantityToReturn,
            DateTime.now().toIso8601String(),
            sellerUuid,
            productUuid,
            adminIdStr
          ]);

      // 3. Add back to admin stock
      var productResult = await txn.rawQuery(
          'SELECT product_quantity FROM products WHERE uuid = ?',
          [productUuid]);
      if (productResult.isNotEmpty) {
        double currentAdminQty = double.tryParse(
                productResult.first['product_quantity'].toString()) ??
            0.0;
        await txn.rawUpdate(
            'UPDATE products SET product_quantity = ? WHERE uuid = ?',
            [(currentAdminQty + quantityToReturn).toString(), productUuid]);
      }

      // 4. Record transfer (negative quantity represents return)
      await txn.rawInsert('''
        INSERT INTO stock_transfers (uuid, user_id, seller_id, product_uuid, quantity_sent, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?)
      ''', [
        _generateUuid(),
        adminIdStr,
        sellerUuid,
        productUuid,
        -quantityToReturn,
        DateTime.now().toIso8601String(),
        DateTime.now().toIso8601String()
      ]);

      success = true;
    });

    return success;
  }
}
