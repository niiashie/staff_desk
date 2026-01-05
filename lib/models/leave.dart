class Leave {
  int? id;
  int? userId;
  String? numberOfDays;
  String? daysGone;
  String? daysLeft;
  String? createdAt;
  String? updatedAt;

  Leave({
    this.id,
    this.userId,
    this.numberOfDays,
    this.daysGone,
    this.daysLeft,
    this.createdAt,
    this.updatedAt,
  });

  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
      id: json['id'],
      userId: json['user_id'],
      numberOfDays: json['number_of_days'],
      daysGone: json['days_gone'],
      daysLeft: json['days_left'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'number_of_days': numberOfDays,
      'days_gone': daysGone,
      'days_left': daysLeft,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
