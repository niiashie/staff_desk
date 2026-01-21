import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/shared/loading.dart';
import 'package:leave_desk/shared/page_title.dart';
import 'package:leave_desk/ui/retirement/retirement_view_model.dart';
import 'package:leave_desk/ui/retirement/widgets/age_category_card.dart';
import 'package:leave_desk/ui/retirement/widgets/summary_card.dart';
import 'package:stacked/stacked.dart';

class RetirementView extends StackedView<RetirementViewModel> {
  const RetirementView({Key? key}) : super(key: key);

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => true;

  @override
  void onViewModelReady(RetirementViewModel viewModel) async {
    viewModel.getUsersByAge();

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

                  // Summary Statistics
                  if (viewModel.ageCategoryData?.summary != null)
                    SummaryCard(summary: viewModel.ageCategoryData!.summary!),

                  const SizedBox(height: 25),

                  // Age Category Cards
                  if (viewModel.ageCategoryData != null) ...[
                    // Young Staff
                    if (viewModel.ageCategoryData!.youngStaff != null)
                      AgeCategoryCard(
                        category: viewModel.ageCategoryData!.youngStaff!,
                        title: "Young Staff",
                        subtitle: "Under 35 years",
                        icon: Icons.person,
                        color: Colors.green,
                      ),
                    const SizedBox(height: 15),

                    // Middle Aged Staff
                    if (viewModel.ageCategoryData!.middleAgedStaff != null)
                      AgeCategoryCard(
                        category: viewModel.ageCategoryData!.middleAgedStaff!,
                        title: "Middle Aged Staff",
                        subtitle: "35 - 55 years",
                        icon: Icons.people,
                        color: Colors.blue,
                      ),
                    const SizedBox(height: 15),

                    // Approaching Retirement
                    if (viewModel.ageCategoryData!.approachingRetirement != null)
                      AgeCategoryCard(
                        category:
                            viewModel.ageCategoryData!.approachingRetirement!,
                        title: "Approaching Retirement",
                        subtitle: "Over 55 years",
                        icon: Icons.elderly,
                        color: Colors.orange,
                      ),
                  ],

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
