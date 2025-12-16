class Beneficiary {
  final int? id;
  final int? userId;
  final String? name;
  final String? addressTelephoneNumber;
  final String? relationship;
  final String? percentageOfBenefit;
  final String? createdAt;
  final String? updatedAt;

  Beneficiary({
    this.id,
    this.userId,
    this.name,
    this.addressTelephoneNumber,
    this.relationship,
    this.percentageOfBenefit,
    this.createdAt,
    this.updatedAt,
  });

  factory Beneficiary.fromJson(Map<String, dynamic> json) {
    return Beneficiary(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      name: json['name'] as String?,
      addressTelephoneNumber: json['address_telephone_number'] as String?,
      relationship: json['relationship'] as String?,
      percentageOfBenefit: json['percentage_of_benefit'],
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'address_telephone_number': addressTelephoneNumber,
      'relationship': relationship,
      'percentage_of_benefit': percentageOfBenefit,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
