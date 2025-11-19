class Zakat_Model {
  List<Data_model>? data;

  Zakat_Model({this.data});

  Zakat_Model.fromJson(Map<String, dynamic> json) {
    final rawData = json['data']?['data'];

    if (rawData != null) {
      if (rawData is List) {
        data = rawData.map((v) => Data_model.fromJson(v)).toList();
      } else if (rawData is Map) {
        data = [Data_model.fromJson(rawData as Map<String, dynamic>)];
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
}

class Data_model {
  int? id;
  int? userId;
  String? uuid;
  double? zakatNisab;
  double? zakatTotalAssetValue;
  double? zakatTotalDebtsValue;
  double? zakatTotalDebortsValue;
  double? zakatDueAmount;
  double? zakatCashLiquidity;
  double? zakatDue;
  String? createdAt;
  String? updatedAt;

  Data_model({
    this.id,
    this.userId,
    this.uuid,
    this.zakatNisab,
    this.zakatTotalAssetValue,
    this.zakatTotalDebtsValue,
    this.zakatTotalDebortsValue,
    this.zakatDueAmount,
    this.zakatCashLiquidity,
    this.zakatDue,
    this.createdAt,
    this.updatedAt,
  });

  Data_model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    uuid = json['uuid'];

    zakatNisab = (json['zakat_nisab'] is String)
        ? double.tryParse(json['zakat_nisab'])
        : (json['zakat_nisab']?.toDouble());

    zakatTotalAssetValue = (json['zakat_total_asset_value'] is String)
        ? double.tryParse(json['zakat_total_asset_value'])
        : (json['zakat_total_asset_value']?.toDouble());

    zakatTotalDebtsValue = (json['zakat_total_debts_value'] is String)
        ? double.tryParse(json['zakat_total_debts_value'])
        : (json['zakat_total_debts_value']?.toDouble());

    zakatTotalDebortsValue = (json['zakat_total_deborts_value'] is String)
        ? double.tryParse(json['zakat_total_deborts_value'])
        : (json['zakat_total_deborts_value']?.toDouble());

    zakatDueAmount = (json['zakat_due_amount'] is String)
        ? double.tryParse(json['zakat_due_amount'])
        : (json['zakat_due_amount']?.toDouble());

    zakatCashLiquidity = (json['zakat_Cash_liquidity'] is String)
        ? double.tryParse(json['zakat_Cash_liquidity'])
        : (json['zakat_Cash_liquidity']?.toDouble());

    zakatDue = (json['zakat_due'] is String)
        ? double.tryParse(json['zakat_due'])
        : (json['zakat_due']?.toDouble());

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  get zakattotaldebortsvalue => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'uuid': uuid,
      'zakat_nisab': zakatNisab,
      'zakat_total_asset_value': zakatTotalAssetValue,
      'zakat_total_debts_value': zakatTotalDebtsValue,
      'zakat_total_deborts_value': zakatTotalDebortsValue,
      'zakat_due_amount': zakatDueAmount,
      'zakat_Cash_liquidity': zakatCashLiquidity,
      'zakat_due': zakatDue,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
