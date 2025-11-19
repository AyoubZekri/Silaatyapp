class StatisticsHomeModel {
  final int todayInvoices;
  final double todayIncome;
  final double todayNetProfit;
  final int lowStockCount;

  StatisticsHomeModel({
    required this.todayInvoices,
    required this.todayIncome,
    required this.todayNetProfit,
    required this.lowStockCount,
  });

  factory StatisticsHomeModel.fromJson(Map<String, dynamic> json) {
    return StatisticsHomeModel(
      todayInvoices: json['todayInvoices'] ?? 0,
      todayIncome: (json['todayIncome'] ?? 0).toDouble(),
      todayNetProfit: (json['todayNetProfit'] ?? 0).toDouble(),
      lowStockCount: json['lowStockCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "todayInvoices": todayInvoices,
        "todayIncome": todayIncome,
        "todayNetProfit": todayNetProfit,
        "lowStockCount": lowStockCount,
      };
}
