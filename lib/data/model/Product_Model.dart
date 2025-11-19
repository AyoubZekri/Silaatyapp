class Product_Model {
  List<Data>? data;

  Product_Model({this.data});

  Product_Model.fromJson(Map<String, dynamic> json) {
    final rawData = json['data']?['data'];

    if (rawData != null) {
      if (rawData is List) {
        data = rawData.map((v) => Data.fromJson(v)).toList();
      } else if (rawData is Map) {
        data = [Data.fromJson(rawData as Map<String, dynamic>)];
      }
    } else {
      data = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  factory Product_Model.fromLocalJson(Map<String, Object?> json) {
    return Product_Model(
      data: [Data.fromJson(Map<String, dynamic>.from(json))],
    );
  }
}

class Data {
  int? id;
  int? categorieId;
  int? userId;
  int? invoiesuuId;
  String? categorisuuId;
  String? uuid; // ✅ uuid هنا
  String? productName;
  String? productImage;
  String? productDescription;
  String? productQuantity;
  double? productPrice;
  double? productPricePurchase;
  double? productPriceTotalPurchase;
  double? productPriceTotal;
  int? codepar;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.categorieId,
    this.userId,
    this.invoiesuuId,
    this.categorisuuId,
    this.uuid, // ✅
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
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categorieId = json['categorie_id'];
    userId = json['user_id'];
    invoiesuuId = json['invoies_uuid'];
    categorisuuId = json['categoris_uuid'];
    uuid = json['uuid']; // ✅
    productName = json['product_name'];
    productImage = json['Product_image'];
    productDescription = json['product_description'];
    productQuantity = json['product_quantity'];
    productPrice = _toDouble(json['product_price']);
    productPricePurchase = _toDouble(json['product_price_purchase']);
    productPriceTotalPurchase = _toDouble(json['product_price_total_purchase']);
    productPriceTotal = _toDouble(json['product_price_total']);    codepar = json['codepar'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['categorie_id'] = this.categorieId;
    data['user_id'] = this.userId;
    data['invoies_uuid'] = this.invoiesuuId;
    data['categoris_uuid'] = this.categorisuuId;
    data['uuid'] = this.uuid; // ✅
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


    double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
