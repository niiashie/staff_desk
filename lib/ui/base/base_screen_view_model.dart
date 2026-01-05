import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leave_desk/api/user_api.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/constants/images.dart';
import 'package:leave_desk/models/api_response.dart';
import 'package:leave_desk/models/branch.dart';
import 'package:leave_desk/models/department.dart';
import 'package:leave_desk/models/navigation_item.dart';
import 'package:leave_desk/models/user.dart';
import 'package:leave_desk/services/app_service.dart';
import 'package:leave_desk/utils.dart';
import 'package:stacked/stacked.dart' show BaseViewModel;

class BaseScreenViewModel extends BaseViewModel {
  List<String> labels = [];
  List<String> icons = [];

  UserApi userApi = UserApi();
  var appService = locator<AppService>();
  int selection = 0;

  setSelection(select) {
    selection = select;

    String route = "/${labels[select].toLowerCase()}";
    // getSelection(selection);
    appService.controller.add(NavigationItem(labels[select], route, "main"));
    Utils.sideMenuNavigationKey.currentState?.pushReplacementNamed(route);
    rebuildUi();
  }

  populateAdminSideMenus() {
    labels = [
      "Dashboard",
      "Staff",
      "Leave",
      "Branches",
      "Roles",
      "Departments",
      "Retirement",
    ];

    icons = [
      AppImages.dashboard,
      AppImages.staff,
      AppImages.leave,
      AppImages.branch,
      AppImages.roles,
      AppImages.department,
      AppImages.retire,
    ];
  }

  populateStaffSideMenu() {
    labels = ["Dashboard", "Leave", "Departments"];

    icons = [AppImages.dashboard, AppImages.leave, AppImages.department];
  }

  init() {
    if (appService.currentUser!.role!.name!.contains("admin")) {
      populateAdminSideMenus();
    } else {
      populateStaffSideMenu();
    }
    rebuildUi();
  }

  Future<List<Branch>> getBranches() async {
    try {
      ApiResponse response = await userApi.getBranch();
      if (response.ok) {
        List<Branch> branches = (response.data as List)
            .map((e) => Branch.fromJson(e))
            .toList();
        return branches;
      }
    } on DioException catch (e) {
      ApiResponse errorResponse = ApiResponse.parse(e.response);

      appService.showMessage(message: errorResponse.message);
      return [];
    }
    return [];
  }

  Future<List<Department>> getDepartments() async {
    try {
      ApiResponse response = await userApi.getDepartment();
      if (response.ok) {
        debugPrint("departments : ${response.data}");
        List<Department> departments = (response.data as List)
            .map((e) => Department.fromJson(e))
            .toList();
        return departments;
      }
    } on DioException catch (e) {
      ApiResponse errorResponse = ApiResponse.parse(e.response);

      appService.showMessage(message: errorResponse.message);
      return [];
    }
    return [];
  }

  Future<Map<String, dynamic>> getUsers({int? page = 1}) async {
    debugPrint("page : $page");
    try {
      ApiResponse response = await userApi.getUsers(page: page);
      if (response.ok) {
        debugPrint("response : ${response.data}");
        List<User> users = (response.data as List)
            .map((e) => User.fromJson(e))
            .toList();

        return {"users": users, "totalPages": response.totalPages ?? 1};
      }
    } on DioException catch (e) {
      ApiResponse errorResponse = ApiResponse.parse(e.response);
      appService.showMessage(message: errorResponse.message);
      return {};
    }

    return {};
  }
}
