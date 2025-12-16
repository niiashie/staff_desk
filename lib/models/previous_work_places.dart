class PreviousWorkPlaces {
  final int? id;
  final String? employmentRecordId;
  final String? companyInstitution;
  final String? jobTitle;
  final String? date;
  final String? createdAt;
  final String? updatedAt;

  PreviousWorkPlaces({
    this.id,
    this.employmentRecordId,
    this.companyInstitution,
    this.jobTitle,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory PreviousWorkPlaces.fromJson(Map<String, dynamic> json) {
    return PreviousWorkPlaces(
      id: json['id'] as int?,
      employmentRecordId: json['employment_record_id'],
      companyInstitution: json['company_instituition'] as String?,
      jobTitle: json['job_title'] as String?,
      date: json['date'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employment_record_id': employmentRecordId,
      'company_instituition': companyInstitution,
      'job_title': jobTitle,
      'date': date,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
