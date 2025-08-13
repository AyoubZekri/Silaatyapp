class Product_Model_Zakat {
  List<Data>? data;
  var sumTotalPrise;

  Product_Model_Zakat({this.data, this.sumTotalPrise});

  Product_Model_Zakat.fromJson(Map<String, dynamic> json) {
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
    sumTotalPrise = json["data"]['SumTotalPrise'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['SumTotalPrise'] = this.sumTotalPrise;
    return data;
  }
}

class Data {
  int? id;
  int? categorieId;
  int? userId;
  String? productName;
  String? productDescription;
  String? productQuantity;
  String? productPrice;
  String? productPriceTotal;
  String? productDebtorName;
  String? productPayment;
  String? productDebtorPhone;
  String? createdAt;
  String? updatedAt;
  String? productImage;

  Data(
      {this.id,
      this.categorieId,
      this.userId,
      this.productName,
      this.productDescription,
      this.productQuantity,
      this.productPrice,
      this.productPriceTotal,
      this.productDebtorName,
      this.productPayment,
      this.productDebtorPhone,
      this.createdAt,
      this.updatedAt,
      this.productImage});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categorieId = json['categorie_id'];
    userId = json['user_id'];
    productName = json['product_name'];
    productDescription = json['product_description'];
    productQuantity = json['product_quantity'];
    productPrice = json['product_price'];
    productPriceTotal = json['product_price_total'];
    productDebtorName = json['product_debtor_Name'];
    productPayment = json['product_payment'];
    productDebtorPhone = json['product_debtor_phone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productImage = json['Product_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categorie_id'] = this.categorieId;
    data['user_id'] = this.userId;
    data['product_name'] = this.productName;
    data['product_description'] = this.productDescription;
    data['product_quantity'] = this.productQuantity;
    data['product_price'] = this.productPrice;
    data['product_price_total'] = this.productPriceTotal;
    data['product_debtor_Name'] = this.productDebtorName;
    data['product_payment'] = this.productPayment;
    data['product_debtor_phone'] = this.productDebtorPhone;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['Product_image'] = this.productImage;
    return data;
  }
}
