import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/models/navigation_item.dart';
import 'package:leave_desk/shared/loading.dart';
import 'package:leave_desk/ui/department/department_view_model.dart';
import 'package:leave_desk/ui/department/widget/add_department_view.dart';
import 'package:leave_desk/ui/department/widget/assign_department_manager.dart';
import 'package:leave_desk/ui/department/widget/department_members.dart';
import 'package:leave_desk/utils.dart';
import 'package:stacked/stacked.dart';

class MobileDepartmentView extends StackedView<DepartmentViewModel> {
  const MobileDepartmentView({super.key});

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
    return Scaffold(
      backgroundColor: AppColors.baseColor,
      body: viewModel.busy("loading")
          ? Center(child: Loading(title: "Loading"))
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Departments",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        if (viewModel.appService.currentUser!.role!.name!
                            .contains("admin"))
                          ElevatedButton.icon(
                            onPressed: () {
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
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text("Create"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final department = viewModel.departments[index];
                        final isAdmin = viewModel.appService.currentUser!.role!
                            .name!
                            .contains("admin");

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            Utils().toTitleCase(
                                              department.name ?? "N/A",
                                            ),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryColor
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              department.code ?? "N/A",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: department.status == "active"
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                      child: Text(
                                        Utils().toTitleCase(
                                          department.status ?? "N/A",
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                if (department.description != null &&
                                    department.description!.isNotEmpty) ...[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.description,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          department.description!,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "Manager: ${department.managerId != null ? department.manager?.name ?? 'N/A' : 'Not Assigned'}",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          viewModel.appService.controller.add(
                                            NavigationItem(
                                              "Members",
                                              "/departmentMembers",
                                              "sub",
                                            ),
                                          );
                                          Navigator.of(
                                            Utils.sideMenuNavigationKey
                                                .currentContext!,
                                          ).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return DepartmentMembers(
                                                  department: department,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.group,
                                          size: 16,
                                        ),
                                        label: const Text(
                                          "Members",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              AppColors.primaryColor,
                                          side: BorderSide(
                                            color: AppColors.primaryColor,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (isAdmin) ...[
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            viewModel.appService.controller.add(
                                              NavigationItem(
                                                "Assign Manager",
                                                "/assignDepartment",
                                                "sub",
                                              ),
                                            );
                                            Navigator.of(
                                              Utils.sideMenuNavigationKey
                                                  .currentContext!,
                                            ).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) {
                                                  return AssignDepartmentManager(
                                                    department: department,
                                                    reloadController: viewModel
                                                        .appService
                                                        .departmentReloadController,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.person_add,
                                            size: 16,
                                          ),
                                          label: const Text(
                                            "Assign",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.primaryColor,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    if (isAdmin) ...[
                                      const SizedBox(width: 8),
                                      IconButton(
                                        onPressed: () {
                                          viewModel.appService.controller.add(
                                            NavigationItem(
                                              "Update Department",
                                              "/addDepartment",
                                              "sub",
                                            ),
                                          );
                                          Navigator.of(
                                            Utils.sideMenuNavigationKey
                                                .currentContext!,
                                          ).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return AddDepartmentView(
                                                  department: department,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.edit),
                                        color: Colors.blue,
                                        style: IconButton.styleFrom(
                                          backgroundColor:
                                              Colors.blue.withValues(alpha: 0.1),
                                          padding: const EdgeInsets.all(8),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: viewModel.departments.length,
                    ),
                  ),
                ),
                if (viewModel.departments.isEmpty &&
                    !viewModel.busy("loading"))
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.business_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "No departments found",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
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
  }

  @override
  DepartmentViewModel viewModelBuilder(BuildContext context) =>
      DepartmentViewModel();
}
