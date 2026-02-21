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

    final invoicesCount = await db.readData('''
          SELECT COUNT(*) as count 
          FROM invoies i
          LEFT JOIN transactions t 
          ON t.uuid = i.Transaction_uuid 
          WHERE i.user_id = ?
            AND i.invoies_date LIKE ? AND  (t.transactions = 2 OR t.transactions IS NULL)
    ''', [id, '$today%']);

    final totalIncome = await db.readData('''
      SELECT IFNULL(SUM(i.Payment_price), 0) as totalIncome
      FROM invoies i
      LEFT JOIN transactions t ON t.uuid = i.Transaction_uuid 
      WHERE i.user_id = ?   
      AND i.invoies_date LIKE '$today%' AND  (t.transactions = 2 OR t.transactions IS NULL)
  ''', [id]);

    final netProfit = await db.readData('''
      SELECT IFNULL(SUM((s.unit_price - s.product_price_purchase) * s.quantity) - i.discount, 0) as netProfit
      FROM sales s
      JOIN invoies i ON s.invoie_uuid = i.uuid
      LEFT JOIN transactions t ON t.uuid = i.Transaction_uuid
      WHERE s.user_id = ?
        AND s.type_sales = 2
        AND i.invoies_date LIKE '$today%'
        AND (t.transactions = 2 OR t.transactions IS NULL)
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
    LEFT JOIN transactions t ON t.uuid = i.Transaction_uuid 
    JOIN sales s ON s.invoie_uuid = i.uuid
    WHERE i.user_id = ? 
    AND $dateCondition AND (t.transactions IS NULL OR t.transactions = 2)
    GROUP BY x ORDER BY x
  """;

    // الإحصائيات العامة
    String queryStats = """
    SELECT
      SUM(CASE WHEN i.type_sales = 2 THEN i.subtotal ELSE 0 END) AS total_sales,
      SUM(CASE WHEN i.type_sales = 2 
              THEN (i.unit_price - i.product_price_purchase) * i.quantity
              ELSE 0 
          END) - IFNULL(SUM(s.discount), 0) AS total_profit,
      SUM(CASE WHEN i.type_sales = 3 THEN i.subtotal ELSE 0 END) AS total_expenses
    FROM sales i
    LEFT JOIN invoies s ON s.uuid = i.invoie_uuid
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
    bool isSingleDay = filter == 'today' || filter == 'yesterday';
    final dateCondition = isSingleDay
        ? "DATE(COALESCE(i.created_at, s.created_at)) = DATE(?)"
        : "COALESCE(i.created_at, s.created_at) BETWEEN ? AND ?";

    // 🔹 صافي الربح
    final netProfit = await db.readData('''
    SELECT IFNULL(SUM((s.unit_price - s.product_price_purchase) * s.quantity)-i.discount, 0) as net_profit
    FROM sales s
    JOIN invoies i ON s.invoie_uuid = i.uuid
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
    LEFT JOIN transactions t ON i.Transaction_uuid = t.uuid 
    WHERE i.user_id = ?  $whereClause AND (t.transactions IS NULL OR t.transactions = 2)


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
    final publicfinance = await db.readData(
        '''
    SELECT 
        strftime('$groupByFormat', COALESCE(i.created_at, s.created_at)) AS period,
        
        -- المبيعات الإجمالية
        IFNULL(SUM(CASE WHEN s.type_sales = 2 THEN s.unit_price * s.quantity ELSE 0 END), 0) AS total_sales,
        
        -- صافي الربح مع خصم الفاتورة فقط        
        (
        IFNULL(SUM(
            CASE 
                WHEN s.type_sales = 2
                THEN (s.unit_price - s.product_price_purchase) * s.quantity
                ELSE 0
            END
        ), 0)
        - IFNULL(SUM(DISTINCT i.discount), 0)
        ) AS net_profit,
        -- الخصومات فقط للحساب المنفصل
        IFNULL(SUM(CASE WHEN (i.Transaction_uuid IS NULL OR t.transactions = 2) THEN i.discount ELSE 0 END), 0) AS total_discount,
        
        -- المصروفات
        IFNULL(SUM(CASE WHEN t.transactions = 1 THEN i.Payment_price ELSE 0 END), 0) AS expenses,

        -- عدد الفواتير
        COUNT(DISTINCT CASE WHEN (i.Transaction_uuid IS NULL OR t.transactions = 2) THEN i.uuid END) AS total_invoices,
        
        -- عدد العناصر المباعة
        IFNULL(SUM(CASE WHEN s.type_sales = 2 THEN s.quantity ELSE 0 END), 0) AS items_sold,
        
        -- الإيرادات
        IFNULL(SUM(CASE WHEN s.type_sales = 3 THEN s.unit_price * s.quantity ELSE 0 END), 0) AS revenue,

        CASE 
            WHEN SUM(CASE WHEN s.type_sales = 2 THEN s.unit_price * s.quantity ELSE 0 END) > 0 THEN
              ROUND(
                (
                  SUM(
                    CASE 
                      WHEN s.type_sales = 2 
                      THEN (s.unit_price - s.product_price_purchase) * s.quantity
                      ELSE 0 
                    END
                  )
                  - IFNULL(MAX(i.discount), 0)
                ) * 100.0
                /
                SUM(CASE WHEN s.type_sales = 2 THEN s.unit_price * s.quantity ELSE 0 END),
                2
              )
            ELSE 0
          END AS profit_rate


      FROM sales s
      LEFT JOIN invoies i ON s.invoie_uuid = i.uuid
      LEFT JOIN transactions t ON t.uuid = i.Transaction_uuid
      WHERE s.user_id = ?
        AND s.is_delete = 0
        AND $dateCondition
      GROUP BY strftime('$groupByFormat', COALESCE(i.created_at, s.created_at))
      ORDER BY period DESC;
      ''',
        isSingleDay
            ? [id, start.toIso8601String()]
            : [id, start.toIso8601String(), end.toIso8601String()]);

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
      WHERE s.user_id = ?
        AND s.type_sales = 3
        AND DATE(s.created_at) < DATE(?)
    ''';

    // الكمية المباعة قبل الفترة
    final sqlTotalOutBefore = '''
    SELECT IFNULL(SUM(s.quantity), 0) AS total_out_before
    FROM sales s
    WHERE s.user_id = ? AND s.created_at < DATE(?) AND s.type_sales = 2
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
    print("===================$totalInBefore");
    final totalOutBefore = (outBefore.first['total_out_before'] ?? 0) as num;
    print("===================$totalOutBefore");

    final totalIn = (inPeriod.first['total_in'] ?? 0) as num;
    print("===================$totalIn");

    final totalSold = (soldPeriod.first['total_sold'] ?? 0) as num;
    print("===================$totalSold");

    // حساب النتائج
    final totalStart = totalInBefore - totalOutBefore;
    final totalEnd = totalStart + totalIn - totalSold;
    final startStr = start.toIso8601String().split('T')[0];
    final endStr = end.toIso8601String().split('T')[0];

    final sql = '''
      WITH sales_summary AS (
        SELECT
          s.product_uuid,
          s.product_name,

          SUM(
            CASE 
              WHEN s.type_sales = 3 
              AND datetime(s.created_at) < datetime(?) 
              AND s.is_delete = 0
              THEN s.quantity ELSE 0 
            END
          ) AS total_in_before,

          SUM(
            CASE 
              WHEN s.type_sales = 2 
              AND datetime(s.created_at) < datetime(?) 
              AND s.is_delete = 0
              THEN s.quantity ELSE 0 
            END
          ) AS total_out_before,

          SUM(
            CASE 
              WHEN s.type_sales = 3 
              AND datetime(s.created_at) BETWEEN datetime(?) AND datetime(?) 
              AND s.is_delete = 0
              THEN s.quantity ELSE 0 
            END
          ) AS total_in_period,

          SUM(
            CASE 
              WHEN s.type_sales = 2 
              AND datetime(s.created_at) BETWEEN datetime(?) AND datetime(?) 
              AND s.is_delete = 0
              THEN s.quantity ELSE 0 
            END
          ) AS total_sold_period,

          MAX(datetime(s.created_at)) AS last_update

        FROM sales s
        WHERE s.user_id = ?
        GROUP BY s.product_uuid, s.product_name
      )

      SELECT
        product_uuid,
        product_name,
        total_in_before - total_out_before AS start_quantity,
        total_in_period AS in_quantity,
        total_sold_period AS sold_quantity,
        total_in_before - total_out_before
          + total_in_period
          - total_sold_period AS end_quantity,
        last_update
      FROM sales_summary
      ORDER BY product_uuid;
''';
    final data = await db.readData(sql, [
      startStr, // total_in_before
      startStr, // total_out_before
      startStr + " 00:00:00", // total_in_period start
      endStr + " 23:59:59", // total_in_period end
      startStr + " 00:00:00", // total_sold_period start
      endStr + " 23:59:59", // total_sold_period end
      id // user_id
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
    WHERE s.user_id = ? AND s.type_sales = 3 AND s.created_at < DATE(?) 
    AND s.is_delete = 0
  ''';

    // الكمية المباعة قبل الفترة
    final sqlTotalOutBefore = '''
    SELECT IFNULL(SUM(s.subtotal), 0) AS total_out_before
    FROM sales s
    WHERE s.user_id = ? AND s.created_at < DATE(?) AND s.type_sales = 2
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
    final startStr = start.toIso8601String().split('T')[0]; // "YYYY-MM-DD"
    final endStr = end.toIso8601String().split('T')[0];

    final sql = '''
      WITH sales_summary AS (
        SELECT
          s.product_uuid,
          s.product_name,

          SUM(
            CASE 
              WHEN s.type_sales = 3 
              AND datetime(s.created_at) < datetime(?) 
              AND s.is_delete = 0
              THEN s.subtotal ELSE 0 
            END
          ) AS total_in_before,

          SUM(
            CASE 
              WHEN s.type_sales = 2 
              AND datetime(s.created_at) < datetime(?) 
              AND s.is_delete = 0
              THEN s.subtotal ELSE 0 
            END
          ) AS total_out_before,

          SUM(
            CASE 
              WHEN s.type_sales = 3 
              AND datetime(s.created_at) BETWEEN datetime(?) AND datetime(?) 
              AND s.is_delete = 0
              THEN s.subtotal ELSE 0 
            END
          ) AS total_in_period,

          SUM(
            CASE 
              WHEN s.type_sales = 2 
              AND datetime(s.created_at) BETWEEN datetime(?) AND datetime(?) 
              AND s.is_delete = 0
              THEN s.subtotal ELSE 0 
            END
          ) AS total_sold_period

        FROM sales s
        WHERE s.user_id = ?
        GROUP BY s.product_uuid, s.product_name
      )

      SELECT
        product_uuid,
        product_name,
        total_in_before - total_out_before AS start_subtotal,
        total_in_period AS in_subtotal,
        total_sold_period AS sold_subtotal,
        total_in_before - total_out_before
          + total_in_period
          - total_sold_period AS end_subtotal
      FROM sales_summary
      ORDER BY product_uuid;
''';

    final data = await db.readData(sql, [
      startStr, // total_in_before
      startStr, // total_out_before
      startStr + " 00:00:00", // total_in_period start
      endStr + " 23:59:59", // total_in_period end
      startStr + " 00:00:00", // total_sold_period start
      endStr + " 23:59:59", // total_sold_period end
      id // user_id
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
    final result2 = getDateRangeClause(
      id,
      filter: filter,
      t: "i",
      from: from,
      to: to,
    );

    final whereClause = result['where'];
    final whereClause2 = result2['where'];

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
        invoice_total - invoice_paid
      ), 0) AS total_debts
    FROM (
      SELECT 
        i.uuid,
        -- مجموع subtotal للفاتورة
        IFNULL((
          SELECT SUM(s.subtotal)
          FROM sales s
          WHERE s.invoie_uuid = i.uuid
            AND s.type_sales = $type
        ), 0) AS invoice_total,

        -- مجموع المدفوع
        (IFNULL(i.Payment_price, 0) + IFNULL(i.discount, 0)) AS invoice_paid

      FROM invoies i
      JOIN transactions t ON i.Transaction_uuid = t.uuid
      WHERE i.user_id = ? AND t.transactions = $type
        $whereClause2
    );
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
    String formatDate(DateTime dt) {
      return "${dt.year.toString().padLeft(4, '0')}-"
          "${dt.month.toString().padLeft(2, '0')}-"
          "${dt.day.toString().padLeft(2, '0')}";
    }

    String whereClause = "";
    List args = [];

    if (from != null && to != null) {
      final start =
          "${from.year}-${from.month.toString().padLeft(2, '0')}-${from.day.toString().padLeft(2, '0')}";
      final end =
          "${to.year}-${to.month.toString().padLeft(2, '0')}-${to.day.toString().padLeft(2, '0')}";

      whereClause = "AND DATE($t.created_at) BETWEEN ? AND ?";
      args = [
        id,
        start, // اليوم الأول 00:00
        end, // اليوم الأخير 23:59:59
      ];
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
        end = start;
        whereClause = "AND DATE($t.created_at) = ? AND DATE($t.created_at) = ?";
        args = [id, formatDate(start), formatDate(start)];
        break;

      case "yesterday":
        final yesterday = now.subtract(const Duration(days: 1));
        start = DateTime(yesterday.year, yesterday.month, yesterday.day);
        end = start;
        whereClause = "AND DATE($t.created_at) = ? AND DATE($t.created_at) = ?";
        args = [id, formatDate(start), formatDate(start)];
        break;

      case "last_7_days":
        final today = DateTime(now.year, now.month, now.day);

        start =
            today.subtract(const Duration(days: 6)); // بداية اليوم الأول 00:00
        end = DateTime(today.year, today.month, today.day, 23, 59, 59);

        whereClause = "AND $t.created_at BETWEEN ? AND ?";
        args = [
          id,
          start.toIso8601String(),
          end.toIso8601String(),
        ];
        break;

      case "last_30_days":
        final today = DateTime(now.year, now.month, now.day);

        start = today.subtract(const Duration(days: 29)); // 30 يوم مع اليوم
        end = DateTime(today.year, today.month, today.day, 23, 59, 59);

        whereClause = "AND $t.created_at BETWEEN ? AND ?";
        args = [
          id,
          start.toIso8601String(),
          end.toIso8601String(),
        ];
        break;

      case "this_month":
        start = DateTime(now.year, now.month, 1); // 01 الشهر 00:00
        end = DateTime(now.year, now.month + 1, 0, 23, 59, 59); // آخر يوم 23:59

        whereClause = "AND $t.created_at BETWEEN ? AND ?";
        args = [
          id,
          start.toIso8601String(),
          end.toIso8601String(),
        ];
        break;

      case "last_month":
        final prevMonth = now.month == 1 ? 12 : now.month - 1;
        final prevYear = now.month == 1 ? now.year - 1 : now.year;
        start = DateTime(prevYear, prevMonth, 1);
        end = DateTime(prevYear, prevMonth + 1, 0, 23, 59, 59);
        whereClause = "AND $t.created_at BETWEEN ? AND ?";
        args = [id, start.toIso8601String(), end.toIso8601String()];
        break;

      case "this_year":
        start = DateTime(now.year, 1, 1);
        end = DateTime(now.year, 12, 31, 23, 59, 59);
        whereClause = "AND $t.created_at BETWEEN ? AND ?";
        args = [id, start.toIso8601String(), end.toIso8601String()];
        break;

      case "last_year":
        start = DateTime(now.year - 1, 1, 1);
        end = DateTime(now.year - 1, 12, 31, 23, 59, 59);
        whereClause = "AND $t.created_at BETWEEN ? AND ?";
        args = [id, start.toIso8601String(), end.toIso8601String()];
        break;

      default:
        start = DateTime(now.year, 1, 1);
        end = now;
        whereClause = "AND $t.created_at BETWEEN ? AND ?";
        args = [id, start.toIso8601String(), end.toIso8601String()];
        break;
    }

    return {'where': whereClause, 'args': args};
  }
}
