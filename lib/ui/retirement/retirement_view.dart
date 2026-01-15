import 'package:flutter/material.dart';
import 'package:leave_desk/shared/loading.dart';
import 'package:leave_desk/shared/page_title.dart';
import 'package:leave_desk/ui/retirement/retirement_view_model.dart';
import 'package:stacked/stacked.dart';

class RetirementView extends StackedView<RetirementViewModel> {
  const RetirementView({Key? key}) : super(key: key);

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => true;

  @override
  void onViewModelReady(RetirementViewModel viewModel) async {
    viewModel.getBranches();

    // Listen to reload stream from shared controller
    viewModel.appService.branchReloadController.stream.listen((_) {
      debugPrint("Reload event received - Getting branches");
      viewModel.getBranches();
    });

    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 35),
      child: viewModel.busy("loading")
          ? Center(child: Loading(title: "Fetching Users"))
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
                          child: PageTitle(name: "Registered Staff"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  @override
  RetirementViewModel viewModelBuilder(BuildContext context) =>
      RetirementViewModel();
}
