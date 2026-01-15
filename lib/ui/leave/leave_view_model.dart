import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leave_desk/api/user_api.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/models/api_response.dart';
import 'package:leave_desk/models/leave_request.dart';
import 'package:leave_desk/models/navigation_item.dart';
import 'package:leave_desk/ui/base/base_screen_view_model.dart';
import 'package:leave_desk/models/user.dart';
import 'package:leave_desk/utils.dart';
import 'package:stacked_services/stacked_services.dart';

class LeaveViewModel extends BaseScreenViewModel {
  final GlobalKey<FormState> leaveRequestFormKey = GlobalKey<FormState>();
  final navigationService = locator<NavigationService>();

  // Form controllers
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController numberOfDaysController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController handOverController = TextEditingController();

  // Selected values
  User? selectedHandOverUser;
  String? selectedLeaveType;
  UserApi userApi = UserApi();
  int currentPage = 1, totalUserPages = 1;

  // Available users (excluding current user)
  List<User> availableUsers = [];
  List<LeaveRequest> leaveRequests = [];

  @override
  void init() async {
    await fetchUser();
    await fetchLeaveData();
    notifyListeners();
  }

  onPageChanged(value) {
    fetchLeaveData(page: value);
    currentPage = value;
    rebuildUi();
  }

  fetchLeaveData({int? page = 1}) async {
    if (appService.currentUser!.role!.name!.contains("admin")) {
      await fetchLeaveRequests();
    } else {
      await fetchUserLeaveRequests();
    }
  }

  fetchUser() async {
    setBusyForObject("loading", true);
    try {
      ApiResponse response = await userApi.getUsers(
        branchId: appService.selectedBranch!.id.toString(),
      );
      if (response.ok) {
        availableUsers = (response.data as List)
            .map((e) => User.fromJson(e))
            .toList();
        setBusyForObject("loading", false);
      }
    } on DioException catch (e) {
      setBusyForObject("loading", false);
      ApiResponse errorResponse = ApiResponse.parse(e.response);
      appService.showMessage(message: errorResponse.message);
    }
  }

  fetchLeaveRequests({int? page = 1}) async {
    setBusyForObject("loading", true);
    try {
      ApiResponse response = await userApi.getLeaveRequests(page: 1);
      if (response.ok) {
        leaveRequests = (response.data as List)
            .map((e) => LeaveRequest.fromJson(e))
            .toList();
        totalUserPages = response.totalPages!;
        rebuildUi();
        setBusyForObject("loading", false);
      }
    } on DioException catch (e) {
      setBusyForObject("loading", false);
      debugPrint("error response : ${e.response}");
      ApiResponse errorResponse = ApiResponse.parse(e.response);
      appService.showMessage(message: errorResponse.message);
    }
  }

  fetchUserLeaveRequests({int? page = 1}) async {
    setBusyForObject("loading", true);
    try {
      ApiResponse response = await userApi.getUserLeaveRequests(
        appService.currentUser!.id.toString(),
        page: page,
      );
      if (response.ok) {
        debugPrint("response body : ${response.body}");
        leaveRequests = (response.data as List)
            .map((e) => LeaveRequest.fromJson(e))
            .toList();

        totalUserPages = response.totalPages!;
        setBusyForObject("loading", false);
      }
    } on DioException catch (e) {
      setBusyForObject("loading", false);
      debugPrint("error response : ${e.response}");
      ApiResponse errorResponse = ApiResponse.parse(e.response);
      appService.showMessage(message: errorResponse.message);
    }
  }

  void setHandOverUser(User? user) {
    selectedHandOverUser = user;
    handOverController.text = user!.name!;
    notifyListeners();
  }

  void setLeaveType(String? type) {
    selectedLeaveType = type;
    descriptionController.text = Utils().capitalizeFirstLetter(type!);
    notifyListeners();
  }

