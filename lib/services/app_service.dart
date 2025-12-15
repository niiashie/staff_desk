import 'dart:async';

import 'package:leave_desk/app/dialog.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/models/user.dart';
import 'package:stacked_services/stacked_services.dart';

class AppService {
  StreamController<String> reloadController =
      StreamController<String>.broadcast();
  final DialogService dialogService = locator<DialogService>();
  User? currentUser;

  showMessage({String? title = "Whoops", String? message = ""}) {
    dialogService.showCustomDialog(
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
}
