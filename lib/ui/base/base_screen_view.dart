import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/models/user.dart';
import 'package:leave_desk/ui/base/base_screen_view_model.dart';
import 'package:leave_desk/ui/base/widget/app_bar.dart';
import 'package:leave_desk/ui/base/widget/side_menu.dart';
import 'package:leave_desk/ui/branch/branch_view.dart';
import 'package:leave_desk/ui/branch/widget/add_branch_view.dart';
import 'package:leave_desk/ui/dashboard/dashboard_view.dart';
import 'package:leave_desk/ui/department/department_view.dart';
import 'package:leave_desk/ui/department/widget/add_department_view.dart';
import 'package:leave_desk/ui/department/widget/assign_department_manager.dart';
import 'package:leave_desk/ui/department/widget/department_members.dart';
import 'package:leave_desk/ui/role/widget/add_role_view.dart';
import 'package:leave_desk/ui/role/role_view.dart';
import 'package:leave_desk/ui/staff/staff_view.dart';
import 'package:leave_desk/ui/staff/widget/assign_staff_department_view.dart';
import 'package:leave_desk/ui/staff/widget/assign_staff_view.dart';
import 'package:leave_desk/ui/staff/widget/staff_leave_info_view.dart';
import 'package:leave_desk/ui/staff/widget/view_staff_view.dart';
import 'package:leave_desk/utils.dart';
import 'package:stacked/stacked.dart';

class BaseScreenView extends StackedView<BaseScreenViewModel> {
  const BaseScreenView({Key? key}) : super(key: key);

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => true;

  @override
  void onViewModelReady(BaseScreenViewModel viewModel) async {
    //viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: AppColors.baseColor),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SideMenu(
              labels: viewModel.labels,
              icons: viewModel.icons,
              selected: viewModel.selection,
              onSelected: (value, index) {
                viewModel.setSelection(index);
              },
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AppBarWidget(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        margin: const EdgeInsets.only(top: 3, left: 5),
                        color: AppColors.baseColor,
                        child: Navigator(
                          key: Utils.sideMenuNavigationKey,
                          initialRoute: '/dashboard',
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
                              case '/departments':
                                page = const DepartmentView();
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
                              case '/departmentMembers':
                                page = DepartmentMembers();
                                break;
                              case '/addBranch':
                                page = const AddBranchView();
                                break;
                              case '/branches':
                                page = const BranchView();
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
                                page = const DashboardView();
                                break;
                            }
                            return Utils.slideRightTransition(page);
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  BaseScreenViewModel viewModelBuilder(BuildContext context) =>
      BaseScreenViewModel();
}
