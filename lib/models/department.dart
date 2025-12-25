import 'package:leave_desk/models/branch.dart';

class Department {
  int? id;
  String? name;
  String? code;
  String? description;
  int? managerId;
  int? branchId;
  String? status;
  String? createdAt;
  String? updatedAt;
  dynamic manager;
  List<dynamic>? users;
  Branch? branch;

  Department({
    this.id,
    this.name,
    this.code,
    this.description,
    this.managerId,
    this.branchId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.manager,
    this.users,
    this.branch,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      description: json['description'],
      managerId: json['manager_id'],
      branchId: json['branch_id'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      manager: json['manager'],
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
      'manager_id': managerId,
      'branch_id': branchId,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'manager': manager,
      'users': users,
      'branch': branch?.toJson(),
    };
  }
}
