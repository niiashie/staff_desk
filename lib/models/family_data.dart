import 'child.dart';

class FamilyData {
  int? id;
  int? userId;
  String? maritalStatus;
  String? spouseName;
  String? spouseOccupation;
  String? fatherName;
  String? fatherIsDeceased;
  String? motherName;
  String? motherIsDeceased;
  String? numberOfChildren;
  String? createdAt;
  String? updatedAt;
  List<Child>? children;

  FamilyData({
    this.id,
    this.userId,
    this.maritalStatus,
    this.spouseName,
    this.spouseOccupation,
    this.fatherName,
    this.fatherIsDeceased,
    this.motherName,
    this.motherIsDeceased,
    this.numberOfChildren,
    this.createdAt,
    this.updatedAt,
    this.children,
  });

  factory FamilyData.fromJson(Map<String, dynamic> json) {
    return FamilyData(
      id: json['id'],
      userId: json['user_id'],
      maritalStatus: json['marital_status'],
      spouseName: json['spouse_name'],
      spouseOccupation: json['spouse_occupation'],
      fatherName: json['father_name'],
      fatherIsDeceased: json['father_is_deceased'],
      motherName: json['mother_name'],
      motherIsDeceased: json['mother_is_deceased'],
      numberOfChildren: json['number_of_children'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      children: json['children'] != null
          ? (json['children'] as List)
                .map((childJson) => Child.fromJson(childJson))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'marital_status': maritalStatus,
      'spouse_name': spouseName,
      'spouse_occupation': spouseOccupation,
      'father_name': fatherName,
      'father_is_deceased': fatherIsDeceased,
      'mother_name': motherName,
      'mother_is_deceased': motherIsDeceased,
      'number_of_children': numberOfChildren,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'children': children?.map((child) => child.toJson()).toList(),
    };
  }
}
