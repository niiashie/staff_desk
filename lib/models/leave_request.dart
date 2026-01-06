import 'package:leave_desk/models/user.dart';

class LeaveRequest {
  int? id;
  int? userId;
  int? approverId;
  int? handOverId;
  String? description;
  int? numberOfDays;
  String? startDate;
  String? endDate;
  String? status;
  String? createdAt;
  String? updatedAt;
  User? user;
  User? approver;
  User? handOver;

  LeaveRequest({
    this.id,
    this.userId,
    this.approverId,
    this.handOverId,
    this.description,
    this.numberOfDays,
    this.startDate,
    this.endDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.approver,
    this.handOver,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'],
      userId: json['user_id'],
      approverId: json['approver_id'],
      handOverId: json['hand_over_id'],
      description: json['description'],
      numberOfDays: json['number_of_days'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      approver:
          json['approver'] != null ? User.fromJson(json['approver']) : null,
      handOver:
          json['hand_over'] != null ? User.fromJson(json['hand_over']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'approver_id': approverId,
      'hand_over_id': handOverId,
      'description': description,
      'number_of_days': numberOfDays,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user?.toJson(),
      'approver': approver?.toJson(),
      'hand_over': handOver?.toJson(),
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
