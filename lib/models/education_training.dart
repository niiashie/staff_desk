import 'academic_qualification.dart';
import 'training.dart';

class EducationTraining {
  final int? id;
  final int? userId;
  final String? numberOfAcademicQualifications;
  final String? numberOfProfessionalTraining;
  final String? hobbiesSpecialInterest;
  final String? createdAt;
  final String? updatedAt;
  final List<AcademicQualification>? academicQualifications;
  final List<Training>? trainings;

  EducationTraining({
    this.id,
    this.userId,
    this.numberOfAcademicQualifications,
    this.numberOfProfessionalTraining,
    this.hobbiesSpecialInterest,
    this.createdAt,
    this.updatedAt,
    this.academicQualifications,
    this.trainings,
  });

  factory EducationTraining.fromJson(Map<String, dynamic> json) {
    return EducationTraining(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      numberOfAcademicQualifications: json['number_of_academic_qualifications'],
      numberOfProfessionalTraining: json['number_of_professional_training'],
      hobbiesSpecialInterest: json['hobbies_special_interes'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      academicQualifications: json['academic_qualifications'] != null
          ? (json['academic_qualifications'] as List)
                .map(
                  (e) =>
                      AcademicQualification.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : null,
      trainings: json['trainings'] != null
          ? (json['trainings'] as List)
                .map((e) => Training.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'number_of_academic_qualifications': numberOfAcademicQualifications,
      'number_of_professional_training': numberOfProfessionalTraining,
      'hobbies_special_interes': hobbiesSpecialInterest,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'academic_qualifications': academicQualifications
          ?.map((e) => e.toJson())
          .toList(),
      'trainings': trainings?.map((e) => e.toJson()).toList(),
    };
  }
}
