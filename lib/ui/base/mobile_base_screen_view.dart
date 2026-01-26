import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/constants/images.dart';
import 'package:leave_desk/models/navigation_item.dart';
import 'package:leave_desk/models/user.dart';
import 'package:leave_desk/services/app_service.dart';
import 'package:leave_desk/ui/auth/login_view.dart';
import 'package:leave_desk/ui/base/base_screen_view_model.dart';
import 'package:leave_desk/ui/branch/branch_view.dart';
import 'package:leave_desk/ui/branch/widget/add_branch_view.dart';
import 'package:leave_desk/ui/dashboard/dashboard_view.dart';
import 'package:leave_desk/ui/dashboard/widget/edit_staff_info_view.dart';
import 'package:leave_desk/ui/department/mobile_department_view.dart';
import 'package:leave_desk/ui/department/widget/add_department_view.dart';
import 'package:leave_desk/ui/department/widget/assign_department_manager.dart';
import 'package:leave_desk/ui/department/widget/department_members.dart';
import 'package:leave_desk/ui/leave/leave_details_view.dart';
import 'package:leave_desk/ui/leave/leave_request_view.dart';
import 'package:leave_desk/ui/leave/mobile_leave_view.dart';
import 'package:leave_desk/ui/retirement/retirement_view.dart';
import 'package:leave_desk/ui/role/widget/add_role_view.dart';
import 'package:leave_desk/ui/role/role_view.dart';
import 'package:leave_desk/ui/staff/staff_view.dart';
import 'package:leave_desk/ui/staff/widget/assign_staff_department_view.dart';
import 'package:leave_desk/ui/staff/widget/assign_staff_view.dart';
import 'package:leave_desk/ui/staff/widget/staff_leave_info_view.dart';
import 'package:leave_desk/ui/staff/widget/view_staff_view.dart';
import 'package:leave_desk/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class MobileBaseScreenView extends StatefulWidget {
  const MobileBaseScreenView({super.key});

  @override
  State<MobileBaseScreenView> createState() => _MobileBaseScreenViewState();
}

class _MobileBaseScreenViewState extends State<MobileBaseScreenView> {
  var appService = locator<AppService>();
  StreamSubscription<NavigationItem>? streamSubscription;
  List<NavigationItem> menuItems = [];
  bool showBackButton = false;
  late BaseScreenViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = BaseScreenViewModel();
    viewModel.init();

    // Initialize selected branch to the first branch if available
    if (appService.currentUser?.branches != null &&
        appService.currentUser!.branches!.isNotEmpty) {
      appService.setSelectedBranch(appService.currentUser!.branches![0]);
    }

    // Listen to navigation changes
    listenToBreadCrumbMenuItemChange();

    // Add initial route
    if (appService.currentUser!.role!.name!.contains("admin")) {
      appService.controller.add(NavigationItem("Staff", "/staff", "main"));
    } else {
      appService.controller
          .add(NavigationItem("Dashboard", "/dashboard", "main"));
    }
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  void listenToBreadCrumbMenuItemChange() {
    streamSubscription = appService.controller.stream.listen((value) {
      if (value.type == 'sub') {
        menuItems.add(value);
        showBackButton = true;
      } else if (value.type == "pop") {
        final index = int.tryParse(value.route ?? '');
        if (index != null) {
          removeMenuItemsUntilIndex(index);
        } else {
          if (menuItems.length > 1) {
            menuItems.removeLast();
          }
        }
        showBackButton = menuItems.length > 1;
      } else {
        menuItems.clear();
        menuItems.add(value);
        showBackButton = false;
      }
      if (mounted) setState(() {});
    });
  }

  void removeMenuItemsUntilIndex(int index) {
    while (menuItems.length > index + 1) {
      menuItems.removeLast();
    }
  }

