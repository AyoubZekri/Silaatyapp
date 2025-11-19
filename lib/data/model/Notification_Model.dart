class Notification_Model {
  int? status;
  String? message;
  Data? data;

  Notification_Model({this.status, this.message, this.data});

  Notification_Model.fromJson(Map<String, dynamic> json) {
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
  List<Notifications>? notifications;

  Data({this.notifications});

  Data.fromJson(Map<String, dynamic> json) {
    final rawNotification = json['Notifications'];

    if (rawNotification != null) {
      notifications = <Notifications>[];

      if (rawNotification is List) {
        for (var item in rawNotification) {
          notifications!.add(Notifications.fromJson(item));
        }
      } else if (rawNotification is Map<String, dynamic>) {
        notifications!.add(Notifications.fromJson(rawNotification));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notifications != null) {
      data['Notifications'] =
          this.notifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  int? id;
  String? uuid;
  String? title;
  String? content;
  int? isRead;
  int? userId;
  String? createdAt;
  String? updatedAt;

  Notifications(
      {this.id,
      this.uuid,
      this.title,
      this.content,
      this.isRead,
      this.userId,
      this.createdAt,
      this.updatedAt});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    title = json['title'];
    content = json['content'];
    isRead = json['is_read'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['title'] = this.title;
    data['content'] = this.content;
    data['is_read'] = this.isRead;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
