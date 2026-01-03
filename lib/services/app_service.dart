import 'dart:async';

import 'package:leave_desk/app/dialog.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/models/branch.dart';
import 'package:leave_desk/models/navigation_item.dart';
import 'package:leave_desk/models/user.dart';
import 'package:stacked_services/stacked_services.dart';

class AppService {
  StreamController<String> reloadController =
      StreamController<String>.broadcast();
  StreamController<NavigationItem> controller =
      StreamController<NavigationItem>.broadcast();
  StreamController<bool> branchReloadController =
      StreamController<bool>.broadcast();
  StreamController<bool> departmentReloadController =
      StreamController<bool>.broadcast();
  StreamController<Branch?> selectedBranchController =
      StreamController<Branch?>.broadcast();
  final DialogService dialogService = locator<DialogService>();
  User? currentUser;
  Branch? selectedBranch;

  Future<DialogResponse?> showMessage({
    String? title = "Whoops",
    String? message = "",
  }) async {
    return await dialogService.showCustomDialog(
      description: message,
      title: title,

      variant: DialogType.basic,
    );
  }

  Future<DialogResponse?> confirmAction({
    String? title = "",
    String? message = "",
    String? okayText = "Yes",
    String? cancelText = "No",
  }) async {
    DialogResponse? response = await dialogService.showCustomDialog(
      description: message,
      title: title,
      mainButtonTitle: okayText,
      secondaryButtonTitle: cancelText,
      barrierDismissible: false,
      variant: DialogType.confirmation,
    );
    return response;
  }

  displayError() {}

  void setSelectedBranch(Branch? branch) {
    selectedBranch = branch;
    selectedBranchController.add(branch);
  }
}
