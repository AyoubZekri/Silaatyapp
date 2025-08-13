class Report_Model {
  int? status;
  String? message;
  Data? data;

  Report_Model({this.status, this.message, this.data});

  Report_Model.fromJson(Map<String, dynamic> json) {
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
  List<Report>? report;

  Data({this.report});

  Data.fromJson(Map<String, dynamic> json) {
    final rawReport = json['Report'];

    if (rawReport != null) {
      report = <Report>[];

      if (rawReport is List) {
        for (var item in rawReport) {
          report!.add(Report.fromJson(item));
        }
      } else if (rawReport is Map<String, dynamic>) {
        report!.add(Report.fromJson(rawReport));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.report != null) {
      data['Report'] = this.report!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Report {
  int? id;
  int? reportId;
  String? report;
  String? createdAt;
  String? updatedAt;

  Report({this.id, this.reportId, this.report, this.createdAt, this.updatedAt});

  Report.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reportId = json['report_id'];
    report = json['report'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['report_id'] = this.reportId;
    data['report'] = this.report;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
