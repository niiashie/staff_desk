import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/models/navigation_item.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/list_container.dart';
import 'package:leave_desk/shared/loading.dart';
import 'package:leave_desk/shared/page_title.dart';
import 'package:leave_desk/shared/table_text.dart';
import 'package:leave_desk/shared/table_title.dart';
import 'package:leave_desk/ui/role/widget/add_role_view.dart';
import 'package:leave_desk/ui/role/role_view_nodel.dart';
import 'package:leave_desk/utils.dart';
import 'package:stacked/stacked.dart';

class RoleView extends StackedView<RoleViewNodel> {
  const RoleView({Key? key}) : super(key: key);

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => true;

  @override
  void onViewModelReady(RoleViewNodel viewModel) async {
    viewModel.getRoles();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 35),
      child: viewModel.busy("loading")
          ? Center(child: Loading(title: "Fetching Roles"))
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
                          child: PageTitle(name: "Registered Roles"),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: CustomButton(
                            width: 130,
                            color: AppColors.primaryColor,
                            elevation: 2,
                            height: 40,
                            ontap: () {
                              viewModel.appService.controller.add(
                                NavigationItem("Add Role", "/addRole", "sub"),
                              );
                              Navigator.of(
                                Utils.sideMenuNavigationKey.currentContext!,
                              ).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return AddRoleView();
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
                                  'Create Role',
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
                              flex: 3,
                              child: TableTitle(name: "Name", leftPadding: 10),
                            ),
                            Flexible(flex: 1, child: TableTitle(name: "Level")),
                            Flexible(
                              flex: 3,
                              child: TableTitle(name: "Description"),
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
                    itemCount: viewModel.roles.length,
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
                              flex: 3,
                              child: TableText(
                                leftPadding: 10,
                                name: Utils().toTitleCase(
                                  viewModel.roles[index].name!,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: TableText(
                                name: viewModel.roles[index].level.toString(),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: TableText(
                                name: viewModel.roles[index].description!,
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: TableText(
                                leftPadding: 10,
                                name: Utils().toTitleCase(
                                  viewModel.roles[index].status!,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: SizedBox(
                                child: Center(
                                  child: CustomButton(
                                    width: 30,
                                    height: 30,
                                    elevation: 2,
                                    borderRadius: 7,
                                    color: Colors.blueAccent,
                                    title: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 11,
                                    ),
                                    ontap: () {
                                      viewModel.appService.controller.add(
                                        NavigationItem(
                                          "Add Role",
                                          "/addRole",
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
                                            return AddRoleView(
                                              role: viewModel.roles[index],
                                            );
                                          },
                                        ),
                                      );
                                    },
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
  RoleViewNodel viewModelBuilder(BuildContext context) => RoleViewNodel();
}
