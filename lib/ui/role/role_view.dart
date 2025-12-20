import 'package:flutter/material.dart';
import 'package:leave_desk/ui/role/role_view_nodel.dart';
import 'package:stacked/stacked.dart';

class RoleView extends StackedView<RoleViewNodel> {
  const RoleView({Key? key}) : super(key: key);

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => true;

  @override
  void onViewModelReady(RoleViewNodel viewModel) async {
    //viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.red,
      margin: const EdgeInsets.symmetric(horizontal: 25),
    );
  }

  @override
  RoleViewNodel viewModelBuilder(BuildContext context) => RoleViewNodel();
}
