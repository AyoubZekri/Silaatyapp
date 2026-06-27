class ChargilyPayment {
  final int id;
  final int userId;
  final String status;
  final int type;
  final String currency;
  final double amount;
  final String? createdAt;
  final String? updatedAt;

  ChargilyPayment({
    required this.id,
    required this.userId,
    required this.status,
    required this.type,
    required this.currency,
    required this.amount,
    this.createdAt,
    this.updatedAt,
  });

  factory ChargilyPayment.fromJson(Map<String, dynamic> json) {
    return ChargilyPayment(
      id: json['id'],
      userId: json['user_id'],
      status: json['status'],
      type: json['type'],
      currency: json['currency'],
      amount: double.parse(json['amount'].toString()),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'status': status,
      'type': type,
      'currency': currency,
      'amount': amount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}