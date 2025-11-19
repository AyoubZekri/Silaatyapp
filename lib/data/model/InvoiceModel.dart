// class InvoiceModel {
//   int? status;
//   Data? data;

//   InvoiceModel({this.status, this.data});

//   InvoiceModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     data = json['data'] != null ? Data.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> result = {};
//     result['status'] = status;
//     if (data != null) result['data'] = data!.toJson();
//     return result;
//   }
// }

// class Data {
//   List<Invoice>? invoice;

//   Data({this.invoice});

//   Data.fromJson(Map<String, dynamic> json) {
//     if (json['invoice'] != null) {
//       invoice = [];
//       json['invoice'].forEach((v) {
//         invoice!.add(Invoice.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> result = {};
//     if (invoice != null) {
//       result['invoice'] = invoice!.map((v) => v.toJson()).toList();
//     }
//     return result;
//   }
// }

// class Invoice {
//   String? invoiceUuid;
//   String? transactionUuid;
//   String? invoiesNumper;
//   String? invoiesDate;
//   String? paymentPrice;
//   double? discount;
//   int? userId;
//   int? Status;
//   String? transactionName;
//   String? transactionFamily;
//   String? transactionPhone;
//   double? totalSales;
//   double? debt;

//   Invoice({
//     this.invoiceUuid,
//     this.transactionUuid,
//     this.invoiesNumper,
//     this.invoiesDate,
//     this.paymentPrice,
//     this.discount,
//     this.userId,
//     this.Status,
//     this.transactionName,
//     this.transactionFamily,
//     this.transactionPhone,
//     this.totalSales,
//     this.debt,
//   });

//   Invoice.fromJson(Map<String, dynamic> json) {
//     invoiceUuid = json['invoice_uuid'];
//     transactionUuid = json['Transaction_uuid'];
//     invoiesNumper = json['invoies_numper'];
//     invoiesDate = json['invoies_date'];
//     paymentPrice = json['Payment_price']?.toString();
//     discount = double.tryParse(json['discount']?.toString() ?? "0") ?? 0.0;
//     userId = json['user_id'] is String
//         ? int.tryParse(json['user_id'])
//         : json['user_id'];
//     Status = json['Status'] is String
//         ? int.tryParse(json['Status'])
//         : json['Status'];
//     transactionName = json['transaction_name'];
//     transactionFamily = json['transaction_family'];
//     transactionPhone = json['transaction_phone'];
//     totalSales = double.tryParse(json['total_sales']?.toString() ?? "0") ?? 0.0;
//     debt = double.tryParse(json['debt']?.toString() ?? "0") ?? 0.0;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> result = {};
//     result['invoice_uuid'] = invoiceUuid;
//     result['Transaction_uuid'] = transactionUuid;
//     result['invoies_numper'] = invoiesNumper;
//     result['invoies_date'] = invoiesDate;
//     result['Payment_price'] = paymentPrice;
//     result['discount'] = discount;
//     result['user_id'] = userId;
//     result['Status'] = Status;
//     result['transaction_name'] = transactionName;
//     result['transaction_family'] = transactionFamily;
//     result['transaction_phone'] = transactionPhone;
//     result['total_sales'] = totalSales;
//     result['debt'] = debt;
//     return result;
//   }

// }

class Invoicemodel {
  int? status;
  String? message;
  InvoiceData? data;

  Invoicemodel({this.status, this.message, this.data});

  factory Invoicemodel.fromJson(Map<String, dynamic> json) {
    return Invoicemodel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? InvoiceData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        if (data != null) 'data': data!.toJson(),
      };
}

class InvoiceData {
  List<InvoiceItem>? invoices;
  Transaction? transaction;
  double? sumPrice;
  double? sumPaymentPrice;

  InvoiceData({
    this.invoices,
    this.transaction,
    this.sumPrice,
    this.sumPaymentPrice,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) {
    return InvoiceData(
      invoices: json['invoices'] != null
          ? (json['invoices'] is List
              ? List<InvoiceItem>.from(
                  json['invoices'].map((v) => InvoiceItem.fromJson(v)))
              : [InvoiceItem.fromJson(json['invoices'])])
          : [],
      transaction: json['transaction'] != null
          ? Transaction.fromJson(json['transaction'])
          : null,
      sumPrice: double.tryParse(json['sum_price']?.toString() ?? '0'),
      sumPaymentPrice:
          double.tryParse(json['sum_payment_Price']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() => {
        if (invoices != null)
          'invoices': invoices!.map((v) => v.toJson()).toList(),
        if (transaction != null) 'transaction': transaction!.toJson(),
        'sum_price': sumPrice,
        'sum_payment_Price': sumPaymentPrice,
      };
}

class InvoiceItem {
  int? id;
  String? uuid;
  String? transactionuuId;
  int? userId;
  String? number;
  String? date;
  String? paymentDate;
  double? paymentPrice;
  double? discount;
  double? totalSales;
  double? debt;
  double? invoiceSum;
  String? name;
  int? transactions;
  String? familyName;
  String? phoneNumber;

  InvoiceItem({
    this.id,
    this.uuid,
    this.transactionuuId,
    this.userId,
    this.number,
    this.date,
    this.paymentDate,
    this.paymentPrice,
    this.discount,
    this.totalSales,
    this.debt,
    this.invoiceSum,
    this.name,
    this.transactions,
    this.familyName,
    this.phoneNumber,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      id: json['id'],
      uuid: json['uuid'] ?? json['invoice_uuid'],
      transactionuuId: json['Transaction_uuid'],
      userId: json['user_id'],
      number: json['invoies_numper'],
      date: json['invoies_date'],
      paymentDate: json['invoies_payment_date'],
      paymentPrice: double.tryParse(json['Payment_price']?.toString() ?? '0'),
      discount: double.tryParse(json['discount']?.toString() ?? '0'),
      totalSales: double.tryParse(json['total_sales']?.toString() ?? '0'),
      debt: double.tryParse(json['debt']?.toString() ?? '0'),
      invoiceSum: double.tryParse(json['invoice_sum']?.toString() ?? '0'),
      name: json['name'],
      transactions: json['transactions'],
      familyName: json['family_name'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'Transaction_id': transactionuuId,
        'user_id': userId,
        'invoies_numper': number,
        'invoies_date': date,
        'invoies_payment_date': paymentDate,
        'Payment_price': paymentPrice,
        'discount': discount,
        'total_sales': totalSales,
        'debt': debt,
        'invoice_sum': invoiceSum,
        'name': name,
        'transactions': transactions,
        'family_name': familyName,
        'phone_number': phoneNumber,
      };
}

class Transaction {
  int? id;
  String? uuid;
  int? userId;
  String? name;
  String? familyName;
  String? phoneNumber;
  int? transactions;
  String? createdAt;
  String? updatedAt;
  int? status;

  Transaction({
    this.id,
    this.uuid,
    this.userId,
    this.name,
    this.familyName,
    this.phoneNumber,
    this.transactions,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      uuid: json['uuid'],
      userId: json['user_id'],
      name: json['name'],
      familyName: json['family_name'],
      phoneNumber: json['phone_number'],
      transactions: json['transactions'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['Status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'user_id': userId,
        'name': name,
        'family_name': familyName,
        'phone_number': phoneNumber,
        'transactions': transactions,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'Status': status,
      };
}
