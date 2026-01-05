class DepartmentUserPivot {
  int? departmentId;
  int? userId;

  DepartmentUserPivot({
    this.departmentId,
    this.userId,
  });

  factory DepartmentUserPivot.fromJson(Map<String, dynamic> json) {
    return DepartmentUserPivot(
      departmentId: json['department_id'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'department_id': departmentId,
      'user_id': userId,
    };
  }
}

class DepartmentUser {
  int? id;
  String? name;
  String? pin;
  int? roleId;
  String? status;
  String? createdAt;
  String? updatedAt;
  DepartmentUserPivot? pivot;

  DepartmentUser({
    this.id,
    this.name,
    this.pin,
    this.roleId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory DepartmentUser.fromJson(Map<String, dynamic> json) {
    return DepartmentUser(
      id: json['id'],
      name: json['name'],
      pin: json['pin']?.toString(),
      roleId: json['role_id'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      pivot: json['pivot'] != null
          ? DepartmentUserPivot.fromJson(json['pivot'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'pin': pin,
      'role_id': roleId,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'pivot': pivot?.toJson(),
    };
  }
}
