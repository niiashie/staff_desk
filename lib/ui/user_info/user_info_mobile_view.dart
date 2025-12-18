import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/constants/images.dart';
import 'package:leave_desk/shared/app_logo.dart';
import 'package:leave_desk/ui/user_info/bio_data.dart';
import 'package:leave_desk/ui/user_info/family_data.dart';
import 'package:leave_desk/ui/user_info/employment_data.dart';
import 'package:leave_desk/ui/user_info/education_training_data.dart';
import 'package:leave_desk/ui/user_info/referees_data.dart';
import 'package:leave_desk/ui/user_info/beneficiary_data.dart';
import 'package:leave_desk/ui/user_info/emergency_data.dart';
import 'package:leave_desk/ui/user_info/user_info_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class UserInfoMobileView extends StackedView<UserInfoViewModel> {
  const UserInfoMobileView({Key? key}) : super(key: key);

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => true;

  @override
  void onViewModelReady(UserInfoViewModel viewModel) async {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    final screenWidth = MediaQuery.of(context).size.width;
    final pageController = PageController(
      initialPage: viewModel.currentStep - 1,
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.baseColor,
          image: DecorationImage(
            image: AssetImage(AppImages.pattern),
            repeat: ImageRepeat.repeat,
            opacity: 0.5,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with Logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: AppLogo(),
              ),

              // Fixed Smooth Page Indicator
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: viewModel.labels.length,
                      effect: WormEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        spacing: 8,
                        activeDotColor: AppColors.primaryColor,
                        dotColor: Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
              ),

              // Form Content in PageView
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics:
                      NeverScrollableScrollPhysics(), // Disable swipe, use buttons instead
                  onPageChanged: (index) {
                    viewModel.onStepTapped(index + 1);
                  },
                  children: [
                    _buildStepContainer(
                      context,
                      screenWidth,
                      BioDataWidget(
                        onFormReady: viewModel.onBioDataFormReady,
                        onNext: () async {
                          if (viewModel.appService.currentUser!.bioData ==
                              null) {
                            await viewModel.submitBioData();
                          } else {
                            await viewModel.updateBioData();
                          }
                          if (viewModel.currentStep == 2) {
                            pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        isLoading: viewModel.isLoading,
                      ),
                      pageController,
                      viewModel,
                    ),
                    _buildStepContainer(
                      context,
                      screenWidth,
                      FamilyData(
                        onFormReady: viewModel.onFamilyDataFormReady,
                        onNext: () async {
                          if (viewModel.appService.currentUser!.familyData ==
                              null) {
                            await viewModel.submitFamilyData();
                          } else {
                            await viewModel.updateFamilyData();
                          }
                          if (viewModel.currentStep == 3) {
                            pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        onPrevious: () {
                          viewModel.goToPreviousStep();
                          pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        isLoading: viewModel.isLoading,
                      ),
                      pageController,
                      viewModel,
                    ),
                    _buildStepContainer(
                      context,
                      screenWidth,
                      EmploymentData(
                        onFormReady: viewModel.onEmploymentDataFormReady,
                        onNext: () async {
                          if (viewModel
                                  .appService
                                  .currentUser!
                                  .employmentRecord ==
                              null) {
                            await viewModel.submitEmploymentData();
                          } else {
                            await viewModel.updateEmploymentData();
                          }
                          if (viewModel.currentStep == 4) {
                            pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        onPrevious: () {
                          viewModel.goToPreviousStep();
                          pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        isLoading: viewModel.isLoading,
                      ),
                      pageController,
                      viewModel,
                    ),
                    _buildStepContainer(
                      context,
                      screenWidth,
                      EducationTrainingData(
                        onFormReady: viewModel.onEducationTrainingDataFormReady,
                        onNext: () async {
                          await viewModel.submitEducationTrainingData(
                            viewModel
                                        .appService
                                        .currentUser!
                                        .educationTraining ==
                                    null
                                ? "submit"
                                : "update",
                          );
                          if (viewModel.currentStep == 5) {
                            pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        onPrevious: () {
                          viewModel.goToPreviousStep();
                          pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        isLoading: viewModel.isLoading,
                      ),
                      pageController,
                      viewModel,
                    ),
                    _buildStepContainer(
                      context,
                      screenWidth,
                      RefereesData(
                        onFormReady: viewModel.onRefereesDataFormReady,
                        onNext: () async {
                          await viewModel.submitRefereesData(
                            viewModel.appService.currentUser!.referees!.isEmpty
                                ? "submit"
                                : "upload",
                          );
                          if (viewModel.currentStep == 6) {
                            pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        onPrevious: () {
                          viewModel.goToPreviousStep();
                          pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        isLoading: viewModel.isLoading,
                        initialData: viewModel.savedRefereesData,
                      ),
                      pageController,
                      viewModel,
                    ),
                    _buildStepContainer(
                      context,
                      screenWidth,
                      BeneficiaryData(
                        onFormReady: viewModel.onBeneficiaryDataFormReady,
                        onNext: () async {
                          await viewModel.submitBeneficiaryData(
                            viewModel
                                    .appService
                                    .currentUser!
                                    .beneficiaries!
                                    .isEmpty
                                ? "submit"
                                : "upload",
                          );
                          if (viewModel.currentStep == 7) {
                            pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        onPrevious: () {
                          viewModel.goToPreviousStep();
                          pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        isLoading: viewModel.isLoading,
                        initialData: viewModel.savedBeneficiaryData,
                      ),
                      pageController,
                      viewModel,
                    ),
                    _buildStepContainer(
                      context,
                      screenWidth,
                      EmergencyData(
                        onFormReady: viewModel.onEmergencyDataFormReady,
                        onNext: () async {
                          await viewModel.submitEmergencyData(
                            viewModel
                                    .appService
                                    .currentUser!
                                    .emergencies!
                                    .isEmpty
                                ? "submit"
                                : "update",
                          );
                        },
                        onPrevious: () {
                          viewModel.goToPreviousStep();
                          pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        isLoading: viewModel.isLoading,
                        initialData: viewModel.savedEmergencyData,
                      ),
                      pageController,
                      viewModel,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContainer(
    BuildContext context,
    double screenWidth,
    Widget child,
    PageController pageController,
    UserInfoViewModel viewModel,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 8),
      child: Container(
        width: screenWidth - 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Current Step Title
              Text(
                viewModel.labels[viewModel.currentStep - 1],
                style: TextStyle(
                  color: AppColors.crudTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Form Content
              child,
            ],
          ),
        ),
      ),
    );
  }

  @override
  UserInfoViewModel viewModelBuilder(BuildContext context) =>
      UserInfoViewModel();
}
