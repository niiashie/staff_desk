class User {
  int? id;
  String? name;
  String? pin;
  String? role;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? accessToken;
  String? tokenType;
  bool? accountIsVerified;

  User({
    this.id,
    this.name,
    this.pin,
    this.role,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.accessToken,
    this.accountIsVerified,
    this.tokenType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var userData = json['user'] ?? {};

    return User(
      id: userData['id'],
      name: userData['name'],
      pin: userData['pin']?.toString(),
      role: userData['role'],
      status: userData['status'],
      createdAt: userData['created_at'],
      updatedAt: userData['updated_at'],
      accessToken: json['access_token'],
      accountIsVerified: json['account_is_setup'],
      tokenType: json['token_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {
        'id': id,
        'name': name,
        'pin': pin,
        'role': role,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
      },
      'access_token': accessToken,
      'token_type': tokenType,
    };
  }
}
