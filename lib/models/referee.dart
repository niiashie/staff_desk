class Referee {
  final int? id;
  final int? userId;
  final String? name;
  final String? occupation;
  final String? address;
  final String? createdAt;
  final String? updatedAt;

  Referee({
    this.id,
    this.userId,
    this.name,
    this.occupation,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory Referee.fromJson(Map<String, dynamic> json) {
    return Referee(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      name: json['name'] as String?,
      occupation: json['occupation'] as String?,
      address: json['address'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'occupation': occupation,
      'address': address,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
