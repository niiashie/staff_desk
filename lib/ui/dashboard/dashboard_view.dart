import 'package:flutter/material.dart';
import 'package:leave_desk/ui/dashboard/dashboard_view_model.dart';
import 'package:leave_desk/ui/dashboard/widget/staff_info_view.dart';
import 'package:stacked/stacked.dart';

class DashboardView extends StackedView<DashboardViewModel> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => true;

  @override
  void onViewModelReady(DashboardViewModel viewModel) async {
    //viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: viewModel.appService.currentUser!.role!.name!.contains("admin")
          ? SizedBox()
          : StaffInfoView(user: viewModel.appService.currentUser!),
    );
  }

  @override
  DashboardViewModel viewModelBuilder(BuildContext context) =>
      DashboardViewModel();
}
