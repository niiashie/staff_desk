class Role {
  int? id;
  String? name;
  String? description;
  int? level;
  bool? isSystemRole;
  String? status;
  String? createdAt;
  String? updatedAt;

  Role({
    this.id,
    this.name,
    this.description,
    this.level,
    this.isSystemRole,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      level: json['level'],
      isSystemRole: json['is_system_role'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'level': level,
      'is_system_role': isSystemRole,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