  Future<void> submitLeaveRequest({bool isPenalty = false, User? user}) async {
    if (!leaveRequestFormKey.currentState!.validate()) {
      return;
    }

    if (selectedLeaveType == null) {
      appService.showMessage(message: 'Please select leave type');
      return;
    }

    setBusyForObject("submitLeaveLoader", true);

    try {
      final requestData = {
        'user_id': isPenalty ? user!.id : appService.currentUser!.id,
        //'hand_over_id': selectedHandOverUser!.id,
        'description': selectedLeaveType,
        'number_of_days': int.parse(numberOfDaysController.text),
        'start_date': startDateController.text,
        'end_date': endDateController.text,
      };

      if (selectedHandOverUser != null) {
        requestData['hand_over_id'] = selectedHandOverUser!.id;
      }

      debugPrint('Leave request data: $requestData');
      ApiResponse response = await userApi.requestLeave(requestData);

      if (response.ok) {
        appService.leaveReloadController.add(true);
      }

      appService.showMessage(
        title: "Success",
        message: 'Leave request submitted successfully',
      );
      clearForm();
    } on DioException catch (e) {
      debugPrint("error : ${e.response}");
      appService.showMessage(message: e.response!.data['message']);
    } finally {
      setBusyForObject("submitLeaveLoader", false);
    }
  }

  void clearForm() {
    descriptionController.clear();
    numberOfDaysController.clear();
    startDateController.clear();
    endDateController.clear();
    selectedHandOverUser = null;
    selectedLeaveType = null;
    notifyListeners();
  }

  Future<void> onApproveLeave(LeaveRequest leave) async {
    final response = await appService.confirmAction(
      title: 'Approve Leave',
      message: 'Are you sure you want to approve this leave request?',
      okayText: 'Approve',
      cancelText: 'Cancel',
    );

    if (response?.confirmed ?? false) {
      final requestData = {
        "status": "approved",
        "approver_id": appService.currentUser!.id,
      };

      setBusyForObject("approveLeaveLoader", true);
      try {
        ApiResponse apiResponse = await userApi.updateLeaveRequest(
          leave.id!,
          requestData,
        );
        if (apiResponse.ok) {
          appService.showMessage(
            title: "Success",
            message: 'Leave request approved successfully',
          );
          appService.leaveReloadController.add(true);
          appService.controller.add(NavigationItem("", "/leave", "pop"));
          Navigator.of(Utils.sideMenuNavigationKey.currentState!.context).pop();
        }
      } on DioException catch (e) {
        debugPrint("error : ${e.response}");
        ApiResponse errorResponse = ApiResponse.parse(e.response);
        appService.showMessage(message: errorResponse.message);
      } finally {
        setBusyForObject("approveLeaveLoader", false);
      }
    }
  }

  Future<void> onRejectLeave(LeaveRequest leave) async {
    final response = await appService.confirmAction(
      title: 'Reject Leave',
      message: 'Are you sure you want to reject this leave request?',
      okayText: 'Reject',
      cancelText: 'Cancel',
    );

    if (response?.confirmed ?? false) {
      setBusyForObject("rejectLeaveLoader", true);

      final requestData = {
        "status": "rejected",
        "approver_id": appService.currentUser!.id,
      };

      try {
        ApiResponse apiResponse = await userApi.updateLeaveRequest(
          leave.id!,
          requestData,
        );
        if (apiResponse.ok) {
          appService.showMessage(
            title: "Success",
            message: 'Leave request rejected successfully',
          );
          appService.leaveReloadController.add(true);
          appService.controller.add(NavigationItem("", "/leave", "pop"));
          Navigator.of(Utils.sideMenuNavigationKey.currentState!.context).pop();
        }
      } on DioException catch (e) {
        debugPrint("error : ${e.response}");
        ApiResponse errorResponse = ApiResponse.parse(e.response);
        appService.showMessage(message: errorResponse.message);
      } finally {
        setBusyForObject("rejectLeaveLoader", false);
      }
    }
  }

  Future<void> onCancelLeave(int? leaveId) async {
    if (leaveId == null) return;

    final response = await appService.confirmAction(
      title: 'Cancel Leave',
      message: 'Are you sure you want to cancel this leave request?',
      okayText: 'Yes, Cancel',
      cancelText: 'No',
    );

    if (response?.confirmed ?? false) {
      setBusyForObject("cancelLeaveLoader", true);
      try {
        ApiResponse apiResponse = await userApi.cancelLeave(leaveId);
        if (apiResponse.ok) {
          appService.showMessage(
            title: "Success",
            message: 'Leave request cancelled successfully',
          );
          appService.leaveReloadController.add(true);
          appService.controller.add(NavigationItem("", "/leave", "pop"));
          Navigator.of(Utils.sideMenuNavigationKey.currentState!.context).pop();
        }
      } on DioException catch (e) {
        debugPrint("error : ${e.response}");
        ApiResponse errorResponse = ApiResponse.parse(e.response);
        appService.showMessage(message: errorResponse.message);
      } finally {
        setBusyForObject("cancelLeaveLoader", false);
      }
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    numberOfDaysController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }
}
