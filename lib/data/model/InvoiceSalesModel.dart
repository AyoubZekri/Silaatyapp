class InvoiceSalesModel {
  final int status;
  final InvoiceSalesData? data;
  final String? error;
  final String? message;

  InvoiceSalesModel({
    required this.status,
    this.data,
    this.error,
    this.message,
  });

  factory InvoiceSalesModel.fromJson(Map<String, dynamic> json) {
    return InvoiceSalesModel(
      status: json['status'] ?? 0,
      error: json['error'],
      message: json['message'],
      data:
          json['data'] != null ? InvoiceSalesData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'error': error,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class InvoiceSalesData {
  final List<ProductSale> products;
  final double sumPrice;
  final double discount;
  final double paymentprice;
  final int? saleType;

  InvoiceSalesData({
    required this.products,
    required this.sumPrice,
    required this.discount,
    required this.paymentprice,
    this.saleType,
  });

  factory InvoiceSalesData.fromJson(Map<String, dynamic> json) {
    var list = json['Product'] as List? ?? [];
    List<ProductSale> products =
        list.map((i) => ProductSale.fromJson(i)).toList();

    return InvoiceSalesData(
      products: products,
      sumPrice: double.tryParse(json['sum_price'].toString()) ?? 0.0,
      discount: double.tryParse(json['discount'].toString()) ?? 0.0,
      paymentprice: double.tryParse(json['Payment_price'].toString()) ?? 0.0,
      saleType: json['sale_type'] != null ? int.tryParse(json['sale_type'].toString()) : 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Product': products.map((x) => x.toJson()).toList(),
      'sum_price': sumPrice,
      'discount': discount,
      'Payment_price': paymentprice,
      'sale_type': saleType,
    };
  }
}

class ProductSale {
  final String uuid;
  final double quantity;
  final double unitPrice;
  final double subtotal;
  final String productName;
  final double productPrice;
  final int? type;

  ProductSale({
    required this.uuid,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    required this.productName,
    required this.productPrice,
    this.type,
  });

  factory ProductSale.fromJson(Map<String, dynamic> json) {
    return ProductSale(
      uuid: json['uuid'],
      quantity: json['quantity'] is int
          ? json['quantity']
          : double.tryParse(json['quantity'].toString()) ?? 0,
      unitPrice: double.tryParse(json['unit_price'].toString()) ?? 0.0,
      subtotal: double.tryParse(json['subtotal'].toString()) ?? 0.0,
      productName: json['product_name'] ?? '',
      productPrice: double.tryParse(json['product_price'].toString()) ?? 0.0,
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'quantity': quantity,
      'unit_price': unitPrice,
      'subtotal': subtotal,
      'product_name': productName,
      'product_price': productPrice,
      'type': type,
    };
  }
}
