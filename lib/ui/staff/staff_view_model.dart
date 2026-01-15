import 'dart:async';
import 'package:flutter/material.dart';
import 'package:leave_desk/models/branch.dart';
import 'package:leave_desk/models/user.dart';
import 'package:leave_desk/ui/base/base_screen_view_model.dart';

class StaffViewModel extends BaseScreenViewModel {
  List<Map<String, dynamic>> users = [];
  List<Branch> branches = [];
  Branch? selectedBranch;
  String? selectedStatus;
  int totalUserPages = 1, currentPage = 1;

  // Stream controller for reloading staff data
  final StreamController<bool> reloadController =
      StreamController<bool>.broadcast();

  fetchData() async {
    setBusyForObject("loading", true);
    await getUsers();
    Map<String, dynamic> userObject = await getUsers();

    users = (userObject['users'] as List)
        .map<Map<String, dynamic>>(
          (e) => {"user": e, "showHiddenWidget": false},
        )
        .toList();
    debugPrint("previous work places : ${users[0]}");
    totalUserPages = userObject['totalPages'];
    branches = await getBranches();
    setBusyForObject("loading", false);
  }

  onPageChanged(page) async {
    currentPage = page;
    users.clear();
    setBusyForObject("loading", true);
    Map<String, dynamic> userObject = await getUsers(page: page);
    users = (userObject['users'] as List)
        .map<Map<String, dynamic>>(
          (e) => {"user": e, "showHiddenWidget": false},
        )
        .toList();

    setBusyForObject("loading", false);
  }

  showHiddenWidget(index) {
    selectedStatus = null;
    for (var user in users) {
      user['showHiddenWidget'] = false;
    }
    users[index]['showHiddenWidget'] = true;
    rebuildUi();
  }

  setUserStatus(index, value) async {
    //await updateUserStatus(user.id!, value);
    selectedStatus = value;
    notifyListeners();
  }

  triggerUpdateUserStatus(index) async {
    User user = users[index]['user'];
    if (selectedStatus == null) {
      appService.showMessage(
        title: "Status Required",
        message: "Please select new status of user to proceed",
      );
    } else {
      setBusyForObject("${index}statusBtn", true);
      await updateUserStatus(user.id.toString(), selectedStatus!.toString());
      setBusyForObject("${index}statusBtn", false);
      fetchData();
    }
  }

  void onBranchSelected(Branch? branch) {
    selectedBranch = branch;
    notifyListeners();
    // Add filtering logic here if needed
  }

  @override
  void dispose() {
    reloadController.close();
    super.dispose();
  }
}
