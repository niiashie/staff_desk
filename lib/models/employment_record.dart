import 'previous_work_places.dart';

class EmploymentRecord {
  final int? id;
  final int? userId;
  final String? numberOfPreviousWorkPlace;
  final String? presentJobTitle;
  final String? dateOfEmployment;
  final String? probationPeriod;
  final String? immediateSupervisor;
  final String? employmentStatus;
  final String? careerObjects;
  final String? createdAt;
  final String? updatedAt;
  final List<PreviousWorkPlaces>? previousWorkPlaces;

  EmploymentRecord({
    this.id,
    this.userId,
    this.numberOfPreviousWorkPlace,
    this.presentJobTitle,
    this.dateOfEmployment,
    this.probationPeriod,
    this.immediateSupervisor,
    this.employmentStatus,
    this.careerObjects,
    this.createdAt,
    this.updatedAt,
    this.previousWorkPlaces,
  });

  factory EmploymentRecord.fromJson(Map<String, dynamic> json) {
    return EmploymentRecord(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      numberOfPreviousWorkPlace: json['number_of_previous_work_place'],
      presentJobTitle: json['present_job_title'] as String?,
      dateOfEmployment: json['date_of_employment'] as String?,
      probationPeriod: json['probation_period'] as String?,
      immediateSupervisor: json['immediate_supervisor'] as String?,
      employmentStatus: json['employment_status'] as String?,
      careerObjects: json['career_objects'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      previousWorkPlaces: json['previous_work_places'] != null
          ? (json['previous_work_places'] as List)
                .map(
                  (e) => PreviousWorkPlaces.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'number_of_previous_work_place': numberOfPreviousWorkPlace,
      'present_job_title': presentJobTitle,
      'date_of_employment': dateOfEmployment,
      'probation_period': probationPeriod,
      'immediate_supervisor': immediateSupervisor,
      'employment_status': employmentStatus,
      'career_objects': careerObjects,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'previous_work_places': previousWorkPlaces
          ?.map((e) => e.toJson())
          .toList(),
    };
  }
}
