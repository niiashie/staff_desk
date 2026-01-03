import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leave_desk/api/user_api.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/models/api_response.dart';
import 'package:leave_desk/models/branch.dart';
import 'package:leave_desk/models/navigation_item.dart';
import 'package:leave_desk/services/app_service.dart';
import 'package:leave_desk/utils.dart';
import 'package:stacked/stacked.dart';

class BranchViewModel extends BaseViewModel {
  var appService = locator<AppService>();
  final GlobalKey<FormState> addBranchFormKey = GlobalKey<FormState>();
  UserApi userApi = UserApi();
  List<Branch> branches = [];

  // Controllers for add branch form
  final TextEditingController branchNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  bool isActive = true;

  void setIsActive(bool value) {
    isActive = value;
    notifyListeners();
  }

  init({Branch? branch}) {
    if (branch != null) {
      branchNameController.text = branch.branchName!;
      addressController.text = branch.address!;
      cityController.text = branch.city!;
      phoneNumberController.text = branch.phoneNumber!;
      isActive = branch.status == "active";
    }
  }

  void submitBranch() async {
    if (addBranchFormKey.currentState?.validate() ?? false) {
      // Form is valid, prepare payload
      final payload = {
        "branch_name": branchNameController.text.trim(),
        "address": addressController.text.trim(),
        "city": cityController.text.trim(),
        "phone_number": phoneNumberController.text.trim(),
        "status": isActive ? "active" : "inactive",
      };
      setBusyForObject("addBranchLoader", true);
      try {
        ApiResponse response = await userApi.createBranch(payload);
        if (response.ok) {
          clearAllFields();
          setBusyForObject("addBranchLoader", false);

          appService.controller.add(NavigationItem("", "/branches", "pop"));

          // Notify listeners to reload using shared controller
          appService.branchReloadController.add(true);
          debugPrint("Branch reload event emitted after create");

          appService.showMessage(
            title: "Success",
            message: "Branch successfully created",
          );
          // ignore: use_build_context_synchronously
          Navigator.of(Utils.sideMenuNavigationKey.currentState!.context).pop();
        }
      } on DioException catch (e) {
        setBusyForObject("addBranchLoader", false);
        ApiResponse errorResponse = ApiResponse.parse(e.response);

        appService.showMessage(message: errorResponse.message);
      }

      debugPrint("Branch payload: $payload");
    }
  }

  void updateBranch(id) async {
    if (addBranchFormKey.currentState?.validate() ?? false) {
      // Form is valid, prepare payload
      final payload = {
        "branch_name": branchNameController.text.trim(),
        "address": addressController.text.trim(),
        "city": cityController.text.trim(),
        "phone_number": phoneNumberController.text.trim(),
        "status": isActive ? "active" : "inactive",
      };
      setBusyForObject("addBranchLoader", true);
      try {
        ApiResponse response = await userApi.updateBranch(id, payload);
        if (response.ok) {
          clearAllFields();
          setBusyForObject("addBranchLoader", false);

          // Notify listeners to reload using shared controller
          appService.branchReloadController.add(true);
          debugPrint("Branch reload event emitted after update");

          appService.showMessage(
            title: "Success",
            message: "Branch successfully updated",
          );
        }
      } on DioException catch (e) {
        setBusyForObject("addBranchLoader", false);
        ApiResponse errorResponse = ApiResponse.parse(e.response);

        appService.showMessage(message: errorResponse.message);
      }

      debugPrint("Branch payload: $payload");
    }
  }

  getBranches() async {
    try {
      setBusyForObject("loading", true);
      ApiResponse response = await userApi.getBranch();
      if (response.ok) {
        debugPrint("branch data : ${response.data}");
        setBusyForObject("loading", false);

        branches = (response.data as List)
            .map((e) => Branch.fromJson(e))
            .toList();
        rebuildUi();
      }
    } on DioException catch (e) {
      setBusyForObject("loading", false);
      debugPrint("error : ${e.response}");
      ApiResponse errorResponse = ApiResponse.parse(e.response);

      appService.showMessage(message: errorResponse.message);
    }
  }

  void clearAllFields() {
    addBranchFormKey.currentState?.reset();
    branchNameController.clear();
    addressController.clear();
    cityController.clear();
    phoneNumberController.clear();
    isActive = true;
    notifyListeners();
  }

  @override
  void dispose() {
    branchNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }
}
