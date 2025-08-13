class User_Model {
  int? status;
  String? message;
  Data? data;

  User_Model({this.status, this.message, this.data});

  User_Model.fromJson(Map<String, dynamic> json) {
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
  User? user;
  String? token;

  Data({this.user, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? familyName;
  String? phoneNumber;
  String? email;
  String? emailVerified;
  String? googleId;
  int? userNotifyStatus;
  String? fcmToken;
  int? userRole;
  int? Status;
  String? createdAt;
  String? updatedAt;
  String? profileImage;

  User(
      {this.id,
      this.name,
      this.familyName,
      this.phoneNumber,
      this.email,
      this.emailVerified,
      this.googleId,
      this.userNotifyStatus,
      this.fcmToken,
      this.Status,
      this.userRole,
      this.createdAt,
      this.updatedAt,
      this.profileImage});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    familyName = json['family_name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    emailVerified = json['email_verified'];
    googleId = json['google_id'];
    userNotifyStatus = json['user_notify_status'];
    fcmToken = json['fcm_token'];
    userRole = json['user_role'];
    Status = json['Status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['family_name'] = this.familyName;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['email_verified'] = this.emailVerified;
    data['google_id'] = this.googleId;
    data['user_notify_status'] = this.userNotifyStatus;
    data['fcm_token'] = this.fcmToken;
    data['user_role'] = this.userRole;
    data['Status'] = this.Status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['profile_image'] = this.profileImage;
    return data;
  }
}
