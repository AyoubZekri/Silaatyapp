import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLDB {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database> intialDb() async {
    String dataBais = await getDatabasesPath();
    String path = join(dataBais, 'Silaaty.db');
    Database mydb = await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onUpgrade: _onUpgrade,
    );
    return mydb;
  }

  Future<void> _onUpgrade(Database db, int oldversion, int newVersion) async {
    print("_onUpgrade ===============");
  }

  Future<void> _onCreate(Database db, int version) async {
    Batch batch = db.batch();

    /// جدول التصنيفات
    batch.execute('''
    CREATE TABLE categoris(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      uuid TEXT UNIQUE,
      user_id INTEGER NOT NULL,
      categoris_name TEXT NOT NULL,
      categoris_name_fr TEXT NOT NULL,
      categoris_image TEXT,
      is_delete INTEGER NOT NULL DEFAULT 0,
      created_at TEXT,
      updated_at TEXT
    )
  ''');

    /// جدول الفواتير
    batch.execute('''
    CREATE TABLE invoies(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      uuid TEXT UNIQUE,
      Transaction_uuid TEXT, 
      user_id INTEGER NOT NULL,
      invoies_numper TEXT NOT NULL,
      invoies_date TEXT NOT NULL,
      invoies_payment_date TEXT NOT NULL,
      Payment_price INTEGER NOT NULL DEFAULT 0,
      discount REAL DEFAULT 0,
      is_delete INTEGER NOT NULL DEFAULT 0,
      created_at TEXT,
      updated_at TEXT
    )
  ''');

    /// جدول الإشعارات
    batch.execute('''
    CREATE TABLE notifications(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      uuid TEXT UNIQUE,
      title TEXT NOT NULL,
      content TEXT NOT NULL,
      is_read INTEGER NOT NULL DEFAULT 0,
      user_id INTEGER NOT NULL,
      is_delete INTEGER NOT NULL DEFAULT 0,
      created_at TEXT DEFAULT CURRENT_TIMESTAMP,
      updated_at TEXT DEFAULT CURRENT_TIMESTAMP
    )
  ''');

    /// جدول المنتجات
    batch.execute('''
    CREATE TABLE products(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      uuid TEXT UNIQUE,
      categorie_id INTEGER NOT NULL,
      user_id INTEGER NOT NULL,
      invoies_uuid TEXT,
      categoris_uuid TEXT,
      product_name TEXT NOT NULL,
      Product_image TEXT,
      product_description TEXT,
      product_quantity TEXT NOT NULL,
      product_price REAL DEFAULT 0.00,
      product_price_purchase REAL DEFAULT 0.00,
      product_price_total_purchase REAL,
      product_price_total REAL,
      codepar INTEGER,
      is_delete INTEGER NOT NULL DEFAULT 0,
      created_at TEXT,
      updated_at TEXT
    )
  ''');

    /// جدول التقارير
    batch.execute('''
    CREATE TABLE reports(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      uuid TEXT UNIQUE,
      report_id INTEGER NOT NULL,
      report TEXT NOT NULL,
      is_delete INTEGER NOT NULL DEFAULT 0,
      created_at TEXT,
      updated_at TEXT
    )
  ''');

    /// جدول المعاملات
    batch.execute('''
    CREATE TABLE transactions(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      uuid TEXT UNIQUE,
      user_id INTEGER NOT NULL,
      name TEXT NOT NULL,
      family_name TEXT NOT NULL,
      phone_number TEXT NOT NULL,
      transactions INTEGER NOT NULL,
      is_delete INTEGER NOT NULL DEFAULT 0,
      created_at TEXT,
      updated_at TEXT,
      Status INTEGER NOT NULL DEFAULT 0
    )
  ''');

    /// جدول الزكاة
    batch.execute('''
    CREATE TABLE zakats(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      uuid TEXT UNIQUE,
      user_id INTEGER NOT NULL,
      zakat_nisab REAL NOT NULL DEFAULT 0.00,
      zakat_total_asset_value REAL NOT NULL DEFAULT 0.00,
      zakat_due_amount REAL NOT NULL DEFAULT 2.5,
      zakat_due REAL NOT NULL DEFAULT 0.00,
      created_at TEXT,
      updated_at TEXT,
      zakat_total_debts_value REAL NOT NULL DEFAULT 0.00,
      zakat_total_deborts_value REAL NOT NULL DEFAULT 0.00,
      zakat_Cash_liquidity REAL NOT NULL DEFAULT 0.00
    )
  ''');
    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT,
        invoie_uuid TEXT,
        product_uuid TEXT,
        user_id INTEGER NOT NULL,
        quantity INTEGER DEFAULT 1,
        unit_price REAL DEFAULT 0,
        subtotal REAL DEFAULT 0,
        type_sales INTEGER,
        is_delete INTEGER NOT NULL DEFAULT 0,
        created_at TEXT,
        updated_at TEXT
      );
    ''');

    // ==============================
    // جداول خاصة بالمزامنة
    // ==============================

    /// جدول العمليات (queue)
    batch.execute('''
    CREATE TABLE sync_queue(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      table_name TEXT NOT NULL,
      row_id TEXT NOT NULL,
      operation TEXT NOT NULL, -- insert/update/delete
      data TEXT, -- JSON مخزن فيه البيانات (عند insert/update)
      created_at TEXT DEFAULT CURRENT_TIMESTAMP,
      synced INTEGER DEFAULT 0 -- 0: مازال، 1: تزامن
    )
  ''');

    /// جدول الميتاداتا (آخر وقت تزامن)
    batch.execute('''
    CREATE TABLE sync_metadata(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      table_name TEXT NOT NULL,
      last_sync TEXT,
      user_id INTEGER NOT NULL
    )
  ''');

    await batch.commit();
    print(
        'Database and tables (with sync) created successfully ======================');
  }

  // CRUD METHODS =============================================

  Future<List<Map<String, Object?>>> readData(String sql,
      [List<Object?>? arguments]) async {
    Database? mydb = await db;
    return await mydb!.rawQuery(sql, arguments);
  }

  Future<int> insertData(String sql) async {
    Database? mydb = await db;
    return await mydb!.rawInsert(sql);
  }

  Future<int> updateData(String sql, List list) async {
    Database? mydb = await db;
    return await mydb!.rawUpdate(sql);
  }

  Future<int> deleteData(String sql) async {
    Database? mydb = await db;
    return await mydb!.rawDelete(sql);
  }

  Future<void> mydeleteDatebase() async {
    String dataBais = await getDatabasesPath();
    String path = join(dataBais, 'Silaaty.db');
    await deleteDatabase(path);
  }

  Future<List<Map>> read(String table) async {
    Database? mydb = await db;
    return await mydb!.query(table);
  }

  Future<int> insert(String table, Map<String, Object?> values) async {
    Database? mydb = await db;
    return await mydb!.insert(table, values);
  }

  Future<int> update(
    String table,
    Map<String, Object?> values,
    String? where, [
    List<Object?>? whereArgs,
  ]) async {
    Database? mydb = await db;
    return await mydb!
        .update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
    String table,
    String? where, [
    List<Object?>? whereArgs,
  ]) async {
    Database? mydb = await db;
    return await mydb!.delete(table, where: where, whereArgs: whereArgs);
  }
}
