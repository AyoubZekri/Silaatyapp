class Expense_Model {
  int? status;
  String? message;
  Data? data;

  Expense_Model({this.status, this.message, this.data});

  Expense_Model.fromJson(Map<String, dynamic> json) {
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
  List<Expense>? expense;

  Data({this.expense});

  Data.fromJson(Map<String, dynamic> json) {
    final rawExpense = json['Expense'];

    if (rawExpense != null) {
      expense = <Expense>[];

      if (rawExpense is List) {
        for (var item in rawExpense) {
          expense!.add(Expense.fromJson(item));
        }
      } else if (rawExpense is Map<String, dynamic>) {
        expense!.add(Expense.fromJson(rawExpense));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.expense != null) {
      data['Expense'] = this.expense!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Expense {
  int? id;
  String? uuid;
  String? name;
  double? price;
  String? description;
  int? userId;
  int? isDelete;
  String? createdAt;
  String? updatedAt;

  Expense({
    this.id,
    this.uuid,
    this.name,
    this.price,
    this.description,
    this.userId,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
  });

  Expense.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    name = json['name'];
    price = json['price'] != null ? double.parse(json['price'].toString()) : null;
    description = json['description'];
    userId = json['user_id'];
    isDelete = json['is_delete'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['name'] = this.name;
    data['price'] = this.price;
    data['description'] = this.description;
    data['user_id'] = this.userId;
    data['is_delete'] = this.isDelete;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
