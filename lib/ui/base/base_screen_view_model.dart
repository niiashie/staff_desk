import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/constants/images.dart';
import 'package:leave_desk/models/navigation_item.dart';
import 'package:leave_desk/services/app_service.dart';
import 'package:leave_desk/utils.dart';
import 'package:stacked/stacked.dart' show BaseViewModel;

class BaseScreenViewModel extends BaseViewModel {
  List<String> labels = [
    "Dashboard",
    "Staff",
    "Leave",
    "Branches",
    "Roles",
    "Departments",
    "Retirement",
  ];
  List<String> icons = [
    AppImages.dashboard,
    AppImages.staff,
    AppImages.leave,
    AppImages.branch,
    AppImages.roles,
    AppImages.department,
    AppImages.retire,
  ];
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
}
