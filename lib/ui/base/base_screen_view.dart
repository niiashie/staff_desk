import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/ui/base/base_screen_view_model.dart';
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
            Container(
              width: 80,
              height: double.infinity,
              color: AppColors.primaryColor,
            ),
            Expanded(
              child: SizedBox(width: double.infinity, height: double.infinity),
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
