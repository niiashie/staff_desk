import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/models/branch.dart';
import 'package:leave_desk/models/navigation_item.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/list_container.dart';
import 'package:leave_desk/shared/loading.dart';
import 'package:leave_desk/shared/page_title.dart';
import 'package:leave_desk/shared/pagination.dart';
import 'package:leave_desk/shared/table_text.dart';
import 'package:leave_desk/shared/table_title.dart';
import 'package:leave_desk/ui/department/widget/add_department_view.dart';
import 'package:leave_desk/ui/leave/leave_request_view.dart';
import 'package:leave_desk/ui/staff/staff_view_model.dart';
import 'package:leave_desk/ui/staff/widget/assign_staff_department_view.dart';
import 'package:leave_desk/ui/staff/widget/assign_staff_view.dart';
import 'package:leave_desk/ui/staff/widget/staff_leave_info_view.dart';
import 'package:leave_desk/ui/staff/widget/view_staff_view.dart';
import 'package:leave_desk/utils.dart';
import 'package:stacked/stacked.dart';

class StaffView extends StackedView<StaffViewModel> {
  const StaffView({Key? key}) : super(key: key);

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => true;

  @override
  void onViewModelReady(StaffViewModel viewModel) async {
    viewModel.fetchData();

    // Listen to reload stream
    viewModel.reloadController.stream.listen((_) {
      viewModel.fetchData();
    });

    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    return Container(
      width: double.infinity,
      height: double.infinity,

      margin: const EdgeInsets.symmetric(horizontal: 35),
      child: viewModel.busy("loading")
          ? Center(child: Loading(title: "Fetching Staff"))
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: PageTitle(name: "Registered Users"),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 40,
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<Branch>(
                                    hint: Text('Filter by Branch'),
                                    value: viewModel.selectedBranch,
                                    items: [
                                      DropdownMenuItem<Branch>(
                                        value: null,
                                        child: Text(
                                          'All Branches',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      ...viewModel.branches.map((branch) {
                                        return DropdownMenuItem<Branch>(
                                          value: branch,
                                          child: Text(
                                            branch.branchName ?? '',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        );
                                      }),
                                    ],
                                    onChanged: (Branch? value) {
                                      viewModel.onBranchSelected(value);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              CustomButton(
                                width: 130,
                                color: AppColors.primaryColor,
                                elevation: 2,
                                height: 40,
                                ontap: () {
                                  viewModel.appService.controller.add(
                                    NavigationItem(
                                      "Add Department",
                                      "/addDepartment",
                                      "sub",
                                    ),
                                  );
                                  Navigator.of(
                                    Utils.sideMenuNavigationKey.currentContext!,
                                  ).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return AddDepartmentView();
                                      },
                                    ),
                                  );
                                },
                                title: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Create User',
                                      style: TextStyle(
                                        color: Colors.white,

                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            height: 0.5,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 2,
                              child: TableTitle(name: "Name", leftPadding: 10),
                            ),

                            Flexible(flex: 2, child: TableTitle(name: "Role")),
                            Flexible(
                              flex: 2,
                              child: TableTitle(name: "Branch"),
                            ),
                            Flexible(
                              flex: 1,
                              child: TableTitle(
                                leftPadding: 10,
                                name: "Status",
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: TableTitle(leftPadding: 10, name: "Data"),
                            ),
                            Flexible(
                              flex: 1,
                              child: TableTitle(
                                leftPadding: 10,
                                name: "Leave Days",
                              ),
                            ),
                            Flexible(flex: 1, child: SizedBox()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    itemCount: viewModel.users.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListContainer(
                        index: index,
                        showHiddenWidget:
                            viewModel.users[index]['showHiddenWidget'],
                        hiddenWidget: Container(
                          width: double.infinity,
                          height: 45,
                          color: index % 2 == 0
                              ? Colors.transparent
                              : Colors.white,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Staff Status : ",
                                  style: TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 15),
                                Container(
                                  height: 35,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[400]!,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DropdownButton<String>(
                                    value: viewModel.selectedStatus,
                                    underline: SizedBox(),
                                    hint: Text(
                                      "Select Status",
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                    items: ['pending', 'active', 'suspended']
                                        .map(
                                          (status) => DropdownMenuItem(
                                            value: status,
                                            child: Text(
                                              Utils().capitalizeFirstLetter(
                                                status,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      viewModel.setUserStatus(index, value);
                                      // Handle dropdown change
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                CustomButton(
                                  width: 100,
                                  color: Colors.blueAccent,
                                  height: 35,
                                  borderRadius: 10,
                                  elevation: 1,
                                  isLoading: viewModel.busy(
                                    "${index}statusBtn",
                                  ),
                                  title: Text(
                                    "Change",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  ontap: () {
                                    viewModel.triggerUpdateUserStatus(index);
                                  },
                                ),

                                const SizedBox(width: 15),
                              ],
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 2,
                              child: TableText(
                                leftPadding: 10,
                                name: Utils().toTitleCase(
                                  viewModel.users[index]['user'].name!,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: TableText(
                                name: Utils().capitalizeFirstLetter(
                                  viewModel.users[index]['user'].role!.name
                                      .toString(),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: TableText(
                                name:
                                    viewModel
                                        .users[index]['user']
                                        .branches!
                                        .isNotEmpty
                                    ? viewModel
                                              .users[index]['user']
                                              .branches![0]
                                              .branchName ??
                                          "N/A"
                                    : "N/A",
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: TableText(
                                leftPadding: 10,
                                name: Utils().toTitleCase(
                                  viewModel.users[index]['user'].status!,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: TableText(
                                leftPadding: 10,
                                name:
                                    "${viewModel.users[index]['user'].percentageCompleteness} %",
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: TableText(
                                leftPadding: 10,
                                name:
                                    viewModel.users[index]['user'].leave != null
                                    ? viewModel
                                          .users[index]['user']
                                          .leave!
                                          .daysLeft
                                          .toString()
                                    : "N/A",
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: SizedBox(
                                child: Center(
                                  child: PopupMenuButton<String>(
                                    icon: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(7),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.2,
                                            ),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.more_vert,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                    onSelected: (String value) {
                                      // Handle menu selection
                                      switch (value) {
                                        case 'view':
                                          viewModel.appService.controller.add(
                                            NavigationItem(
                                              "User Detail",
                                              "/viewUser",
                                              "sub",
                                            ),
                                          );

                                          Navigator.of(
                                            Utils
                                                .sideMenuNavigationKey
                                                .currentContext!,
                                          ).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return ViewStaffView(
                                                  user: viewModel
                                                      .users[index]['user'],
                                                );
                                              },
                                            ),
                                          );
                                          break;
                                        case 'change_status':
                                          viewModel.showHiddenWidget(index);
                                          break;
                                        case 'assign_branch':
                                          viewModel.appService.controller.add(
                                            NavigationItem(
                                              "Assign User",
                                              "/assignUserView",
                                              "sub",
                                            ),
                                          );

                                          Navigator.of(
                                            Utils
                                                .sideMenuNavigationKey
                                                .currentContext!,
                                          ).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return AssignStaffView(
                                                  user: viewModel
                                                      .users[index]['user'],
                                                  reloadController: viewModel
                                                      .reloadController,
                                                );
                                              },
                                            ),
                                          );
                                          break;

                                        case 'leave_history':
                                          viewModel.appService.controller.add(
                                            NavigationItem(
                                              "Staff Leave Info",
                                              "/leaveInfo",
                                              "sub",
                                            ),
                                          );

                                          Navigator.of(
                                            Utils
                                                .sideMenuNavigationKey
                                                .currentContext!,
                                          ).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return StaffLeaveInfoView(
                                                  user: viewModel
                                                      .users[index]['user'],
                                                  reloadController: viewModel
                                                      .reloadController,
                                                );
                                              },
                                            ),
                                          );
                                          break;
                                        case 'penalize':
                                          if (viewModel
                                                  .users[index]['user']
                                                  .leave !=
                                              null) {
                                            viewModel.appService.controller.add(
                                              NavigationItem(
                                                "Apply Leave",
                                                "/applyLeave",
                                                "sub",
                                              ),
                                            );
                                            Navigator.of(
                                              Utils
                                                  .sideMenuNavigationKey
                                                  .currentContext!,
                                            ).push(
                                              MaterialPageRoute(
                                                builder: (BuildContext context) {
                                                  return LeaveRequestView(
                                                    isPenalty: true,
                                                    selectedUser: viewModel
                                                        .users[index]['user'],
                                                  );
                                                },
                                              ),
                                            );
                                          } else {
                                            viewModel.appService.showMessage(
                                              title: "Specify Leave",
                                              message:
                                                  "Specify staff leave duration to proceed",
                                            );
                                          }

                                          break;

                                        case 'assign_department':
                                          viewModel.appService.controller.add(
                                            NavigationItem(
                                              "Assign Department",
                                              "/assignDepartmentView",
                                              "sub",
                                            ),
                                          );

                                          Navigator.of(
                                            Utils
                                                .sideMenuNavigationKey
                                                .currentContext!,
                                          ).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return AssignStaffDepartmentView(
                                                  user: viewModel
                                                      .users[index]['user'],
                                                  reloadController: viewModel
                                                      .reloadController,
                                                );
                                              },
                                            ),
                                          );
                                          break;
                                      }
                                    },
                                    itemBuilder: (BuildContext context) => [
                                      PopupMenuItem<String>(
                                        value: 'view',
                                        child: Row(
                                          children: [
                                            Icon(Icons.visibility, size: 18),
                                            SizedBox(width: 10),
                                            Text('View'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'assign_branch',
                                        child: Row(
                                          children: [
                                            Icon(Icons.business, size: 18),
                                            SizedBox(width: 10),
                                            Text('Assign Branch'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'penalize',
                                        child: Row(
                                          children: [
                                            Icon(Icons.gavel, size: 18),
                                            SizedBox(width: 10),
                                            Text('Penalize'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'change_status',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.admin_panel_settings,
                                              size: 18,
                                            ),
                                            SizedBox(width: 10),
                                            Text('Change Status'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'leave_history',
                                        child: Row(
                                          children: [
                                            Icon(Icons.work_outline, size: 18),
                                            SizedBox(width: 10),
                                            Text('Work Leave'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'assign_department',
                                        child: Row(
                                          children: [
                                            Icon(Icons.group_work, size: 18),
                                            SizedBox(width: 10),
                                            Text('Assign Department'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  Pagination(
                    currentPage: viewModel.currentPage,
                    totalPages: viewModel.totalUserPages,
                    onPageChanged: (int p1) {
                      viewModel.onPageChanged(p1);
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  @override
  StaffViewModel viewModelBuilder(BuildContext context) => StaffViewModel();
}
