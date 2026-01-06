import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/models/navigation_item.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/list_container.dart';
import 'package:leave_desk/shared/loading.dart';
import 'package:leave_desk/shared/page_title.dart';
import 'package:leave_desk/shared/table_text.dart';
import 'package:leave_desk/shared/table_title.dart';
import 'package:leave_desk/ui/department/department_view_model.dart';
import 'package:leave_desk/ui/department/widget/add_department_view.dart';
import 'package:leave_desk/ui/department/widget/assign_department_manager.dart';
import 'package:leave_desk/ui/department/widget/department_members.dart';
import 'package:leave_desk/utils.dart';
import 'package:stacked/stacked.dart';

class DepartmentView extends StackedView<DepartmentViewModel> {
  const DepartmentView({Key? key}) : super(key: key);

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => true;

  @override
  void onViewModelReady(DepartmentViewModel viewModel) async {
    viewModel.fetchDepartments();

    // Listen to reload stream from shared controller
    viewModel.appService.departmentReloadController.stream.listen((_) {
      debugPrint("Reload event received - Getting departments");
      viewModel.fetchDepartments();
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
          ? Center(child: Loading(title: "Loading"))
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: PageTitle(name: "Registered Department"),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: CustomButton(
                            width: 170,
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
                                Icon(Icons.add, color: Colors.white, size: 15),
                                SizedBox(width: 8),
                                Text(
                                  'Create Department',
                                  style: TextStyle(
                                    color: Colors.white,

                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
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
                            Flexible(flex: 1, child: TableTitle(name: "Code")),
                            Flexible(
                              flex: 3,
                              child: TableTitle(name: "Description"),
                            ),
                            Flexible(
                              flex: 2,
                              child: TableTitle(
                                leftPadding: 10,
                                name: "Manager",
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: TableTitle(
                                leftPadding: 10,
                                name: "Status",
                              ),
                            ),
                            Flexible(flex: 1, child: SizedBox()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    itemCount: viewModel.departments.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListContainer(
                        index: index,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 2,
                              child: TableText(
                                leftPadding: 10,
                                name: Utils().toTitleCase(
                                  viewModel.departments[index].name!,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: TableText(
                                name: viewModel.departments[index].code
                                    .toString(),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: TableText(
                                name: viewModel.departments[index].description!,
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: TableText(
                                leftPadding: 10,
                                name:
                                    viewModel.departments[index].managerId !=
                                        null
                                    ? viewModel
                                          .departments[index]
                                          .manager!
                                          .name!
                                    : "N/A",
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: TableText(
                                leftPadding: 10,
                                name: Utils().toTitleCase(
                                  viewModel.departments[index].status!,
                                ),
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
                                        case 'edit':
                                          viewModel.appService.controller.add(
                                            NavigationItem(
                                              "Update Department",
                                              "/addDepartment",
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
                                                return AddDepartmentView(
                                                  department: viewModel
                                                      .departments[index],
                                                );
                                              },
                                            ),
                                          );
                                          break;
                                        case 'assign_manager':
                                          viewModel.appService.controller.add(
                                            NavigationItem(
                                              "Assign Manager",
                                              "/assignDepartment",
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
                                                return AssignDepartmentManager(
                                                  department: viewModel
                                                      .departments[index],
                                                  reloadController: viewModel
                                                      .appService
                                                      .departmentReloadController,
                                                );
                                              },
                                            ),
                                          );
                                          break;
                                        case 'view_members':
                                          viewModel.appService.controller.add(
                                            NavigationItem(
                                              "Members",
                                              "/departmentMembers",
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
                                                return DepartmentMembers(
                                                  department: viewModel
                                                      .departments[index],
                                                );
                                              },
                                            ),
                                          );
                                          break;
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        viewModel
                                            .appService
                                            .currentUser!
                                            .role!
                                            .name!
                                            .contains("admin")
                                        ? [
                                            PopupMenuItem<String>(
                                              value: 'edit',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.edit, size: 18),
                                                  SizedBox(width: 10),
                                                  Text('Edit'),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem<String>(
                                              value: 'view_members',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.person, size: 18),
                                                  SizedBox(width: 10),
                                                  Text('View Members'),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem<String>(
                                              value: 'assign_manager',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.person_add,
                                                    size: 18,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text('Assign Manager'),
                                                ],
                                              ),
                                            ),
                                          ]
                                        : [
                                            PopupMenuItem<String>(
                                              value: 'view_members',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.person, size: 18),
                                                  SizedBox(width: 10),
                                                  Text('View Members'),
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
                ],
              ),
            ),
    );
  }

  @override
  DepartmentViewModel viewModelBuilder(BuildContext context) =>
      DepartmentViewModel();
}
