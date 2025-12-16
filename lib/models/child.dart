class Child {
  int? id;
  int? familyDataId;
  String? name;
  String? dateOfBirth;
  String? createdAt;
  String? updatedAt;

  Child({
    this.id,
    this.familyDataId,
    this.name,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'],
      familyDataId: int.parse(json['family_data_id'].toString()),
      name: json['name'],
      dateOfBirth: json['date_of_birth']?.toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'family_data_id': familyDataId,
      'name': name,
      'date_of_birth': dateOfBirth,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
