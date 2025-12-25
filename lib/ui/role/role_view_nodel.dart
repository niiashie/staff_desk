import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leave_desk/api/user_api.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/models/api_response.dart';
import 'package:leave_desk/models/role.dart';
import 'package:leave_desk/services/app_service.dart';
import 'package:stacked/stacked.dart';

class RoleViewNodel extends BaseViewModel {
  UserApi userApi = UserApi();
  final GlobalKey<FormState> addRoleFormKey = GlobalKey<FormState>();
  var appService = locator<AppService>();

  // Controllers for add role form
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController levelController = TextEditingController();

  bool isSystemRole = false;
  bool isActive = true;
  List<Role> roles = [];

  void setIsSystemRole(bool value) {
    isSystemRole = value;
    notifyListeners();
  }

  void setIsActive(bool value) {
    isActive = value;
    notifyListeners();
  }

  init({Role? role}) {
    getRoles();

    if (role != null) {
      nameController.text = role.name!;
      levelController.text = role.level.toString();
      descriptionController.text = role.description.toString();
      isSystemRole = role.isSystemRole!;
      isActive = role.status == "active" ? true : false;
      rebuildUi();
    }
  }

  getRoles() async {
    try {
      setBusyForObject("loading", true);
      ApiResponse response = await userApi.getRoles();
      if (response.ok) {
        debugPrint("roles data : ${response.data}");
        setBusyForObject("loading", false);
        roles = (response.data as List).map((e) => Role.fromJson(e)).toList();
        rebuildUi();
      }
    } on DioException catch (e) {
      setBusyForObject("loading", false);
      ApiResponse errorResponse = ApiResponse.parse(e.response);

      appService.showMessage(message: errorResponse.message);
    }
  }

  updateRole(int id) async {
    if (addRoleFormKey.currentState?.validate() ?? false) {
      // Form is valid, prepare payload
      final payload = {
        "name": nameController.text.trim(),
        "description": descriptionController.text.trim(),
        "level": int.parse(levelController.text.trim()),
        "is_system_role": isSystemRole,
        "status": isActive ? "active" : "inactive",
      };

      try {
        setBusyForObject("addRoleLoader", true);
        ApiResponse response = await userApi.updateRole(id, payload);
        if (response.ok) {
          clearAllFields();
          rebuildUi();
          setBusyForObject("addRoleLoader", false);
          appService.showMessage(message: "Role successfully created");
        }
      } on DioException catch (e) {
        setBusyForObject("addRoleLoader", false);
        debugPrint("error: ${e.response!.data}");
        ApiResponse errorResponse = ApiResponse.parse(e.response);

        appService.showMessage(message: errorResponse.message);
      }
    }
  }

  void submitRole() async {
    if (addRoleFormKey.currentState?.validate() ?? false) {
      // Form is valid, prepare payload
      final payload = {
        "name": nameController.text.trim(),
        "description": descriptionController.text.trim(),
        "level": int.parse(levelController.text.trim()),
        "is_system_role": isSystemRole,
        "status": isActive ? "active" : "inactive",
      };

      try {
        setBusyForObject("addRoleLoader", true);
        ApiResponse response = await userApi.createRole(payload);
        if (response.ok) {
          clearAllFields();
          rebuildUi();
          setBusyForObject("addRoleLoader", false);
          appService.showMessage(message: "Role successfully created");
        }
      } on DioException catch (e) {
        setBusyForObject("addRoleLoader", false);
        ApiResponse errorResponse = ApiResponse.parse(e.response);

        appService.showMessage(message: errorResponse.message);
      }
    }
  }

  void clearAllFields() {
    nameController.clear();
    descriptionController.clear();
    levelController.clear();
    isSystemRole = false;
    isActive = true;
    addRoleFormKey.currentState?.reset();
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    levelController.dispose();
    super.dispose();
  }
}
