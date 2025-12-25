import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leave_desk/api/user_api.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/models/api_response.dart';
import 'package:leave_desk/models/branch.dart';
import 'package:leave_desk/models/department.dart';
import 'package:leave_desk/services/app_service.dart';
import 'package:leave_desk/ui/base/base_screen_view_model.dart';
import 'package:stacked/stacked.dart';

class DepartmentViewModel extends BaseScreenViewModel {
  final GlobalKey<FormState> addDepartmentFormKey = GlobalKey<FormState>();

  // Controllers for add department form
  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<Branch> branches = [];
  List<Department> departments = [];
  bool isActive = true;
  Branch? selectedBranch;
  int? selectedBranchId;

  void setIsActive(bool value) {
    isActive = value;
    notifyListeners();
  }

  void setSelectedBranch(int? branchId) {
    selectedBranchId = branchId;
    selectedBranch = branches.where((e) => e.id == branchId).first;
    notifyListeners();
  }

  int? getSelectedBranchId() {
    return selectedBranchId;
  }

  Map<String, dynamic> createDepartmentPayload() {
    return {
      "name": nameController.text.trim(),
      "code": codeController.text.trim(),
      "description": descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      "manager_id": null,
      "branch_id": selectedBranchId,
      "status": isActive ? "active" : "inactive",
    };
  }

  void clearAddDepartmentForm() {
    nameController.clear();
    codeController.clear();
    descriptionController.clear();
    selectedBranchId = null;
    isActive = true;
    notifyListeners();
  }

  init({Department? selectedDepartment}) async {
    setBusyForObject("loading", true);
    await getBranches();
    setBusyForObject("loading", false);
    if (selectedDepartment != null) {
      nameController.text = selectedDepartment.name ?? '';
      codeController.text = selectedDepartment.code ?? '';
      descriptionController.text = selectedDepartment.description ?? '';
      selectedBranchId = selectedDepartment.branchId;
      isActive = selectedDepartment.status == 'active';
      selectedBranch = branches.where((e) => e.id == selectedBranchId).first;
      notifyListeners();
    }
  }

  fetchDepartments() async {
    setBusyForObject("loading", true);
    departments = await getDepartments();
    setBusyForObject("loading", false);
  }

  addDepartment() async {
    if (addDepartmentFormKey.currentState!.validate()) {
      Map<String, dynamic> payload = createDepartmentPayload();
      try {
        setBusyForObject("addDepartmentLoader", true);
        ApiResponse response = await userApi.createDepartment(payload);
        if (response.ok) {
          appService.showMessage(
            title: "Success",
            message:
                "Successfully created department in ${selectedBranch!.branchName}",
          );
          clearAddDepartmentForm();
          setBusyForObject("addDepartmentLoader", false);
        }
      } on DioException catch (e) {
        setBusyForObject("addDepartmentLoader", false);
        debugPrint("error : ${e.response}");
        ApiResponse errorResponse = ApiResponse.parse(e.response);

        appService.showMessage(message: errorResponse.message);
      }
    }
  }

  updateDepartment(Department department) async {
    if (addDepartmentFormKey.currentState!.validate()) {
      Map<String, dynamic> payload = createDepartmentPayload();
      try {
        setBusyForObject("addDepartmentLoader", true);
        ApiResponse response = await userApi.updateDepartment(
          department.id!,
          payload,
        );
        if (response.ok) {
          appService.showMessage(
            title: "Success",
            message:
                "Successfully updated department in ${selectedBranch!.branchName}",
          );
          clearAddDepartmentForm();
          setBusyForObject("addDepartmentLoader", false);
        }
      } on DioException catch (e) {
        setBusyForObject("addDepartmentLoader", false);
        debugPrint("error : ${e.response}");
        ApiResponse errorResponse = ApiResponse.parse(e.response);

        appService.showMessage(message: errorResponse.message);
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    codeController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
