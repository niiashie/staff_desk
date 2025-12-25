class Branch {
  int? id;
  String? branchName;
  String? address;
  String? city;
  String? phoneNumber;
  String? status;
  String? createdAt;
  String? updatedAt;

  Branch({
    this.id,
    this.branchName,
    this.address,
    this.city,
    this.phoneNumber,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'],
      branchName: json['branch_name'],
      address: json['address'],
      city: json['city'],
      phoneNumber: json['phone_number']?.toString(),
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_name': branchName,
      'address': address,
      'city': city,
      'phone_number': phoneNumber,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
