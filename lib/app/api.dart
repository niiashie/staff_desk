class Api {
  static const int connectionTimeout = 35;
  static const int receiveTimeout = 20;
  static String baseUrl = "http://fran-worker-database.test/api";
  static const String login = "/login";
  static const String registration = "/register";
  static const String bioData = "/bio-data";
  static const String familyData = "/family-data";
  static const String employmentData = "/employment-record";
  static const String educationTraining = "/education-training";
  static const String referees = "/referees";
  static const String role = "/roles";
  static const String branch = "/branches";
  static const String beneficiaries = "/beneficiaries";
  static const String emergencyContact = "/emergencies";
  static const String department = "/departments";
  static const String users = "/users";
  static const String assignUser = "/branches/assign-user";
  static const String unassignUser = "/branches/unassign-user";
  static const String assignDepartment = "/departments/assign-users";
  static const String unassignDepartment = "/departments/unassign-users";
  static const String assignManager = "/departments/assign-manager";
  static const String unassignManager = "/departments/unassign-manager";
  static const String leave = "/leaves";
  static const String leaveRequest = "/leave-requests";
}
