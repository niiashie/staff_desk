import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leave_desk/models/api_response.dart';
import 'package:leave_desk/ui/base/base_screen_view_model.dart';

class DashboardViewModel extends BaseScreenViewModel {
  getDashboard() async {
    setBusyForObject("loading", true);

    try {
      ApiResponse response = await userApi.getDashboard();
      if (response.ok) {
        debugPrint("body : ${response.body}");
        setBusyForObject("loading", false);
      }
    } on DioException catch (e) {
      setBusyForObject("loading", false);
      ApiResponse errorResponse = ApiResponse.parse(e.response);
      appService.showMessage(message: errorResponse.message);
    }
  }
}
