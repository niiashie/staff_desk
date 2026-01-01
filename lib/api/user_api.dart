import 'dart:io';
import 'package:dio/dio.dart';
import 'package:leave_desk/api/base_api.dart';
import 'package:leave_desk/app/api.dart';
import 'package:leave_desk/models/api_response.dart';

class UserApi extends BaseApi {
  Future<ApiResponse> createBioData(Map<String, dynamic> params) async {
    FormData formData = await _prepareFormData(params);
    var response = await postMultipart(url: Api.bioData, data: formData);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> updateBioData(Map<String, dynamic> params) async {
    FormData formData = await _prepareFormData(params);
    var response = await putMultipart(url: Api.bioData, data: formData);
    return ApiResponse.parse(response);
  }

  Future<FormData> _prepareFormData(Map<String, dynamic> params) async {
    Map<String, dynamic> formDataMap = {};

    for (var entry in params.entries) {
      if (entry.value is File) {
        // Handle file upload
        File file = entry.value as File;
        String fileName = file.path.split('/').last;
        formDataMap[entry.key] = await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        );
      } else if (entry.value != null) {
        // Handle regular fields
        formDataMap[entry.key] = entry.value;
      }
    }

    return FormData.fromMap(formDataMap);
  }

  Future<ApiResponse> createFamilyData(Map<String, dynamic> params) async {
    var response = await post(url: Api.familyData, data: params);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> updateFamilyData(Map<String, dynamic> params) async {
    var response = await post(url: Api.familyData, data: params);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> createEmploymentData(Map<String, dynamic> params) async {
    var response = await post(url: Api.employmentData, data: params);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> updateEmploymentData(Map<String, dynamic> params) async {
    var response = await put(url: Api.employmentData, data: params);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> createEducationTraining(
    Map<String, dynamic> params,
  ) async {
    var response = await post(url: Api.educationTraining, data: params);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> updateEducationTraining(
    Map<String, dynamic> params,
  ) async {
    var response = await put(url: Api.educationTraining, data: params);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> createReferee(Map<String, dynamic> params) async {
    var response = await post(url: Api.referees, data: params);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> updateReferee(Map<String, dynamic> params) async {
    var response = await put(url: Api.referees, data: params);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> createBeneficiary(Map<String, dynamic> params) async {
    var response = await post(url: Api.beneficiaries, data: params);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> updateBeneficiary(Map<String, dynamic> params) async {
    var response = await put(url: Api.beneficiaries, data: params);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> createEmergencyContact(
    Map<String, dynamic> params,
  ) async {
    var response = await post(url: Api.emergencyContact, data: params);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> updateEmergencyContact(
    Map<String, dynamic> params,
  ) async {
    var response = await put(url: Api.emergencyContact, data: params);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> createRole(Map<String, dynamic> payload) async {
    var response = await post(url: Api.role, data: payload);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> updateRole(int id, Map<String, dynamic> payload) async {
    var response = await put(url: "${Api.role}/$id", data: payload);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> getRoles() async {
    var response = await get(url: Api.role);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> createBranch(Map<String, dynamic> payload) async {
    var response = await post(url: Api.branch, data: payload);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> getBranch() async {
    var response = await get(url: Api.branch);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> updateBranch(int id, Map<String, dynamic> payload) async {
    var response = await put(url: "${Api.branch}/$id", data: payload);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> createDepartment(Map<String, dynamic> payload) async {
    var response = await post(url: Api.department, data: payload);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> getDepartment() async {
    var response = await get(url: Api.department);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> updateDepartment(
    int id,
    Map<String, dynamic> payload,
  ) async {
    var response = await put(url: "${Api.department}/$id", data: payload);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> getUsers({int? page = 1}) async {
    Map<String, dynamic> params = {"per_page": 10, "page": page};
    var response = await get(url: Api.users, queryParameters: params);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> assignUserToBranch(Map<String, dynamic> payload) async {
    var response = await post(url: Api.assignUser, data: payload);
    return ApiResponse.parse(response);
  }
}
