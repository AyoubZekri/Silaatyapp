import 'package:get/get.dart';

import '../../../core/class/Sqldb.dart';
import '../../../core/class/SyncServer.dart';
import '../../../core/services/Services.dart';

class Statisticsdata {
  SQLDB db = SQLDB();
  SyncService syncService = SyncService();

  int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");

  Future<Map<String, Object?>> statisticsHome() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);

    // عدد فواتير الزبائن فقط
        final invoicesCount = await db.readData('''
          SELECT COUNT(*) as count 
          FROM invoies i
          LEFT JOIN transactions t ON t.uuid = i.Transaction_uuid
          WHERE i.user_id = ?
            AND (i.Transaction_uuid IS NULL OR t.transactions = 2)
            AND i.invoies_date LIKE ?
    ''', [id, '$today%']);

    final totalIncome = await db.readData('''
    SELECT IFNULL(SUM(i.Payment_price), 0) as totalIncome
    FROM invoies i
    LEFT JOIN transactions t ON t.uuid = i.Transaction_uuid
    WHERE i.user_id = ?
    AND (i.Transaction_uuid IS NULL OR t.transactions = 2)    
    AND i.invoies_date LIKE '$today%'
  ''', [id]);

    final netProfit = await db.readData('''
    SELECT IFNULL(SUM((s.unit_price - p.product_price_purchase) * s.quantity), 0) as netProfit
    FROM sales s
    JOIN products p ON s.product_uuid = p.uuid
    JOIN invoies i ON s.invoie_uuid = i.uuid
    WHERE s.user_id = ?
    AND s.type_sales = 2
    AND s.is_delete = 0
    AND i.invoies_date LIKE '$today%'
  ''', [id]);

    final lowStock = await db.readData('''
    SELECT COUNT(*) as lowStock
    FROM products
    WHERE user_id = ?
    AND is_delete = 0
    AND CAST(product_quantity AS INTEGER) < 10 AND categorie_id = 1
  ''', [id]);

    return {
      "todayInvoices": invoicesCount[0]["count"] ?? 0,
      "todayIncome": totalIncome[0]["totalIncome"] ?? 0,
      "todayNetProfit": netProfit[0]["netProfit"] ?? 0,
      "lowStockCount": lowStock[0]["lowStock"] ?? 0,
    };
  }

  Future<List<Map<String, dynamic>>> getChartStats(int type) async {
    String dateCondition;
    String groupBy;

    switch (type) {
      case 1: // اليوم
        dateCondition =
            "i.created_at LIKE '${DateTime.now().toIso8601String().substring(0, 10)}%'";
        groupBy = "strftime('%H', i.created_at)";
        break;
      case 2: // آخر 7 أيام
        dateCondition = "i.created_at >= date('now', '-6 days')";
        groupBy = "strftime('%w', i.created_at)";
        break;
      case 3: // هذا الشهر
        dateCondition =
            "strftime('%Y-%m', i.created_at) = strftime('%Y-%m', 'now')";
        groupBy = "strftime('%d', i.created_at)";
        break;
      default: // هذا العام
        dateCondition = "strftime('%Y', i.created_at) = strftime('%Y', 'now')";
        groupBy = "strftime('%m', i.created_at)";
    }

    // بيانات الرسم البياني
    String queryGraph = """
    SELECT $groupBy AS x, SUM(s.subtotal) AS y
    FROM invoies i
    JOIN transactions t ON t.uuid = i.Transaction_uuid
    JOIN sales s ON s.invoie_uuid = i.uuid
    WHERE i.user_id = ? AND t.transactions = 2 
    AND $dateCondition 
    GROUP BY x ORDER BY x
  """;

    // الإحصائيات العامة
    String queryStats = """
    SELECT
      SUM(CASE WHEN i.type_sales = 2 THEN i.subtotal ELSE 0 END) AS total_sales,
      SUM(CASE WHEN i.type_sales = 2 THEN (i.unit_price - p.product_price_purchase) * i.quantity ELSE 0 END) AS total_profit,
      SUM(CASE WHEN i.type_sales = 3 THEN i.subtotal ELSE 0 END) AS total_expenses
    FROM sales i
    LEFT JOIN products p ON p.uuid = i.product_uuid
    WHERE i.user_id = ? AND $dateCondition 
  """;

    final resultGraph = await db.readData(queryGraph, [id]);
    final resultStats = await db.readData(queryStats, [id]);

    return [
      {
        "chart": resultGraph.isEmpty
            ? [
                {"x": 0, "y": 0}
              ]
            : resultGraph,
        "stats": resultStats.isNotEmpty
            ? resultStats.first
            : {
                "total_sales": 0,
                "total_profit": 0,
                "total_expenses": 0,
                "total_invoices": 0,
              },
      }
    ];
  }

  Future<Map<String, dynamic>> loadFinanceData({
    DateTime? from,
    DateTime? to,
    String? filter,
  }) async {
    final result = getDateRangeClause(
      id,
      filter: filter,
      t: "i",
      from: from,
      to: to,
    );

    final result2 = getDateRangeClause(
      id,
      filter: filter,
      t: "s",
      from: from,
      to: to,
    );

    final whereClause = result['where'];
    final whereClause2 = result2['where'];
    final args = result['args'];
    final DateTime start = from ?? DateTime.parse(args[1]);
    final DateTime end = to ?? DateTime.parse(args[2]);

    // 🔹 صافي الربح
    final netProfit = await db.readData('''
    SELECT IFNULL(SUM((s.unit_price - p.product_price_purchase) * s.quantity), 0) as net_profit
    FROM sales s
    JOIN products p ON s.product_uuid = p.uuid
    WHERE s.user_id = ? AND s.type_sales = 2 $whereClause2 AND s.is_delete = 0
  ''', args);

    // 🔹 إجمالي الإيرادات
    final totalRevenue = await db.readData('''
    SELECT IFNULL(SUM(s.unit_price * s.quantity), 0) as total_revenue
    FROM sales s
    WHERE s.user_id = ? AND s.type_sales = 3 $whereClause2 AND s.is_delete = 0
  ''', args);

    // 🔹 المصروفات
    final expenses = await db.readData('''
    SELECT IFNULL(SUM(Payment_price - discount), 0) as total_expenses
    FROM invoies i
    JOIN transactions t ON i.Transaction_uuid = t.uuid
    WHERE i.user_id = ? AND t.transactions = 1 $whereClause 
  ''', args);

    // 🔹 عدد الفواتير
    final invoices = await db.readData('''
    SELECT COUNT(*) as total_invoices
    FROM invoies i
    JOIN transactions t ON i.Transaction_uuid = t.uuid
    WHERE i.user_id = ? AND t.transactions = 2 $whereClause 

  ''', args);

    // 🔹 نوع التجميع
    String getGroupingType() {
      switch (filter) {
        case 'this_year':
        case 'last_year':
          return 'year';
        case 'this_month':
        case 'last_month':
        case 'last_30_days':
        case 'last_7_days':
          return 'month';
        case 'today':
        case 'yesterday':
          return 'day';
        case 'custom':
          final diff = to!.difference(from!).inDays;
          if (diff > 60) return 'year';
          if (diff > 7) return 'month';
          if (diff > 1) return 'day';
          return 'hour';
        default:
          return 'month';
      }
    }

    String groupByFormat;
    switch (getGroupingType()) {
      case 'year':
        groupByFormat = '%Y-%m';
        break;
      case 'month':
        groupByFormat = '%Y-%m-%d';
        break;
      case 'day':
        groupByFormat = '%Y-%m-%d %H';
        break;
      case 'hour':
        groupByFormat = '%Y-%m-%d %H:%M';
        break;
      default:
        groupByFormat = '%Y-%m-%d';
    }

    // 🔹 البيانات المفصلة (Public Finance)
    final publicfinance = await db.readData('''
        SELECT 
          strftime('$groupByFormat', i.created_at) AS period, 
          
          -- المبيعات الإجمالية
          IFNULL(SUM(CASE WHEN s.type_sales = 2 THEN s.unit_price * s.quantity ELSE 0 END), 0) AS total_sales,
          
          -- صافي الربح
          IFNULL(SUM(CASE WHEN s.type_sales = 2 THEN (s.unit_price - p.product_price_purchase) * s.quantity ELSE 0 END), 0) AS net_profit,
          
          -- التكلفة الإجمالية
          IFNULL(SUM(p.product_price_purchase * s.quantity), 0) AS total_cost,
          
          -- الخصومات
          IFNULL(SUM(CASE WHEN t.transactions = 2 THEN i.discount ELSE 0 END), 0) AS total_discount,
          
          -- المصروفات
          IFNULL(SUM(CASE WHEN t.transactions = 1 THEN i.Payment_price ELSE 0 END), 0) AS expenses,
          
          -- عدد الفواتير
          COUNT(DISTINCT CASE WHEN t.transactions = 2 THEN i.uuid END) AS total_invoices,
          
          -- عدد العناصر المباعة
          IFNULL(SUM(CASE WHEN s.type_sales = 2 THEN s.quantity ELSE 0 END), 0) AS items_sold,
          
          -- الإيرادات
          IFNULL(SUM(CASE WHEN s.type_sales = 3 THEN s.unit_price * s.quantity ELSE 0 END), 0) AS revenue,

          -- نسبة الربح
          CASE 
            WHEN SUM(CASE WHEN s.type_sales = 2 THEN s.unit_price * s.quantity ELSE 0 END) > 0 THEN 
              ROUND(
                (
                  SUM(CASE WHEN s.type_sales = 2 THEN (s.unit_price - p.product_price_purchase) * s.quantity ELSE 0 END) 
                  * 100.0
                ) / 
                SUM(CASE WHEN s.type_sales = 2 THEN s.unit_price * s.quantity ELSE 0 END),
                2
              )
            ELSE 0 
          END AS profit_rate

        FROM sales s
        JOIN products p ON s.product_uuid = p.uuid
        JOIN invoies i ON s.invoie_uuid = i.uuid
        JOIN transactions t ON t.uuid = i.Transaction_uuid
        WHERE s.user_id = ?
        $whereClause
        AND s.is_delete = 0
        GROUP BY strftime('$groupByFormat', i.created_at)
        ORDER BY period DESC;
  ''', args);

    // 🔹 إرجاع النتيجة كـ JSON منظم
    return {
      "status": 1,
      "summary": {
        "total_revenue":
            totalRevenue.isNotEmpty ? totalRevenue[0]['total_revenue'] : 0,
        "net_profit": netProfit.isNotEmpty ? netProfit[0]['net_profit'] : 0,
        "total_expenses":
            expenses.isNotEmpty ? expenses[0]['total_expenses'] : 0,
        "total_invoices":
            invoices.isNotEmpty ? invoices[0]['total_invoices'] : 0,
        "profit_rate":
            totalRevenue.isNotEmpty ? totalRevenue[0]['total_revenue'] : 0,
        'date_start': start,
        'date_end': end
      },
      "details": publicfinance
    };
  }

  Future<Map<String, dynamic>> lowStock() async {
    final sql = '''
    SELECT 
      p.uuid,
      p.product_name,
      p.product_quantity,
      p.created_at
    FROM products p
    WHERE user_id = ?
    AND CAST(p.product_quantity AS INTEGER) < 10 AND p.categorie_id = 1 AND p.is_delete = 0  
    ORDER BY p.product_quantity ASC
  ''';

    final data = await db.readData(sql, [id]);

    return {
      "status": 1,
      "count": data.length,
      "products": data,
    };
  }

  Future<Map<String, dynamic>> StockBalance({
    DateTime? from,
    DateTime? to,
    String? filter,
  }) async {
    final result = getDateRangeClause(
      id,
      filter: filter,
      t: "s",
      from: from,
      to: to,
    );

    final whereClause = result['where'];
    final args = result['args'];

    final DateTime start = from ?? DateTime.parse(args[1]);
    final DateTime end = to ?? DateTime.parse(args[2]);

    final sqlTotalInBefore = '''
    SELECT IFNULL(SUM(s.quantity), 0) AS total_in_before
    FROM sales s
    WHERE s.user_id = ? AND s.type_sales = 3 AND s.created_at < ? 
    AND s.is_delete = 0
  ''';

    // الكمية المباعة قبل الفترة
    final sqlTotalOutBefore = '''
    SELECT IFNULL(SUM(s.quantity), 0) AS total_out_before
    FROM sales s
    WHERE s.user_id = ? AND s.created_at < ? AND s.type_sales = 2
    AND s.is_delete = 0
  ''';

    // الكمية المباعة في الفترة
    final sqlTotalSold = '''
    SELECT IFNULL(SUM(s.quantity), 0) AS total_sold
    FROM sales s
    WHERE s.user_id = ? $whereClause AND s.type_sales = 2
    AND s.is_delete = 0
  ''';

    // الكمية الواردة في الفترة
    final sqlTotalIn = '''
    SELECT IFNULL(SUM(s.quantity), 0) AS total_in
    FROM sales s
    WHERE s.user_id = ? $whereClause AND s.type_sales = 3 
    AND s.is_delete = 0
  ''';

    // استعلام القيم
    final inBefore =
        await db.readData(sqlTotalInBefore, [id, start.toIso8601String()]);
    final outBefore =
        await db.readData(sqlTotalOutBefore, [id, start.toIso8601String()]);
    final inPeriod = await db.readData(sqlTotalIn, args);
    final soldPeriod = await db.readData(sqlTotalSold, args);

    // استخراج القيم الرقمية
    final totalInBefore = (inBefore.first['total_in_before'] ?? 0) as num;
    final totalOutBefore = (outBefore.first['total_out_before'] ?? 0) as num;
    final totalIn = (inPeriod.first['total_in'] ?? 0) as num;
    final totalSold = (soldPeriod.first['total_sold'] ?? 0) as num;

    // حساب النتائج
    final totalStart = totalInBefore - totalOutBefore;
    final totalEnd = totalStart + totalIn - totalSold;

    final sql = '''
      SELECT 
        p.product_name,

        -- كمية أول الفترة
        (
          IFNULL((
            SELECT SUM(s1.quantity)
            FROM sales s1
            WHERE s1.product_uuid = p.uuid
              AND s1.user_id = ?
              AND s1.created_at < ?
              AND s1.type_sales = 3
          ), 0)
          -
          IFNULL((
            SELECT SUM(s2.quantity)
            FROM sales s2
            WHERE s2.product_uuid = p.uuid
              AND s2.user_id = ?
              AND s2.created_at < ?
              AND s2.type_sales = 2
          ), 0)
        ) AS start_quantity,

        -- الكمية الواردة في الفترة
        IFNULL((
          SELECT SUM(s3.quantity)
          FROM sales s3
          WHERE s3.product_uuid = p.uuid
            AND s3.user_id = ?
            AND s3.created_at BETWEEN ? AND ?
            AND s3.type_sales = 3
        ), 0) AS in_quantity,

        -- الكمية المباعة في الفترة
        IFNULL((
          SELECT SUM(s4.quantity)
          FROM sales s4
          WHERE s4.product_uuid = p.uuid
            AND s4.user_id = ?
            AND s4.created_at BETWEEN ? AND ?
            AND s4.type_sales = 2
        ), 0) AS sold_quantity,

        -- كمية آخر الفترة = أول + وارد - مبيع
        (
          (
            IFNULL((
              SELECT SUM(s1.quantity)
              FROM sales s1
              WHERE s1.product_uuid = p.uuid
                AND s1.user_id = ?
                AND s1.created_at < ?
                AND s1.type_sales = 3
            ), 0)
            -
            IFNULL((
              SELECT SUM(s2.quantity)
              FROM sales s2
              WHERE s2.product_uuid = p.uuid
                AND s2.user_id = ?
                AND s2.created_at < ?
                AND s2.type_sales = 2
            ), 0)
          ) 
          +
          IFNULL((
            SELECT SUM(s3.quantity)
            FROM sales s3
            WHERE s3.product_uuid = p.uuid
              AND s3.user_id = ?
              AND s3.created_at BETWEEN ? AND ?
              AND s3.type_sales = 3
          ), 0)
          -
          IFNULL((
            SELECT SUM(s4.quantity)
            FROM sales s4
            WHERE s4.product_uuid = p.uuid
              AND s4.user_id = ?
              AND s4.created_at BETWEEN ? AND ?
              AND s4.type_sales = 2
          ), 0)
        ) AS end_quantity

      FROM products p
      WHERE p.user_id = ? AND p.categorie_id = 1 AND p.is_delete = 0
''';
    final data = await db.readData(sql, [
      id,
      start.toIso8601String(),
      id,
      start.toIso8601String(),
      id,
      start.toIso8601String(),
      end.toIso8601String(),
      id,
      start.toIso8601String(),
      end.toIso8601String(),
      id,
      start.toIso8601String(),
      id,
      start.toIso8601String(),
      id,
      start.toIso8601String(),
      end.toIso8601String(),
      id,
      start.toIso8601String(),
      end.toIso8601String(),
      id
    ]);
    return {
      "status": 1,
      'summary': {
        'total_start': totalStart,
        'total_in': totalIn,
        'total_sold': totalSold,
        'total_end': totalEnd,
        'date_start': start,
        'date_end': end
      },
      "pruducts_Balance": data
    };
  }

  Future<Map<String, dynamic>> StockValue({
    DateTime? from,
    DateTime? to,
    String? filter,
  }) async {
    final result = getDateRangeClause(
      id,
      filter: filter,
      t: "s",
      from: from,
      to: to,
    );

    final whereClause = result['where'];
    final args = result['args'];

    final DateTime start = from ?? DateTime.parse(args[1]);
    final DateTime end = to ?? DateTime.parse(args[2]);

    final sqlTotalInBefore = '''
    SELECT IFNULL(SUM(s.subtotal), 0) AS total_in_before
    FROM sales s
    WHERE s.user_id = ? AND s.type_sales = 3 AND s.created_at < ? 
    AND s.is_delete = 0
  ''';

    // الكمية المباعة قبل الفترة
    final sqlTotalOutBefore = '''
    SELECT IFNULL(SUM(s.subtotal), 0) AS total_out_before
    FROM sales s
    WHERE s.user_id = ? AND s.created_at < ? AND s.type_sales = 2
    AND s.is_delete = 0
  ''';

    // الكمية المباعة في الفترة
    final sqlTotalSold = '''
    SELECT IFNULL(SUM(s.subtotal), 0) AS total_sold
    FROM sales s
    WHERE s.user_id = ? $whereClause AND s.type_sales = 2
    AND s.is_delete = 0
  ''';

    // الكمية الواردة في الفترة
    final sqlTotalIn = '''
    SELECT IFNULL(SUM(s.subtotal), 0) AS total_in
    FROM sales s
    WHERE s.user_id = ? $whereClause AND s.type_sales = 3 
    AND s.is_delete = 0
  ''';

    // استعلام القيم
    final inBefore =
        await db.readData(sqlTotalInBefore, [id, start.toIso8601String()]);
    final outBefore =
        await db.readData(sqlTotalOutBefore, [id, start.toIso8601String()]);
    final inPeriod = await db.readData(sqlTotalIn, args);
    final soldPeriod = await db.readData(sqlTotalSold, args);

    // استخراج القيم الرقمية
    final totalInBefore = (inBefore.first['total_in_before'] ?? 0) as num;
    final totalOutBefore = (outBefore.first['total_out_before'] ?? 0) as num;
    final totalIn = (inPeriod.first['total_in'] ?? 0) as num;
    final totalSold = (soldPeriod.first['total_sold'] ?? 0) as num;

    // حساب النتائج
    final totalStart = totalInBefore - totalOutBefore;
    final totalEnd = totalStart + totalIn - totalSold;

    final sql = '''
      SELECT 
        p.product_name,

        -- كمية أول الفترة
        (
          IFNULL((
            SELECT SUM(s1.subtotal)
            FROM sales s1
            WHERE s1.product_uuid = p.uuid
              AND s1.user_id = ?
              AND s1.created_at < ?
              AND s1.type_sales = 3
          ), 0)
          -
          IFNULL((
            SELECT SUM(s2.subtotal)
            FROM sales s2
            WHERE s2.product_uuid = p.uuid
              AND s2.user_id = ?
              AND s2.created_at < ?
              AND s2.type_sales = 2
          ), 0)
        ) AS start_subtotal,

        -- الكمية الواردة في الفترة
        IFNULL((
          SELECT SUM(s3.subtotal)
          FROM sales s3
          WHERE s3.product_uuid = p.uuid
            AND s3.user_id = ?
            AND s3.created_at BETWEEN ? AND ?
            AND s3.type_sales = 3
        ), 0) AS in_subtotal,

        -- الكمية المباعة في الفترة
        IFNULL((
          SELECT SUM(s4.subtotal)
          FROM sales s4
          WHERE s4.product_uuid = p.uuid
            AND s4.user_id = ?
            AND s4.created_at BETWEEN ? AND ?
            AND s4.type_sales = 2
        ), 0) AS sold_subtotal,

        -- كمية آخر الفترة = أول + وارد - مبيع
        (
          (
            IFNULL((
              SELECT SUM(s1.subtotal)
              FROM sales s1
              WHERE s1.product_uuid = p.uuid
                AND s1.user_id = ?
                AND s1.created_at < ?
                AND s1.type_sales = 3
            ), 0)
            -
            IFNULL((
              SELECT SUM(s2.subtotal)
              FROM sales s2
              WHERE s2.product_uuid = p.uuid
                AND s2.user_id = ?
                AND s2.created_at < ?
                AND s2.type_sales = 2
            ), 0)
          ) 
          +
          IFNULL((
            SELECT SUM(s3.subtotal)
            FROM sales s3
            WHERE s3.product_uuid = p.uuid
              AND s3.user_id = ?
              AND s3.created_at BETWEEN ? AND ?
              AND s3.type_sales = 3
          ), 0)
          -
          IFNULL((
            SELECT SUM(s4.subtotal)
            FROM sales s4
            WHERE s4.product_uuid = p.uuid
              AND s4.user_id = ?
              AND s4.created_at BETWEEN ? AND ?
              AND s4.type_sales = 2
          ), 0)
        ) AS end_subtotal

      FROM products p
      WHERE p.user_id = ? AND p.categorie_id = 1
      AND p.is_delete = 0
''';
    final data = await db.readData(sql, [
      id,
      start.toIso8601String(),
      id,
      start.toIso8601String(),
      id,
      start.toIso8601String(),
      end.toIso8601String(),
      id,
      start.toIso8601String(),
      end.toIso8601String(),
      id,
      start.toIso8601String(),
      id,
      start.toIso8601String(),
      id,
      start.toIso8601String(),
      end.toIso8601String(),
      id,
      start.toIso8601String(),
      end.toIso8601String(),
      id
    ]);
    return {
      "status": 1,
      'summary': {
        'total_start': totalStart,
        'total_in': totalIn,
        'total_sold': totalSold,
        'total_end': totalEnd,
        'date_start': start,
        'date_end': end
      },
      "pruducts_Balance": data
    };
  }

  Future<Map<String, dynamic>> transactionsSales({
    DateTime? from,
    DateTime? to,
    String? filter,
    int? type,
  }) async {
    final result = getDateRangeClause(
      id,
      filter: filter,
      t: "s",
      from: from,
      to: to,
    );

    final whereClause = result['where'];

    final args = result['args'];

    final DateTime start = from ?? DateTime.parse(args[1]);
    final DateTime end = to ?? DateTime.parse(args[2]);

    final TotalInsold = '''
      SELECT 
        IFNULL(SUM(s.subtotal), 0) AS total_sales
      FROM sales s
      WHERE s.user_id = ? 
        AND s.type_sales = $type $whereClause
        AND s.is_delete = 0
  ''';

    final SqlTotalDebts = '''
        SELECT 
            IFNULL(SUM(
                IFNULL(s.subtotal, 0) 
                - IFNULL(i.Payment_price, 0)
                - IFNULL(i.discount, 0)
            ), 0) AS total_debts
        FROM invoies i
        LEFT JOIN sales s ON s.invoie_uuid = i.uuid
        WHERE i.user_id = ?
          AND s.type_sales = $type
          $whereClause;
  ''';

    final CustomerDitails = '''
      SELECT 
        t.family_name,
        t.name,
        IFNULL(SUM(s.subtotal - i.discount - i.Payment_price), 0) AS debts,
        IFNULL(SUM(s.subtotal), 0) AS total_Sold,
        IFNULL(SUM(i.discount), 0) AS total_discount,
        COUNT(DISTINCT i.uuid) AS total_invoices,
        IFNULL(SUM(s.subtotal) / COUNT(DISTINCT i.uuid), 0) AS average_order_value
      FROM sales s
      JOIN invoies i ON s.invoie_uuid = i.uuid
      JOIN transactions t ON i.Transaction_uuid = t.uuid
      WHERE s.user_id = ? 
        AND s.type_sales = $type
        AND s.is_delete = 0
        $whereClause
      GROUP BY t.family_name, t.name;
  ''';

    final inSold = await db.readData(TotalInsold, args);
    final totalSales = result.isNotEmpty ? inSold.first['total_sales'] ?? 0 : 0;
    final TotalDeb = await db.readData(SqlTotalDebts, args);
    final TotalDebts =
        result.isNotEmpty ? TotalDeb.first['total_debts'] ?? 0 : 0;
    final data = await db.readData(CustomerDitails, args);

    return {
      "status": 1,
      'summary': {
        'total_sold': totalSales,
        'total_Debts': TotalDebts,
        'date_start': start,
        'date_end': end
      },
      "transactionsDitails": data
    };
  }

  Map<String, dynamic> getDateRangeClause(
    int? id, {
    String? filter,
    String? t,
    DateTime? from,
    DateTime? to,
  }) {
    String whereClause = "";
    List args = [];

    if (from != null && to != null) {
      whereClause = "AND $t.created_at BETWEEN ? AND ?";
      args = [id, from.toIso8601String(), to.toIso8601String()];
      return {'where': whereClause, 'args': args};
    }

    if (filter == null) {
      return {
        'where': whereClause,
        'args': [id]
      };
    }

    DateTime now = DateTime.now();
    DateTime start;
    DateTime end;

    switch (filter) {
      case "today":
        start = DateTime(now.year, now.month, now.day);
        end = now;
        break;

      case "yesterday":
        start = DateTime(now.year, now.month, now.day - 1);
        end = DateTime(now.year, now.month, now.day);
        break;

      case "last_7_days":
        start = now.subtract(const Duration(days: 7));
        end = now;
        break;

      case "last_30_days":
        start = now.subtract(const Duration(days: 30));
        end = now;
        break;

      case "this_month":
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 0);
        break;

      case "last_month":
        final prevMonth = now.month == 1 ? 12 : now.month - 1;
        final prevYear = now.month == 1 ? now.year - 1 : now.year;
        start = DateTime(prevYear, prevMonth, 1);
        end = DateTime(prevYear, prevMonth + 1, 0);
        break;

      case "this_year":
        start = DateTime(now.year, 1, 1);
        end = DateTime(now.year, 12, 31);
        break;

      case "last_year":
        start = DateTime(now.year - 1, 1, 1);
        end = DateTime(now.year - 1, 12, 31);
        break;

      default:
        start = DateTime(now.year, 1, 1);
        end = now;
        break;
    }

    whereClause = "AND ${t}.created_at BETWEEN ? AND ?";
    args = [id, start.toIso8601String(), end.toIso8601String()];

    return {'where': whereClause, 'args': args};
  }
}
