class transaction_Model {
  int? status;
  String? message;
  List<Data>? data;

  transaction_Model({this.status, this.message, this.data});

  transaction_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  Transaction? transaction;
  var sumPrice;

  Data({this.transaction, this.sumPrice});

  Data.fromJson(Map<String, dynamic> json) {
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
    sumPrice = json['sum_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
    }
    data['sum_price'] = this.sumPrice;
    return data;
  }
}

class Transaction {
  int? id;
  int? userId;
  String? name;
  String? uuid;
  String? familyName;
  String? phoneNumber;
  int? transactions;
  String? createdAt;
  String? updatedAt;
  int? Status;

  Transaction(
      {this.id,
      this.userId,
      this.name,
      this.uuid,
      this.familyName,
      this.phoneNumber,
      this.Status,
      this.transactions,
      this.createdAt,
      this.updatedAt});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    uuid = json['uuid'];
    name = json['name'];
    familyName = json['family_name'];
    phoneNumber = json['phone_number'];
    transactions = json['transactions'];
    Status = json['Status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['uuid'] = this.uuid;
    data['name'] = this.name;
    data['family_name'] = this.familyName;
    data['phone_number'] = this.phoneNumber;
    data['transactions'] = this.transactions;
    data['Status'] = this.Status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
