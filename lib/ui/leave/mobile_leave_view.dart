import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/models/navigation_item.dart';
import 'package:leave_desk/shared/loading.dart';
import 'package:leave_desk/ui/leave/leave_details_view.dart';
import 'package:leave_desk/ui/leave/leave_request_view.dart';
import 'package:leave_desk/ui/leave/leave_view_model.dart';
import 'package:leave_desk/utils.dart';
import 'package:stacked/stacked.dart';

class MobileLeaveView extends StackedView<LeaveViewModel> {
  const MobileLeaveView({super.key});

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => true;

  @override
  void onViewModelReady(LeaveViewModel viewModel) async {
    // Listen to reload stream from shared controller
    viewModel.appService.leaveReloadController.stream.listen((_) {
      debugPrint("Reload event received - Getting leave requests");
      viewModel.currentPage = 1;
      viewModel.hasMoreData = true;
      viewModel.fetchLeaveData();
    });

    viewModel.fetchLeaveData();

    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.baseColor,
      body: viewModel.busy("loading")
          ? Center(child: Loading(title: "Loading"))
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    !viewModel.isLoadingMore &&
                    viewModel.hasMoreData) {
                  viewModel.loadMoreLeaveData();
                }
                return false;
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Leave Requests",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
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
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text("Apply"),
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
                          final leave = viewModel.leaveRequests[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: () {
                                viewModel.appService.controller.add(
                                  NavigationItem(
                                    "Details",
                                    "/leaveDetail",
                                    "sub",
                                  ),
                                );
                                Navigator.of(
                                  Utils.sideMenuNavigationKey.currentContext!,
                                ).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return LeaveDetailView(
                                        leaveRequest: leave,
                                      );
                                    },
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
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
                                          child: Text(
                                            leave.description ?? "N/A",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: _getStatusColor(
                                              leave.status ?? "",
                                            ),
                                          ),
                                          child: Text(
                                            (leave.status ?? "N/A")
                                                .toUpperCase(),
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
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "${DateFormat('d MMM, y').format(DateTime.parse(leave.startDate!))} - ${DateFormat('d MMM, y').format(DateTime.parse(leave.endDate!))}",
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "${leave.numberOfDays} ${leave.numberOfDays == 1 ? 'Day' : 'Days'}",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (leave.approver != null) ...[
                                      const SizedBox(height: 8),
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
                                              "Approver: ${leave.approver?.name ?? 'N/A'}",
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: viewModel.leaveRequests.length,
                      ),
                    ),
                  ),
                  if (viewModel.isLoadingMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  if (!viewModel.hasMoreData &&
                      viewModel.leaveRequests.isNotEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            "No more leave requests",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (viewModel.leaveRequests.isEmpty &&
                      !viewModel.busy("loading"))
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "No leave requests found",
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
            ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.redAccent;
      case 'rejected':
        return Colors.red;
      case 'confirmed':
        return Colors.amber[700]!;
      case 'approved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  LeaveViewModel viewModelBuilder(BuildContext context) => LeaveViewModel();
}
