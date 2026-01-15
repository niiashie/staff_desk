import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leave_desk/models/api_response.dart';
import 'package:leave_desk/models/branch.dart';
import 'package:leave_desk/models/department.dart';
import 'package:leave_desk/models/user.dart';
import 'package:leave_desk/ui/base/base_screen_view_model.dart';

class DepartmentViewModel extends BaseScreenViewModel {
  final GlobalKey<FormState> addDepartmentFormKey = GlobalKey<FormState>();

  // Controllers for add department form
  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<Branch> branches = [];
  List<Department> departments = [];
  List<User> users = [];
  bool isActive = true;
  Branch? selectedBranch;
  int? selectedBranchId;
  User? selectedManager;
  Department? currentDepartment;
  final TextEditingController managerSearchController = TextEditingController();

  void setIsActive(bool value) {
    isActive = value;
    notifyListeners();
  }

  void setSelectedManager(User? user) {
    selectedManager = user;
    if (user != null) {
      managerSearchController.text = user.name ?? '';
    }
    notifyListeners();
  }

  Future<List<User>> searchUsers(String query) async {
    if (query.isEmpty) {
      return users;
    }
    return users.where((user) {
      final name = user.name?.toLowerCase() ?? '';
      final pin = user.pin?.toLowerCase() ?? '';
      final searchQuery = query.toLowerCase();
      return name.contains(searchQuery) || pin.contains(searchQuery);
    }).toList();
  }

  void setCurrentDepartment(Department? department) {
    currentDepartment = department;
    notifyListeners();
  }

  bool isCurrentUserHOD() {
    if (currentDepartment == null || appService.currentUser == null) {
      return false;
    }
    return currentDepartment!.managerId == appService.currentUser!.id;
  }

  Future<void> confirmLeaveRequest(int leaveId) async {
    Map<String, dynamic> data = {
      'status': 'confirmed',
      'confirmer_id': appService.currentUser!.id,
    };
    debugPrint("confirmer : $data");
    try {
      setBusyForObject('confirmLeave_$leaveId', true);
      ApiResponse response = await userApi.updateLeaveRequest(leaveId, data);
      if (response.ok) {
        appService.showMessage(
          title: "Success",
          message: "Leave request confirmed successfully",
        );
        // Refresh the department data
        if (currentDepartment != null) {
          await fetchDepartments();
          // Update the current department with fresh data
          final updatedDept = departments.firstWhere(
            (d) => d.id == currentDepartment!.id,
            orElse: () => currentDepartment!,
          );
          setCurrentDepartment(updatedDept);
        }
      } else {
        appService.showMessage(message: response.message);
      }
      setBusyForObject('confirmLeave_$leaveId', false);
    } on DioException catch (e) {
      setBusyForObject('confirmLeave_$leaveId', false);
      debugPrint("error : ${e.response}");
      ApiResponse errorResponse = ApiResponse.parse(e.response);
      appService.showMessage(message: errorResponse.message);
    }
  }

  Map<String, dynamic> createDepartmentPayload() {
    return {
      "name": nameController.text.trim(),
      "code": codeController.text.trim(),
      "description": descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      "manager_id": selectedManager?.id,
      "branch_id": appService.selectedBranch!.id,
      "status": isActive ? "active" : "inactive",
    };
  }

  void clearAddDepartmentForm() {
    nameController.clear();
    codeController.clear();
    descriptionController.clear();
    managerSearchController.clear();
    selectedBranchId = null;
    selectedManager = null;
    isActive = true;
    notifyListeners();
  }

  init({Department? selectedDepartment}) async {
    setBusyForObject("loading", true);
    branches = await getBranches();
    final usersData = await getUsers();
    users = usersData['users'] ?? [];
    setBusyForObject("loading", false);
    if (selectedDepartment != null) {
      nameController.text = selectedDepartment.name ?? '';
      codeController.text = selectedDepartment.code ?? '';
      descriptionController.text = selectedDepartment.description ?? '';
      selectedBranchId = selectedDepartment.branchId;
      isActive = selectedDepartment.status == 'active';
      selectedBranch = branches.where((e) => e.id == selectedBranchId).first;
      // Set selected manager if department has one
      if (selectedDepartment.managerId != null) {
        selectedManager = users.firstWhere(
          (u) => u.id == selectedDepartment.managerId,
          orElse: () => users.first,
        );
        managerSearchController.text = selectedManager?.name ?? '';
      }
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
          // Notify listeners to reload using shared controller
          appService.departmentReloadController.add(true);
          debugPrint("Department reload event emitted after create");

          appService.showMessage(
            title: "Success",
            message:
                "Successfully created department in ${appService.selectedBranch!.branchName}",
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
          // Notify listeners to reload using shared controller
          appService.departmentReloadController.add(true);
          debugPrint("Department reload event emitted after update");

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
    managerSearchController.dispose();
    super.dispose();
  }
}
