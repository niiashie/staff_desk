class EmergencyContact {
  final int? id;
  final int? userId;
  final String? name;
  final String? address;
  final String? telephoneNumber;
  final String? createdAt;
  final String? updatedAt;

  EmergencyContact({
    this.id,
    this.userId,
    this.name,
    this.address,
    this.telephoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      telephoneNumber: json['telephone_number']?.toString(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'address': address,
      'telephone_number': telephoneNumber,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