  void handleBackPress() {
    if (menuItems.length > 1) {
      Utils.sideMenuNavigationKey.currentState?.pop();
      menuItems.removeLast();
      showBackButton = menuItems.length > 1;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BaseScreenViewModel>.reactive(
      viewModelBuilder: () => viewModel,
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 2,
          leading: showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: handleBackPress,
                )
              : null,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!showBackButton) ...[
                Image.asset(AppImages.logo, width: 35, height: 35),
                const SizedBox(width: 12),
              ],
              Text(
                menuItems.isNotEmpty
                    ? menuItems.last.name ?? "Staff Desk"
                    : "Staff Desk",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            // Branch Selector
            if (model.appService.currentUser?.branches != null &&
                model.appService.currentUser!.branches!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Center(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      hint: const Text(
                        'Branch',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      value: model.appService.selectedBranch?.id ??
                          model.appService.currentUser!.branches![0].id,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      dropdownColor: AppColors.primaryColor,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      items:
                          model.appService.currentUser!.branches!.map((branch) {
                        return DropdownMenuItem<int>(
                          value: branch.id,
                          child: Text(
                            branch.branchName ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (int? value) {
                        if (value != null) {
                          final selectedBranch = model
                              .appService.currentUser!.branches!
                              .firstWhere((b) => b.id == value);
                          model.appService.setSelectedBranch(selectedBranch);
                          model.rebuildUi();
                        }
                      },
                    ),
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {},
            ),
            PopupMenuButton(
              icon: const Icon(Icons.person_outline, color: Colors.white),
              offset: const Offset(0.0, 50),
              onSelected: (value) async {
                if (value == "logout") {
                  DialogResponse? response =
                      await model.appService.confirmAction(
                    title: "Logout",
                    message: "Do you really want to logout",
                    okayText: "Yes",
                    cancelText: "No",
                  );

                  if (response != null && response.confirmed) {
                    model.appService.currentUser = null;

                    Navigator.pushReplacement(
                      StackedService.navigatorKey!.currentContext!,
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                    );
                  }
                } else if (value == "password") {
                  model.appService.showMessage(
                    title: "Pending",
                    message: "Feature to be released soon",
                  );
                }
              },
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  enabled: false,
                  child: Container(
                    width: 150,
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.appService.currentUser?.name ?? "User",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          model.appService.currentUser?.role?.name ?? "Staff",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: "password",
                  height: 45,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock,
                          color: Colors.grey[700],
                          size: 14,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Change Password",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: "logout",
                  height: 45,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.grey[700],
                          size: 17,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.baseColor,
          child: Navigator(
            key: Utils.sideMenuNavigationKey,
            initialRoute: model.appService.currentUser!.role!.name!
                    .contains("admin")
                ? '/staff'
                : '/dashboard',
            onGenerateRoute: ((settings) {
              Widget page;
              switch (settings.name) {
                case '/dashboard':
                  page = const DashboardView();
                  break;
                case '/staff':
                  page = const StaffView();
                  break;
                case '/roles':
                  page = const RoleView();
                  break;
                case '/retirement':
                  page = const RetirementView();
                  break;
                case '/departments':
                  page = const MobileDepartmentView();
                  break;
                case '/addRole':
                  page = const AddRoleView();
                  break;
                case '/addDepartment':
                  page = const AddDepartmentView();
                  break;
                case '/assignDepartment':
                  page = const AssignDepartmentManager();
                  break;
                case '/leaveInfo':
                  page = StaffLeaveInfoView(user: User());
                  break;
                case '/leave':
                  page = const MobileLeaveView();
                  break;
                case '/applyLeave':
                  page = LeaveRequestView();
                  break;
                case '/leaveDetail':
                  page = LeaveDetailView();
                  break;
                case '/departmentMembers':
                  page = DepartmentMembers();
                  break;
                case '/addBranch':
                  page = const AddBranchView();
                  break;
                case '/branches':
                  page = const BranchView();
                  break;
                case '/editStaff':
                  page = EditStaffInfoView();
                  break;
                case '/viewUser':
                  page = ViewStaffView(user: User());
                  break;
                case '/assignUserView':
                  page = AssignStaffView(user: User());
                  break;
                case '/assignDepartmentView':
                  page = AssignStaffDepartmentView(user: User());
                  break;
                default:
                  page = const StaffView();
                  break;
              }
              return Utils.slideRightTransition(page);
            }),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: model.selection,
          onTap: (index) {
            model.setSelection(index);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          elevation: 8,
          items: List.generate(
            model.labels.length,
            (index) => BottomNavigationBarItem(
              icon: SvgPicture.asset(
                model.icons[index],
                width: 22,
                height: 22,
                colorFilter: ColorFilter.mode(
                  model.selection == index
                      ? AppColors.primaryColor
                      : Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
              label: model.labels[index],
            ),
          ),
        ),
      ),
    );
  }
}
