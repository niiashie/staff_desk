import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/constants/images.dart';
import 'package:leave_desk/shared/app_logo.dart';
import 'package:leave_desk/shared/step_progress_indicator.dart';
import 'package:leave_desk/ui/user_info/bio_data.dart';
import 'package:leave_desk/ui/user_info/family_data.dart';
import 'package:leave_desk/ui/user_info/employment_data.dart';
import 'package:leave_desk/ui/user_info/education_training_data.dart';
import 'package:leave_desk/ui/user_info/referees_data.dart';
import 'package:leave_desk/ui/user_info/beneficiary_data.dart';
import 'package:leave_desk/ui/user_info/emergency_data.dart';
import 'package:leave_desk/ui/user_info/user_info_view_model.dart';
import 'package:stacked/stacked.dart';

class UserInfoView extends StackedView<UserInfoViewModel> {
  const UserInfoView({Key? key}) : super(key: key);

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
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Center(
              child: Container(
                width: viewModel.containerWidth,
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Card(
                  color: Colors.white,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppLogo(),
                        Text(
                          "Nice to have you, key in your details to proceed",
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 700,
                          child: StepProgressIndicator(
                            numberOfSteps: viewModel.labels.length,
                            stepLabels: viewModel.labels,
                            currentStep: viewModel.currentStep,
                            onStepTapped: (step) {
                              viewModel.onStepTapped(step);
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          viewModel.labels[viewModel.currentStep - 1],
                          style: TextStyle(
                            color: AppColors.crudTextColor,
                            fontSize: 18,
                          ),
                        ),

                        viewModel.currentStep == 1
                            ? BioDataWidget(
                                onFormReady: viewModel.onBioDataFormReady,
                                onNext: viewModel.submitBioData,
                                isLoading: viewModel.isLoading,
                              )
                            : viewModel.currentStep == 2
                            ? FamilyData(
                                onFormReady: viewModel.onFamilyDataFormReady,
                                onNext: viewModel.submitFamilyData,
                                onPrevious: viewModel.goToPreviousStep,
                                isLoading: viewModel.isLoading,
                              )
                            : viewModel.currentStep == 3
                            ? EmploymentData(
                                onFormReady:
                                    viewModel.onEmploymentDataFormReady,
                                onNext: viewModel.submitEmploymentData,
                                onPrevious: viewModel.goToPreviousStep,
                                isLoading: viewModel.isLoading,
                              )
                            : viewModel.currentStep == 4
                            ? EducationTrainingData(
                                onFormReady:
                                    viewModel.onEducationTrainingDataFormReady,
                                onNext: viewModel.submitEducationTrainingData,
                                onPrevious: viewModel.goToPreviousStep,
                                isLoading: viewModel.isLoading,
                              )
                            : viewModel.currentStep == 5
                            ? RefereesData(
                                onFormReady: viewModel.onRefereesDataFormReady,
                                onNext: viewModel.submitRefereesData,
                                onPrevious: viewModel.goToPreviousStep,
                                isLoading: viewModel.isLoading,
                                initialData: viewModel.savedRefereesData,
                              )
                            : viewModel.currentStep == 6
                            ? BeneficiaryData(
                                onFormReady:
                                    viewModel.onBeneficiaryDataFormReady,
                                onNext: viewModel.submitBeneficiaryData,
                                onPrevious: viewModel.goToPreviousStep,
                                isLoading: viewModel.isLoading,
                                initialData: viewModel.savedBeneficiaryData,
                              )
                            : viewModel.currentStep == 7
                            ? EmergencyData(
                                onFormReady: viewModel.onEmergencyDataFormReady,
                                onNext: viewModel.submitEmergencyData,
                                onPrevious: viewModel.goToPreviousStep,
                                isLoading: viewModel.isLoading,
                                initialData: viewModel.savedEmergencyData,
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Container(
          //   constraints: BoxConstraints(
          //     minHeight: MediaQuery.of(context).size.height,
          //   ),
          //   child: Center(
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //          AppLogo(),
          //          const SizedBox(height: 15,),
          //         StepProgressIndicator(
          //           numberOfSteps: 7,
          //           stepLabels: viewModel.labels,
          //           currentStep: viewModel.currentStep,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }

  @override
  UserInfoViewModel viewModelBuilder(BuildContext context) =>
      UserInfoViewModel();
}
