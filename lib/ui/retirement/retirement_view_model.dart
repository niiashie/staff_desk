import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:leave_desk/models/age_category.dart';
import 'package:leave_desk/models/api_response.dart';
import 'package:leave_desk/ui/base/base_screen_view_model.dart';

class RetirementViewModel extends BaseScreenViewModel {
  AgeCategoryData? ageCategoryData;

  getUsersByAge() async {
    setBusyForObject("loading", true);
    try {
      ApiResponse response = await userApi.getUsersByAge(
        branchId: appService.selectedBranch!.id!.toString(),
      );
      if (response.ok) {
        debugPrint("body : ${response.body}");
        if (response.body['data'] != null) {
          ageCategoryData = AgeCategoryData.fromJson(response.body['data']);
          notifyListeners();
        }
        setBusyForObject("loading", false);
      }
    } on DioException catch (e) {
      setBusyForObject("loading", false);
      ApiResponse errorResponse = ApiResponse.parse(e.response);
      appService.showMessage(message: errorResponse.message);
    }
  }
}
