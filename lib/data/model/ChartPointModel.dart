import 'package:fl_chart/fl_chart.dart';

class ChartPoint {
  final double x;
  final double y;

  ChartPoint({required this.x, required this.y});

  factory ChartPoint.fromJson(Map<String, dynamic> json) {
    return ChartPoint(
      x: double.parse(json['x'].toString()),
      y: double.parse(json['y'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "x": x,
      "y": y,
    };
  }
}

extension ChartPointToFlSpot on ChartPoint {
  FlSpot toFlSpot() => FlSpot(x, y);
}

// ==========================
// الموديل المركب للإحصائيات + الرسم البياني
// ==========================

class ChartStats {
  final List<ChartPoint> chart;
  final Stats stats;

  ChartStats({required this.chart, required this.stats});

  factory ChartStats.fromJson(Map<String, dynamic> json) {
    var chartList = <ChartPoint>[];
    if (json['chart'] != null) {
      chartList = List<Map<String, dynamic>>.from(json['chart'])
          .map((e) => ChartPoint.fromJson(e))
          .toList();
    }

    return ChartStats(
      chart: chartList,
      stats: Stats.fromJson(json['stats'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "chart": chart.map((e) => e.toJson()).toList(),
      "stats": stats.toJson(),
    };
  }
}

// ==========================
// موديل الإحصائيات
// ==========================

class Stats {
  final double totalSales;
  final double totalProfit;
  final double totalExpenses;
  final int totalInvoices;

  Stats({
    required this.totalSales,
    required this.totalProfit,
    required this.totalExpenses,
    required this.totalInvoices,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      totalSales: double.parse((json['total_sales'] ?? 0).toString()),
      totalProfit: double.parse((json['total_profit'] ?? 0).toString()),
      totalExpenses: double.parse((json['total_expenses'] ?? 0).toString()),
      totalInvoices: int.parse((json['total_invoices'] ?? 0).toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "total_sales": totalSales,
      "total_profit": totalProfit,
      "total_expenses": totalExpenses,
      "total_invoices": totalInvoices,
    };
  }
}
