import 'package:flutter/material.dart';
import 'package:leave_desk/ui/department/department_view_model.dart';
import 'package:stacked/stacked.dart';

class DepartmentView extends StackedView<DepartmentViewModel> {
  const DepartmentView({Key? key}) : super(key: key);

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => true;

  @override
  void onViewModelReady(DepartmentViewModel viewModel) async {
    //viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.green,
      margin: const EdgeInsets.symmetric(horizontal: 25),
    );
  }

  @override
  DepartmentViewModel viewModelBuilder(BuildContext context) =>
      DepartmentViewModel();
}
