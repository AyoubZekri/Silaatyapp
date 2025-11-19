class FinanceReport {
  final FinanceSummary? summary;
  final List<FinanceDetail>? details;
  final List<FinanceProduct>? products;
  final List<StockProduct>? productsBalance;
  final List<CustomerTransactionDetail>? transactionsDetails;

  FinanceReport({
    required this.summary,
    required this.details,
    required this.products,
    required this.productsBalance,
    required this.transactionsDetails,
  });

  factory FinanceReport.fromJson(Map<String, dynamic> json) {
    return FinanceReport(
      summary: json['summary'] != null
          ? FinanceSummary.fromJson(json['summary'])
          : null,
      details: (json['details'] as List?)
              ?.map((e) => FinanceDetail.fromJson(e))
              .toList() ??
          [],
      products: (json['products'] as List?)
              ?.map((e) => FinanceProduct.fromJson(e))
              .toList() ??
          [],
      productsBalance: (json['pruducts_Balance'] as List?)
              ?.map((e) => StockProduct.fromJson(e))
              .toList() ??
          [],
      transactionsDetails: (json['transactionsDitails'] as List?)
              ?.map((e) => CustomerTransactionDetail.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary?.toJson(),
      'details': details?.map((e) => e.toJson()).toList(),
      'products': products?.map((e) => e.toJson()).toList(),
      'pruducts_Balance':
          productsBalance?.map((e) => e.toJson()).toList() ?? [],
      'transactionsDitails':
          transactionsDetails?.map((e) => e.toJson()).toList() ?? [],
    };
  }
}

class FinanceSummary {
  final double totalRevenue;
  final double netProfit;
  final double totalExpenses;
  final int totalInvoices;
  final double profitRate;
  final double totalStart;
  final double totalIn;
  final double totalSold;
  final double totalEnd;
  final double totalDebts;
  final String datestart;
  final String dateend;

  FinanceSummary({
    required this.totalRevenue,
    required this.netProfit,
    required this.totalExpenses,
    required this.totalInvoices,
    required this.profitRate,
    required this.totalStart,
    required this.totalIn,
    required this.totalSold,
    required this.totalDebts,
    required this.totalEnd,
    required this.datestart,
    required this.dateend,
  });

  factory FinanceSummary.fromJson(Map<String, dynamic> json) {
    return FinanceSummary(
      totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
      netProfit: (json['net_profit'] ?? 0).toDouble(),
      totalExpenses: (json['total_expenses'] ?? 0).toDouble(),
      totalInvoices: (json['total_invoices'] ?? 0).toInt(),
      profitRate: double.tryParse(json['profit_rate'].toString()) ?? 0.0,
      totalStart: (json['total_start'] ?? 0).toDouble(),
      totalIn: (json['total_in'] ?? 0).toDouble(),
      totalSold: (json['total_sold'] ?? 0).toDouble(),
      totalDebts: (json['total_Debts'] ?? 0).toDouble(),
      totalEnd: (json['total_end'] ?? 0).toDouble(),
      datestart: (json['date_start'] ?? 0).toString(),
      dateend: (json['date_end'] ?? 0).toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_revenue': totalRevenue,
      'net_profit': netProfit,
      'total_expenses': totalExpenses,
      'total_invoices': totalInvoices,
      'profit_rate': profitRate,
      'total_start': totalStart,
      'total_in': totalIn,
      'total_sold': totalSold,
      'total_end': totalEnd,
      'date_start': datestart,
      'date_end': dateend,
    };
  }
}

class FinanceDetail {
  final String period;
  final double totalSales;
  final double netProfit;
  final double totalCost;
  final double totalDiscount;
  final double expenses;
  final int totalInvoices;
  final int itemsSold;
  final double revenue;
  final double profitRate;

  FinanceDetail({
    required this.period,
    required this.totalSales,
    required this.netProfit,
    required this.totalCost,
    required this.totalDiscount,
    required this.expenses,
    required this.totalInvoices,
    required this.itemsSold,
    required this.revenue,
    required this.profitRate,
  });

  factory FinanceDetail.fromJson(Map<String, dynamic> json) {
    return FinanceDetail(
      period: json['period'] ?? '',
      totalSales: (json['total_sales'] ?? 0).toDouble(),
      netProfit: (json['net_profit'] ?? 0).toDouble(),
      totalCost: (json['total_cost'] ?? 0).toDouble(),
      totalDiscount: (json['total_discount'] ?? 0).toDouble(),
      expenses: (json['expenses'] ?? 0).toDouble(),
      totalInvoices: (json['total_invoices'] ?? 0).toInt(),
      itemsSold: (json['items_sold'] ?? 0).toInt(),
      revenue: (json['revenue'] ?? 0).toDouble(),
      profitRate: (json['profit_rate'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'period': period,
      'total_sales': totalSales,
      'net_profit': netProfit,
      'total_cost': totalCost,
      'total_discount': totalDiscount,
      'expenses': expenses,
      'total_invoices': totalInvoices,
      'items_sold': itemsSold,
      'revenue': revenue,
      'profit_rate': profitRate,
    };
  }
}

class FinanceProduct {
  final String uuid;
  final String name;
  final String quantity;

  FinanceProduct({
    required this.uuid,
    required this.name,
    required this.quantity,
  });

  factory FinanceProduct.fromJson(Map<String, dynamic> json) {
    return FinanceProduct(
      uuid: json['uuid'] ?? '',
      name: json['product_name'] ?? '',
      quantity: json['product_quantity'] ?? "0.0",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'product_name': name,
      'product_quantity': quantity,
    };
  }
}

class StockProduct {
  final String productName;
  final int startQuantity;
  final int inQuantity;
  final int soldQuantity;
  final int endQuantity;
  final double startsubtotal;
  final double insubtotal;
  final double soldsubtotal;
  final double endsubtotal;

  StockProduct({
    required this.productName,
    required this.startQuantity,
    required this.inQuantity,
    required this.soldQuantity,
    required this.endQuantity,
    required this.startsubtotal,
    required this.insubtotal,
    required this.soldsubtotal,
    required this.endsubtotal,
  });

  factory StockProduct.fromJson(Map<String, dynamic> json) {
    return StockProduct(
      productName: json['product_name'] ?? '',
      startQuantity: json['start_quantity'] ?? 0,
      inQuantity: json['in_quantity'] ?? 0,
      soldQuantity: json['sold_quantity'] ?? 0,
      endQuantity: json['end_quantity'] ?? 0,
      startsubtotal: (json['start_subtotal'] ?? 0.0).toDouble(),
      insubtotal: (json['in_subtotal'] ?? 0.0).toDouble(),
      soldsubtotal: (json['sold_subtotal'] ?? 0.0).toDouble(),
      endsubtotal: (json['end_subtotal'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'start_quantity': startQuantity,
      'in_quantity': inQuantity,
      'sold_quantity': soldQuantity,
      'end_quantity': endQuantity,
      'start_subtotal': startsubtotal,
      'in_subtotal': insubtotal,
      'sold_subtotal': soldsubtotal,
      'end_subtotal': endsubtotal,
    };
  }
}

class CustomerTransactionDetail {
  final String familyName;
  final String name;
  final double debts;
  final double totalSold;
  final double totalDiscount;
  final int totalInvoices;
  final double averageOrderValue;

  CustomerTransactionDetail({
    required this.familyName,
    required this.name,
    required this.debts,
    required this.totalSold,
    required this.totalDiscount,
    required this.totalInvoices,
    required this.averageOrderValue,
  });

  factory CustomerTransactionDetail.fromJson(Map<String, dynamic> json) {
    return CustomerTransactionDetail(
      familyName: json['family_name'] ?? '',
      name: json['name'] ?? '',
      debts: (json['debts'] ?? 0).toDouble(),
      totalSold: (json['total_Sold'] ?? 0).toDouble(),
      totalDiscount: (json['total_discount'] ?? 0).toDouble(),
      totalInvoices: (json['total_invoices'] ?? 0).toInt(),
      averageOrderValue: (json['average_order_value'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'family_name': familyName,
      'name': name,
      'debts': debts,
      'total_Sold': totalSold,
      'total_discount': totalDiscount,
      'total_invoices': totalInvoices,
      'average_order_value': averageOrderValue,
    };
  }
}
