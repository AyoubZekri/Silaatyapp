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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data_model {
  int? id;
  int? userId;
  String? zakatNisab;
  String? zakatTotalAssetValue;
  String? zakattotaldebtsvalue;
  String? zakattotaldebortsvalue;
  String? zakatDueAmount;
  String? zakatCashliquidity;
  String? zakatDue;
  String? createdAt;
  String? updatedAt;

  Data_model(
      {this.id,
      this.userId,
      this.zakatNisab,
      this.zakatTotalAssetValue,
      this.zakattotaldebtsvalue,
      this.zakattotaldebortsvalue,
      this.zakatDueAmount,
      this.zakatCashliquidity,
      this.zakatDue,
      this.createdAt,
      this.updatedAt});

  Data_model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    zakatNisab = json['zakat_nisab'];
    zakatTotalAssetValue = json['zakat_total_asset_value'];
    zakattotaldebtsvalue = json['zakat_total_debts_value'];
    zakattotaldebortsvalue = json['zakat_total_deborts_value'];
    zakatDueAmount = json['zakat_due_amount'];
    zakatCashliquidity = json['zakat_Cash_liquidity'];
    zakatDue = json['zakat_due'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['zakat_nisab'] = this.zakatNisab;
    data['zakat_total_asset_value'] = this.zakatTotalAssetValue;
    data['zakat_total_debts_value'] = this.zakattotaldebtsvalue;
    data['zakat_total_deborts_value'] = this.zakattotaldebortsvalue;
    data['zakat_due_amount'] = this.zakatDueAmount;
    data['zakat_Cash_liquidity'] = this.zakatCashliquidity;
    data['zakat_due'] = this.zakatDue;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
