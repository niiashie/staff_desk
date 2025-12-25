import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/models/navigation_item.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/list_container.dart';
import 'package:leave_desk/shared/loading.dart';
import 'package:leave_desk/shared/page_title.dart';
import 'package:leave_desk/shared/table_text.dart';
import 'package:leave_desk/shared/table_title.dart';
import 'package:leave_desk/ui/branch/branch_view_model.dart';
import 'package:leave_desk/ui/branch/widget/add_branch_view.dart';
import 'package:leave_desk/utils.dart';
import 'package:stacked/stacked.dart';

class BranchView extends StackedView<BranchViewModel> {
  const BranchView({Key? key}) : super(key: key);

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => true;

  @override
  void onViewModelReady(BranchViewModel viewModel) async {
    viewModel.getBranches();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 35),
      child: viewModel.busy("loading")
          ? Center(child: Loading(title: "Fetching Branches"))
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
                          child: PageTitle(name: "Registered Branches"),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: CustomButton(
                            width: 140,
                            color: AppColors.primaryColor,
                            elevation: 2,
                            height: 40,
                            ontap: () {
                              viewModel.appService.controller.add(
                                NavigationItem(
                                  "Add Branch",
                                  "/addBranch",
                                  "sub",
                                ),
                              );
                              Navigator.of(
                                Utils.sideMenuNavigationKey.currentContext!,
                              ).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return AddBranchView();
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
                                  'Create Branch',
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
                            Flexible(
                              flex: 2,
                              child: TableTitle(name: "Address"),
                            ),
                            Flexible(flex: 2, child: TableTitle(name: "City")),
                            Flexible(flex: 2, child: TableTitle(name: "Phone")),
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
                    itemCount: viewModel.branches.length,
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
                                  viewModel.branches[index].branchName!,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: TableText(
                                name: viewModel.branches[index].address!,
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: TableText(
                                name: viewModel.branches[index].city!,
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: TableText(
                                name: viewModel.branches[index].phoneNumber!,
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: TableText(
                                leftPadding: 10,
                                name: Utils().toTitleCase(
                                  viewModel.branches[index].status!,
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
                                          "Add Branch",
                                          "/addBranch",
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
                                            return AddBranchView(
                                              branch: viewModel.branches[index],
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
  BranchViewModel viewModelBuilder(BuildContext context) => BranchViewModel();
}
