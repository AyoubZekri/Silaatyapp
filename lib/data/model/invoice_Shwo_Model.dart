class invoice_Shwo_Model {
  int? status;
  String? message;
  Data? data;

  invoice_Shwo_Model({this.status, this.message, this.data});

  invoice_Shwo_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Invoice? invoice;
  Transaction? transaction;
  List<Product>? product;
  var sumPrice;

  Data({this.invoice, this.transaction, this.product, this.sumPrice});

  Data.fromJson(Map<String, dynamic> json) {
    invoice =
        json['invoice'] != null ? new Invoice.fromJson(json['invoice']) : null;
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
    if (json['Product'] != null) {
      product = <Product>[];
      json['Product'].forEach((v) {
        product!.add(new Product.fromJson(v));
      });
    }
    sumPrice = json['sum_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.invoice != null) {
      data['invoice'] = this.invoice!.toJson();
    }
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
    }
    if (this.product != null) {
      data['Product'] = this.product!.map((v) => v.toJson()).toList();
    }
    data['sum_price'] = this.sumPrice;
    return data;
  }
}

class Invoice {
  int? id;
  int? transactionId;
  int? userId;
  String? invoiesNumper;
  String? invoiesDate;
  String? invoiesPaymentDate;
  int? paymentPrice;
  String? createdAt;
  String? updatedAt;

  Invoice(
      {this.id,
      this.transactionId,
      this.userId,
      this.invoiesNumper,
      this.invoiesDate,
      this.invoiesPaymentDate,
      this.paymentPrice,
      this.createdAt,
      this.updatedAt});

  Invoice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['Transaction_id'];
    userId = json['user_id'];
    invoiesNumper = json['invoies_numper'];
    invoiesDate = json['invoies_date'];
    invoiesPaymentDate = json['invoies_payment_date'];
    paymentPrice = json['Payment_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Transaction_id'] = this.transactionId;
    data['user_id'] = this.userId;
    data['invoies_numper'] = this.invoiesNumper;
    data['invoies_date'] = this.invoiesDate;
    data['invoies_payment_date'] = this.invoiesPaymentDate;
    data['Payment_price'] = this.paymentPrice;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Transaction {
  int? id;
  int? userId;
  String? name;
  String? familyName;
  String? phoneNumber;
  int? transactions;
  String? createdAt;
  String? updatedAt;

  Transaction(
      {this.id,
      this.userId,
      this.name,
      this.familyName,
      this.phoneNumber,
      this.transactions,
      this.createdAt,
      this.updatedAt});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    familyName = json['family_name'];
    phoneNumber = json['phone_number'];
    transactions = json['transactions'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['family_name'] = this.familyName;
    data['phone_number'] = this.phoneNumber;
    data['transactions'] = this.transactions;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Product {
  int? id;
  int? categorieId;
  int? userId;
  int? invoiesId;
  int? categorisId;
  String? productName;
  String? productImage;
  String? productDescription;
  String? productQuantity;
  String? productPrice;
  String? productPricePurchase;
  String? productPriceTotalPurchase;
  String? productPriceTotal;
  int? codepar;
  String? createdAt;
  String? updatedAt;

  Product(
      {this.id,
      this.categorieId,
      this.userId,
      this.invoiesId,
      this.categorisId,
      this.productName,
      this.productImage,
      this.productDescription,
      this.productQuantity,
      this.productPrice,
      this.productPricePurchase,
      this.productPriceTotalPurchase,
      this.productPriceTotal,
      this.codepar,
      this.createdAt,
      this.updatedAt});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categorieId = json['categorie_id'];
    userId = json['user_id'];
    invoiesId = json['invoies_id'];
    categorisId = json['categoris_id'];
    productName = json['product_name'];
    productImage = json['Product_image'];
    productDescription = json['product_description'];
    productQuantity = json['product_quantity'];
    productPrice = json['product_price'];
    productPricePurchase = json['product_price_purchase'];
    productPriceTotalPurchase = json['product_price_total_purchase'];
    productPriceTotal = json['product_price_total'];
    codepar = json['codepar'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categorie_id'] = this.categorieId;
    data['user_id'] = this.userId;
    data['invoies_id'] = this.invoiesId;
    data['categoris_id'] = this.categorisId;
    data['product_name'] = this.productName;
    data['Product_image'] = this.productImage;
    data['product_description'] = this.productDescription;
    data['product_quantity'] = this.productQuantity;
    data['product_price'] = this.productPrice;
    data['product_price_purchase'] = this.productPricePurchase;
    data['product_price_total_purchase'] = this.productPriceTotalPurchase;
    data['product_price_total'] = this.productPriceTotal;
    data['codepar'] = this.codepar;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
