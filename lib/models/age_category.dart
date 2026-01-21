class AgeCategoryStaff {
  int? id;
  String? name;
  String? email;
  int? age;
  String? dateOfBirth;
  String? role;
  List<String>? departments;
  List<String?>? branches;

  AgeCategoryStaff({
    this.id,
    this.name,
    this.email,
    this.age,
    this.dateOfBirth,
    this.role,
    this.departments,
    this.branches,
  });

  factory AgeCategoryStaff.fromJson(Map<String, dynamic> json) {
    return AgeCategoryStaff(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      age: json['age'],
      dateOfBirth: json['date_of_birth'],
      role: json['role'],
      departments: json['departments'] != null
          ? List<String>.from(json['departments'])
          : null,
      branches: json['branches'] != null
          ? List<String?>.from(json['branches'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'date_of_birth': dateOfBirth,
      'role': role,
      'departments': departments,
      'branches': branches,
    };
  }
}

class AgeCategory {
  int? count;
  String? description;
  List<AgeCategoryStaff>? staff;

  AgeCategory({
    this.count,
    this.description,
    this.staff,
  });

  factory AgeCategory.fromJson(Map<String, dynamic> json) {
    return AgeCategory(
      count: json['count'],
      description: json['description'],
      staff: json['staff'] != null
          ? (json['staff'] as List)
              .map((e) => AgeCategoryStaff.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'description': description,
      'staff': staff?.map((e) => e.toJson()).toList(),
    };
  }
}

class AgeCategorySummary {
  int? totalActiveStaff;
  double? youngPercentage;
  double? middleAgedPercentage;
  double? approachingRetirementPercentage;

  AgeCategorySummary({
    this.totalActiveStaff,
    this.youngPercentage,
    this.middleAgedPercentage,
    this.approachingRetirementPercentage,
  });

  factory AgeCategorySummary.fromJson(Map<String, dynamic> json) {
    return AgeCategorySummary(
      totalActiveStaff: json['total_active_staff'],
      youngPercentage: (json['young_percentage'] as num?)?.toDouble(),
      middleAgedPercentage: (json['middle_aged_percentage'] as num?)?.toDouble(),
      approachingRetirementPercentage:
          (json['approaching_retirement_percentage'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_active_staff': totalActiveStaff,
      'young_percentage': youngPercentage,
      'middle_aged_percentage': middleAgedPercentage,
      'approaching_retirement_percentage': approachingRetirementPercentage,
    };
  }
}

class AgeCategoryData {
  AgeCategory? youngStaff;
  AgeCategory? middleAgedStaff;
  AgeCategory? approachingRetirement;
  AgeCategorySummary? summary;

  AgeCategoryData({
    this.youngStaff,
    this.middleAgedStaff,
    this.approachingRetirement,
    this.summary,
  });

  factory AgeCategoryData.fromJson(Map<String, dynamic> json) {
    return AgeCategoryData(
      youngStaff: json['young_staff'] != null
          ? AgeCategory.fromJson(json['young_staff'])
          : null,
      middleAgedStaff: json['middle_aged_staff'] != null
          ? AgeCategory.fromJson(json['middle_aged_staff'])
          : null,
      approachingRetirement: json['approaching_retirement'] != null
          ? AgeCategory.fromJson(json['approaching_retirement'])
          : null,
      summary: json['summary'] != null
          ? AgeCategorySummary.fromJson(json['summary'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'young_staff': youngStaff?.toJson(),
      'middle_aged_staff': middleAgedStaff?.toJson(),
      'approaching_retirement': approachingRetirement?.toJson(),
      'summary': summary?.toJson(),
    };
  }
}
