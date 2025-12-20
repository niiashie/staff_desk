import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/ui/staff/staff_view_model.dart';
import 'package:stacked/stacked.dart';

class StaffView extends StackedView<StaffViewModel> {
  const StaffView({Key? key}) : super(key: key);

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => true;

  @override
  void onViewModelReady(StaffViewModel viewModel) async {
    //viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: AppColors.baseColor),
    );
  }

  @override
  StaffViewModel viewModelBuilder(BuildContext context) => StaffViewModel();
}
