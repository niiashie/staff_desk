import 'package:leave_desk/models/branch.dart';

class Department {
  int? id;
  String? name;
  String? code;
  String? description;
  int? branchId;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<dynamic>? users;
  Branch? branch;

  Department({
    this.id,
    this.name,
    this.code,
    this.description,
    this.branchId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.users,
    this.branch,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      description: json['description'],
      branchId: json['branch_id'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      users: json['users'] != null ? List<dynamic>.from(json['users']) : [],
      branch: json['branch'] != null ? Branch.fromJson(json['branch']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'branch_id': branchId,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'users': users,
      'branch': branch?.toJson(),
    };
  }
}
