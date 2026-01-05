import 'dart:async';
import 'package:flutter/material.dart';
import 'package:leave_desk/models/branch.dart';
import 'package:leave_desk/models/user.dart';
import 'package:leave_desk/ui/base/base_screen_view_model.dart';

class StaffViewModel extends BaseScreenViewModel {
  List<User> users = [];
  List<Branch> branches = [];
  Branch? selectedBranch;
  int totalUserPages = 1, currentPage = 1;

  // Stream controller for reloading staff data
  final StreamController<bool> reloadController =
      StreamController<bool>.broadcast();

  fetchData() async {
    setBusyForObject("loading", true);
    await getUsers();
    Map<String, dynamic> userObject = await getUsers();

    users = userObject['users'];
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
    users = userObject['users'];

    setBusyForObject("loading", false);
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
