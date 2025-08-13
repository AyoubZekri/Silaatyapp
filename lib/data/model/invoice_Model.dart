class invoice_Model {
  int? status;
  String? message;
  Data? data;

  invoice_Model({this.status, this.message, this.data});

  invoice_Model.fromJson(Map<String, dynamic> json) {
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
  List<Invoices>? invoices;
  Transaction? transaction;
  var sumPrice;
  var sumpaymentPrice;

  Data({this.invoices, this.transaction, this.sumPrice, this.sumpaymentPrice});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['invoices'] != null) {
      invoices = <Invoices>[];
      json['invoices'].forEach((v) {
        invoices!.add(new Invoices.fromJson(v));
      });
    }
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
    sumPrice = json['sum_price'];
    sumpaymentPrice = json['sum_payment_Price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.invoices != null) {
      data['invoices'] = this.invoices!.map((v) => v.toJson()).toList();
    }
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
    }
    data['sum_price'] = this.sumPrice;
    data['sum_payment_Price'] = this.sumpaymentPrice;

    return data;
  }
}

class Invoices {
  int? id;
  int? transactionId;
  int? userId;
  String? invoiesNumper;
  String? invoiesDate;
  String? invoiesPaymentDate;
  int? paymentPrice;
  String? createdAt;
  String? updatedAt;
  var invoicesum;

  Invoices(
      {this.id,
      this.transactionId,
      this.userId,
      this.invoiesNumper,
      this.invoiesDate,
      this.invoiesPaymentDate,
      this.paymentPrice,
      this.invoicesum,
      this.createdAt,
      this.updatedAt});

  Invoices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['Transaction_id'];
    userId = json['user_id'];
    invoiesNumper = json['invoies_numper'];
    invoiesDate = json['invoies_date'];
    invoiesPaymentDate = json['invoies_payment_date'];
    paymentPrice = json['Payment_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    invoicesum = json['invoice_sum'];
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
    data['invoice_sum'] = this.invoicesum;
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
  int? Status;


  Transaction(
      {this.id,
      this.userId,
      this.name,
      this.familyName,
      this.phoneNumber,
      this.transactions,
      this.createdAt,
      this.updatedAt,
      this.Status,

      });

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    familyName = json['family_name'];
    phoneNumber = json['phone_number'];
    transactions = json['transactions'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    Status = json['Status'];
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
    data['Status'] = this.Status;

    return data;
  }
}
