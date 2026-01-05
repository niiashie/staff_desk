import 'package:leave_desk/models/branch.dart';
import 'package:leave_desk/models/department_user.dart';
import 'package:leave_desk/models/user.dart';

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
  User? manager;
  List<DepartmentUser>? users;
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
      manager: json['manager'] != null ? User.fromJson(json['manager']) : null,
      users: json['users'] != null
          ? (json['users'] as List)
              .map((e) => DepartmentUser.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
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
      'manager': manager?.toJson(),
      'users': users?.map((e) => e.toJson()).toList(),
      'branch': branch?.toJson(),
    };
  }
}
