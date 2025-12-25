import 'package:leave_desk/models/branch.dart';
import 'package:leave_desk/models/role.dart';

import 'beneficiary.dart';
import 'bio_data.dart';
import 'education_training.dart';
import 'emergency_contact.dart';
import 'employment_record.dart';
import 'family_data.dart';
import 'referee.dart';

class User {
  int? id;
  String? name;
  String? pin;
  int? percentageCompleteness;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? accessToken;
  String? tokenType;
  bool? accountIsVerified;
  BioData? bioData;
  FamilyData? familyData;
  Role? role;
  EmploymentRecord? employmentRecord;
  EducationTraining? educationTraining;
  List<Referee>? referees;
  List<Beneficiary>? beneficiaries;
  List<EmergencyContact>? emergencies;
  List<Branch>? branches;

  User({
    this.id,
    this.name,
    this.pin,
    this.percentageCompleteness,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.accessToken,
    this.accountIsVerified,
    this.tokenType,
    this.bioData,
    this.role,
    this.branches,
    this.familyData,
    this.employmentRecord,
    this.educationTraining,
    this.referees,
    this.beneficiaries,
    this.emergencies,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var userData = json['user'] ?? json;

    return User(
      id: userData['id'],
      name: userData['name'],
      pin: userData['pin']?.toString(),
      role: userData['role_relation'] != null
          ? Role.fromJson(userData['role_relation'])
          : null,
      status: userData['status'],
      createdAt: userData['created_at'],
      updatedAt: userData['updated_at'],
      accessToken: json['access_token'],
      percentageCompleteness: json['percentage_completeness'],
      accountIsVerified: json['account_is_setup'],
      tokenType: json['token_type'],
      bioData: userData['bio_data'] != null
          ? BioData.fromJson(userData['bio_data'])
          : null,
      familyData: userData['family_data'] != null
          ? FamilyData.fromJson(userData['family_data'])
          : null,
      employmentRecord: userData['employment_record'] != null
          ? EmploymentRecord.fromJson(userData['employment_record'])
          : null,
      educationTraining: userData['education_training'] != null
          ? EducationTraining.fromJson(userData['education_training'])
          : null,
      referees: userData['referees'] != null
          ? (userData['referees'] as List)
                .map((e) => Referee.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      beneficiaries: userData['beneficiaries'] != null
          ? (userData['beneficiaries'] as List)
                .map((e) => Beneficiary.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      emergencies: userData['emergencies'] != null
          ? (userData['emergencies'] as List)
                .map(
                  (e) => EmergencyContact.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : null,
      branches: userData['branches'] != null
          ? (userData['branches'] as List)
                .map((e) => Branch.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {
        'id': id,
        'name': name,
        'pin': pin,

        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'bio_data': bioData?.toJson(),
        'family_data': familyData?.toJson(),
        'employment_record': employmentRecord?.toJson(),
        'education_training': educationTraining?.toJson(),
        'referees': referees?.map((e) => e.toJson()).toList(),
        'beneficiaries': beneficiaries?.map((e) => e.toJson()).toList(),
        'emergencies': emergencies?.map((e) => e.toJson()).toList(),
      },
      'access_token': accessToken,
      'token_type': tokenType,
      'account_is_setup': accountIsVerified,
    };
  }
}
