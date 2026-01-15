import 'package:leave_desk/models/beneficiary.dart';
import 'package:leave_desk/models/bio_data.dart';
import 'package:leave_desk/models/education_training.dart';
import 'package:leave_desk/models/emergency_contact.dart';
import 'package:leave_desk/models/employment_record.dart';
import 'package:leave_desk/models/family_data.dart';
import 'package:leave_desk/models/leave_request.dart';
import 'package:leave_desk/models/referee.dart';

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
  int? percentageCompleteness;
  DepartmentUserPivot? pivot;
  List<LeaveRequest>? leaveInfos;
  BioData? bioData;
  FamilyData? familyData;
  EmploymentRecord? employmentRecord;
  EducationTraining? educationTraining;
  List<EmergencyContact>? emergencies;
  List<Beneficiary>? beneficiaries;
  List<Referee>? referees;

  DepartmentUser({
    this.id,
    this.name,
    this.pin,
    this.roleId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.percentageCompleteness,
    this.pivot,
    this.leaveInfos,
    this.bioData,
    this.familyData,
    this.employmentRecord,
    this.educationTraining,
    this.emergencies,
    this.beneficiaries,
    this.referees,
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
      percentageCompleteness: json['percentage_completeness'],
      pivot: json['pivot'] != null
          ? DepartmentUserPivot.fromJson(json['pivot'])
          : null,
      leaveInfos: json['leave_infos'] != null
          ? (json['leave_infos'] as List)
              .map((e) => LeaveRequest.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      bioData: json['bio_data'] != null
          ? BioData.fromJson(json['bio_data'])
          : null,
      familyData: json['family_data'] != null
          ? FamilyData.fromJson(json['family_data'])
          : null,
      employmentRecord: json['employment_record'] != null
          ? EmploymentRecord.fromJson(json['employment_record'])
          : null,
      educationTraining: json['education_training'] != null
          ? EducationTraining.fromJson(json['education_training'])
          : null,
      emergencies: json['emergencies'] != null
          ? (json['emergencies'] as List)
              .map((e) => EmergencyContact.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      beneficiaries: json['beneficiaries'] != null
          ? (json['beneficiaries'] as List)
              .map((e) => Beneficiary.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      referees: json['referees'] != null
          ? (json['referees'] as List)
              .map((e) => Referee.fromJson(e as Map<String, dynamic>))
              .toList()
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
      'percentage_completeness': percentageCompleteness,
      'pivot': pivot?.toJson(),
      'leave_infos': leaveInfos?.map((e) => e.toJson()).toList(),
      'bio_data': bioData?.toJson(),
      'family_data': familyData?.toJson(),
      'employment_record': employmentRecord?.toJson(),
      'education_training': educationTraining?.toJson(),
      'emergencies': emergencies?.map((e) => e.toJson()).toList(),
      'beneficiaries': beneficiaries?.map((e) => e.toJson()).toList(),
      'referees': referees?.map((e) => e.toJson()).toList(),
    };
  }
}
