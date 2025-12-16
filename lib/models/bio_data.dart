class BioData {
  int? id;
  int? userId;
  String? image;
  String? surname;
  String? otherNames;
  String? previousNames;
  String? dateOfBirth;
  String? nationality;
  String? homeTown;
  String? region;
  String? gender;
  String? houseNumber;
  String? cityTown;
  String? digitalAddress;
  String? streetName;
  String? nearestLandmark;
  String? postAddress;
  String? emailAddress;
  String? telephone;
  String? socialSecurityNumber;
  String? bank;
  String? branchName;
  String? accountName;
  List<String>? languagesSpoken;
  String? physicalDisability;
  String? createdAt;
  String? updatedAt;

  BioData({
    this.id,
    this.userId,
    this.image,
    this.surname,
    this.otherNames,
    this.previousNames,
    this.dateOfBirth,
    this.nationality,
    this.homeTown,
    this.region,
    this.gender,
    this.houseNumber,
    this.cityTown,
    this.digitalAddress,
    this.streetName,
    this.nearestLandmark,
    this.postAddress,
    this.emailAddress,
    this.telephone,
    this.socialSecurityNumber,
    this.bank,
    this.branchName,
    this.accountName,
    this.languagesSpoken,
    this.physicalDisability,
    this.createdAt,
    this.updatedAt,
  });

  factory BioData.fromJson(Map<String, dynamic> json) {
    return BioData(
      id: json['id'],
      userId: json['user_id'],
      image: json['image'],
      surname: json['surname'],
      otherNames: json['other_names'],
      previousNames: json['previous_names'],
      dateOfBirth: json['date_of_birth']?.toString(),
      nationality: json['nationality'],
      homeTown: json['home_town'],
      region: json['region'],
      gender: json['gender'],
      houseNumber: json['house_number']?.toString(),
      cityTown: json['city_town'],
      digitalAddress: json['digital_address']?.toString(),
      streetName: json['street_name'],
      nearestLandmark: json['nearest_landmark'],
      postAddress: json['post_address']?.toString(),
      emailAddress: json['email_address'],
      telephone: json['telephone']?.toString(),
      socialSecurityNumber: json['social_security_number']?.toString(),
      bank: json['bank'],
      branchName: json['branch_name'],
      accountName: json['account_name']?.toString(),
      languagesSpoken: json['languages_spoken'] is List
          ? List<String>.from(json['languages_spoken'])
          : json['languages_spoken']?.toString().split(','),
      physicalDisability: json['physical_disability'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'image': image,
      'surname': surname,
      'other_names': otherNames,
      'previous_names': previousNames,
      'date_of_birth': dateOfBirth,
      'nationality': nationality,
      'home_town': homeTown,
      'region': region,
      'gender': gender,
      'house_number': houseNumber,
      'city_town': cityTown,
      'digital_address': digitalAddress,
      'street_name': streetName,
      'nearest_landmark': nearestLandmark,
      'post_address': postAddress,
      'email_address': emailAddress,
      'telephone': telephone,
      'social_security_number': socialSecurityNumber,
      'bank': bank,
      'branch_name': branchName,
      'account_name': accountName,
      'languages_spoken': languagesSpoken,
      'physical_disability': physicalDisability,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
