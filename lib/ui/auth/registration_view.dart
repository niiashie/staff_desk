import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/constants/images.dart';
import 'package:leave_desk/constants/routes.dart';
import 'package:leave_desk/constants/spaces.dart';
import 'package:leave_desk/shared/app_logo.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/custom_form_field.dart';
import 'package:leave_desk/ui/auth/authentication_view_model.dart';
import 'package:leave_desk/utils.dart';
import 'package:stacked/stacked.dart';

class RegistrationView extends StackedView<AuthenticationViewModel> {
  const RegistrationView({Key? key}) : super(key: key);

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => true;

  @override
  void onViewModelReady(AuthenticationViewModel viewModel) async {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

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
              child: Form(
                key: viewModel.registrationFormKey,
                child: Container(
                  width: isMobile ? screenWidth : 450,
                  padding: EdgeInsets.only(
                    top: isMobile ? 0 : 5,
                    bottom: isMobile ? 0 : 5,
                    left: isMobile ? 16 : 0,
                    right: isMobile ? 16 : 0,
                  ),
                  child: Card(
                    color: Colors.white,
                    elevation: isMobile ? 0 : 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isMobile ? 0 : 10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isMobile ? 20 : 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppLogo(),
                          Text(
                            "Staff Records And Leave Management System",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.lightTextColor,
                              fontSize: isMobile ? 12 : AppfontSizes.small,
                            ),
                          ),
                          Text(
                            "Provide the details below to create an account",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.lightTextColor,
                              fontSize: isMobile ? 12 : AppfontSizes.small,
                            ),
                          ),
                          AppSpaces.largeVerticalHeight,
                          Padding(
                            padding: EdgeInsets.only(left: isMobile ? 5 : 25),
                            child: const SizedBox(
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Name",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: AppfontSizes.small,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AppSpaces.verySmallVerticalHeight,
                          Padding(
                            padding: EdgeInsets.only(
                              left: isMobile ? 0 : 20,
                              right: isMobile ? 0 : 20,
                            ),
                            child: CustomFormField(
                              hintText: "Enter your name",
                              filled: true,
                              key: const Key("name"),
                              controller: viewModel.name,
                              contentPadding: 0,
                              borderRadius: 10,
                              fillColor: Colors.white,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "Name required.";
                                }

                                return null;
                              },
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: AppColors.defaultIconColor,
                                size: 16,
                              ),
                            ),
                          ),
                          AppSpaces.verySmallVerticalHeight,
                          Padding(
                            padding: EdgeInsets.only(left: isMobile ? 5 : 25),
                            child: const SizedBox(
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "PIN",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: AppfontSizes.small,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AppSpaces.verySmallVerticalHeight,
                          Padding(
                            padding: EdgeInsets.only(
                              left: isMobile ? 0 : 20,
                              right: isMobile ? 0 : 20,
                            ),
                            child: CustomFormField(
                              hintText: "Enter your PIN",
                              filled: true,
                              key: const Key("pin"),
                              controller: viewModel.pin,
                              contentPadding: 0,
                              borderRadius: 10,
                              fillColor: Colors.white,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "PIN required.";
                                } else if (!Utils().isNumeric(value)) {
                                  return "PIN must be numeric";
                                }

                                return null;
                              },
                              prefixIcon: Image.asset(
                                AppImages.pin,
                                height: 16,
                                width: 16,
                                color: AppColors.defaultIconColor,
                              ),
                            ),
                          ),
                          AppSpaces.verySmallVerticalHeight,
                          Padding(
                            padding: EdgeInsets.only(left: isMobile ? 5 : 25),
                            child: const SizedBox(
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Password",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: AppfontSizes.small,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AppSpaces.verySmallVerticalHeight,
                          Padding(
                            padding: EdgeInsets.only(
                              left: isMobile ? 0 : 20,
                              right: isMobile ? 0 : 20,
                            ),
                            child: CustomFormField(
                              hintText: "Enter password...",
                              contentPadding: 0,
                              key: const Key("password"),
                              filled: true,
                              borderRadius: 10,
                              controller: viewModel.password,
                              fillColor: Colors.white,
                              isPasswordField: true,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "Password is required.";
                                }

                                return null;
                              },
                              prefixIcon: Image.asset(
                                AppImages.password,
                                height: 16,
                                width: 16,
                                color: AppColors.defaultIconColor,
                              ),
                            ),
                          ),
                          AppSpaces.verySmallVerticalHeight,
                          Padding(
                            padding: EdgeInsets.only(left: isMobile ? 5 : 25),
                            child: const SizedBox(
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Password Confirmation",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: AppfontSizes.small,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AppSpaces.verySmallVerticalHeight,
                          Padding(
                            padding: EdgeInsets.only(
                              left: isMobile ? 0 : 20,
                              right: isMobile ? 0 : 20,
                            ),
                            child: CustomFormField(
                              hintText: "Confirm your password",
                              contentPadding: 0,
                              key: const Key("password"),
                              filled: true,
                              borderRadius: 10,
                              controller: viewModel.confirmPassword,
                              fillColor: Colors.white,
                              isPasswordField: true,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "Password is required.";
                                }

                                return null;
                              },
                              prefixIcon: Image.asset(
                                AppImages.password,
                                height: 16,
                                width: 16,
                                color: AppColors.defaultIconColor,
                              ),
                            ),
                          ),
                          AppSpaces.mediumVerticalHeight,
                          Padding(
                            padding: EdgeInsets.only(
                              left: isMobile ? 0 : 20,
                              right: isMobile ? 0 : 20,
                            ),
                            child: CustomButton(
                              width: double.infinity,
                              maxWidth: double.infinity,
                              isLoading: viewModel.busy("registerButton"),
                              height: 45,
                              elevation: 2,
                              borderRadius: 10,
                              color: AppColors.primaryColor,
                              title: const Text(
                                "Create Account",
                                style: TextStyle(color: Colors.white),
                              ),
                              ontap: () {
                                viewModel.register();
                              },
                            ),
                          ),
                          AppSpaces.verySmallVerticalHeight,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Already having an account ?",
                                style: TextStyle(
                                  color: AppColors.lightTextColor,
                                  fontSize: isMobile ? 12 : 14,
                                ),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: isMobile ? 12 : 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          AppSpaces.mediumVerticalHeight,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  AuthenticationViewModel viewModelBuilder(BuildContext context) =>
      AuthenticationViewModel();
}
