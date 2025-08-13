class UserResponse {
  final int status;
  final String message;
  final UserData data;

  UserResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      status: json['status'],
      message: json['message'],
      data: UserData.fromJson(json['data']),
    );
  }
}

class UserData {
  final List<User> data;

  UserData({required this.data});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      data: List<User>.from(json['data'].map((x) => User.fromJson(x))),
    );
  }
}

class User {
  final int id;
  final String name;
  final String familyName;
  final String phoneNumber;
  final String email;
  final String? emailVerified;
  final String? googleId;
  final int userNotifyStatus;
  final String? fcmToken;
  final int userRole;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? profileImage;
  final int status;
  final DateTime dateExperiment;

  User({
    required this.id,
    required this.name,
    required this.familyName,
    required this.phoneNumber,
    required this.email,
    this.emailVerified,
    this.googleId,
    required this.userNotifyStatus,
    this.fcmToken,
    required this.userRole,
    required this.createdAt,
    required this.updatedAt,
    this.profileImage,
    required this.status,
    required this.dateExperiment,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      familyName: json['family_name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      emailVerified: json['email_verified'],
      googleId: json['google_id'],
      userNotifyStatus: json['user_notify_status'],
      fcmToken: json['fcm_token'],
      userRole: json['user_role'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      profileImage: json['profile_image'],
      status: json['Status'],
      dateExperiment: DateTime.parse(json['date_experiment']),
    );
  }
}
