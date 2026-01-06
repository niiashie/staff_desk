import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/models/navigation_item.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/list_container.dart';
import 'package:leave_desk/shared/loading.dart';
import 'package:leave_desk/shared/page_title.dart';
import 'package:leave_desk/shared/pagination.dart';
import 'package:leave_desk/shared/table_text.dart';
import 'package:leave_desk/shared/table_title.dart';
import 'package:leave_desk/ui/leave/leave_details_view.dart';
import 'package:leave_desk/ui/leave/leave_request_view.dart';
import 'package:leave_desk/ui/leave/leave_view_model.dart';
import 'package:leave_desk/utils.dart';
import 'package:stacked/stacked.dart';

class LeaveView extends StackedView<LeaveViewModel> {
  const LeaveView({Key? key}) : super(key: key);

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => true;

  @override
  void onViewModelReady(LeaveViewModel viewModel) async {
    // Listen to reload stream from shared controller
    viewModel.appService.leaveReloadController.stream.listen((_) {
      debugPrint("Reload event received - Getting leave requests");
      viewModel.fetchLeaveData();
    });

    viewModel.fetchLeaveData();

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
                          child: PageTitle(name: "Leave Requests"),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: CustomButton(
                            width: 170,
                            color: AppColors.primaryColor,
                            elevation: 2,
                            height: 40,
                            ontap: () {
                              if (viewModel.appService.currentUser!.leave !=
                                  null) {
                                viewModel.appService.controller.add(
                                  NavigationItem(
                                    "Apply Leave",
                                    "/applyLeave",
                                    "sub",
                                  ),
                                );
                                Navigator.of(
                                  Utils.sideMenuNavigationKey.currentContext!,
                                ).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return LeaveRequestView();
                                    },
                                  ),
                                );
                              } else {
                                viewModel.appService.showMessage(
                                  title: "Leave Days Required",
                                  message:
                                      "Your number of leave days is not specified, contact administrator for your leave days to be specified",
                                );
                              }
                            },
                            title: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 15),
                                SizedBox(width: 8),
                                Text(
                                  'Apply Leave',
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
                              child: TableTitle(
                                name: "Start Date",
                                leftPadding: 10,
                              ),
                            ),
                            Flexible(flex: 1, child: TableTitle(name: "Days")),
                            Flexible(
                              flex: 2,
                              child: TableTitle(name: "End Date"),
                            ),
                            Flexible(
                              flex: 2,
                              child: TableTitle(name: "Description"),
                            ),
                            Flexible(
                              flex: 2,
                              child: TableTitle(
                                leftPadding: 10,
                                name: "Approver",
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: TableTitle(
                                leftPadding: 10,
                                name: "Status",
                              ),
                            ),

                            Flexible(flex: 2, child: SizedBox()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    itemCount: viewModel.leaveRequests.length,
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
                                name: DateFormat('d, MMMM, y').format(
                                  DateTime.parse(
                                    viewModel.leaveRequests[index].startDate!,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: TableText(
                                name: viewModel
                                    .leaveRequests[index]
                                    .numberOfDays
                                    .toString(),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: TableText(
                                name: DateFormat('d, MMMM, y').format(
                                  DateTime.parse(
                                    viewModel.leaveRequests[index].endDate!,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: TableText(
                                leftPadding: 5,
                                name:
                                    viewModel.leaveRequests[index].description!,
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: TableText(
                                leftPadding: 10,
                                name:
                                    viewModel.leaveRequests[index].approver !=
                                        null
                                    ? viewModel
                                          .leaveRequests[index]
                                          .approver!
                                          .name!
                                    : "N/A",
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color:
                                      viewModel.leaveRequests[index].status ==
                                          "pending"
                                      ? Colors.redAccent
                                      : viewModel.leaveRequests[index].status ==
                                            "rejected"
                                      ? Colors.red
                                      : Colors.green,
                                ),
                                child: Text(
                                  viewModel.leaveRequests[index].status!
                                      .toUpperCase(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
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
                                        case 'view_details':
                                          viewModel.appService.controller.add(
                                            NavigationItem(
                                              "Details",
                                              "/leaveDetail",
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
                                                return LeaveDetailView(
                                                  leaveRequest: viewModel
                                                      .leaveRequests[index],
                                                );
                                              },
                                            ),
                                          );
                                          break;
                                      }
                                    },
                                    itemBuilder: (BuildContext context) => [
                                      PopupMenuItem<String>(
                                        value: 'view_details',
                                        child: Row(
                                          children: [
                                            Icon(Icons.person, size: 18),
                                            SizedBox(width: 10),
                                            Text('View Details'),
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
                ],
              ),
            ),
    );
  }

  @override
  LeaveViewModel viewModelBuilder(BuildContext context) => LeaveViewModel();
}
