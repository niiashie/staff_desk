class AcademicQualification {
  final int? id;
  final String? educationTrainingsId;
  final String? year;
  final String? institution;
  final String? qualification;
  final String? createdAt;
  final String? updatedAt;

  AcademicQualification({
    this.id,
    this.educationTrainingsId,
    this.year,
    this.institution,
    this.qualification,
    this.createdAt,
    this.updatedAt,
  });

  factory AcademicQualification.fromJson(Map<String, dynamic> json) {
    return AcademicQualification(
      id: json['id'] as int?,
      educationTrainingsId: json['education_trainings_id'].toString(),
      year: json['year'] as String?,
      institution: json['institution'] as String?,
      qualification: json['qualification'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'education_trainings_id': educationTrainingsId,
      'year': year,
      'institution': institution,
      'qualification': qualification,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
