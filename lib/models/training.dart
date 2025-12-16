class Training {
  final int? id;
  final String? educationTrainingsId;
  final String? institution;
  final String? year;
  final String? course;
  final String? location;
  final String? createdAt;
  final String? updatedAt;

  Training({
    this.id,
    this.educationTrainingsId,
    this.institution,
    this.year,
    this.course,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      id: json['id'] as int?,
      educationTrainingsId: json['education_trainings_id'],
      institution: json['instituition'] as String?,
      year: json['year'] as String?,
      course: json['course'] as String?,
      location: json['location'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'education_trainings_id': educationTrainingsId,
      'instituition': institution,
      'year': year,
      'course': course,
      'location': location,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
