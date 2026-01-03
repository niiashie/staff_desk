import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leave_desk/api/auth_api.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/constants/routes.dart';
import 'package:leave_desk/models/api_response.dart';
import 'package:leave_desk/models/user.dart';
import 'package:leave_desk/services/app_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AuthenticationViewModel extends BaseViewModel {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registrationFormKey = GlobalKey<FormState>();
  var appService = locator<AppService>();
  TextEditingController? pin, name, password, confirmPassword, phone;
  AuthApi authApi = AuthApi();
  Map<String, dynamic>? data;

  init() {
    pin = TextEditingController(text: "");
    name = TextEditingController(text: "");
    password = TextEditingController(text: "");
    confirmPassword = TextEditingController(text: "");
    phone = TextEditingController(text: "");
  }

  login() async {
    if (loginFormKey.currentState!.validate()) {
      data = {"pin": pin!.text, "password": password!.text};
      setBusyForObject("loginButton", true);
      try {
        ApiResponse loginresponse = await authApi.login(data!);
        if (loginresponse.ok) {
          debugPrint("response : ${loginresponse.data}");
          appService.currentUser = User.fromJson(loginresponse.data);
          setBusyForObject("loginButton", false);

          // Check screen width and navigate to appropriate view
          final context = StackedService.navigatorKey!.currentState!.context;
          final screenWidth = MediaQuery.of(context).size.width;
          final isMobile = screenWidth < 600;

          if (appService.currentUser!.accountIsVerified!) {
            if (appService.currentUser!.branches!.isEmpty) {
              appService.showMessage(
                title: "No Branch",
                message: "Contact admin to assign you to a branch to proceed",
              );
            } else {
              Navigator.of(
                // ignore: use_build_context_synchronously
                context,
              ).pushReplacementNamed(Routes.base);
            }
          } else {
            Navigator.of(
              // ignore: use_build_context_synchronously
              context,
            ).pushReplacementNamed(
              isMobile ? Routes.userInfoMobile : Routes.userInfo,
            );
          }
        }
      } on DioException catch (e) {
        debugPrint("error response : ${e.response!.data}");
        ApiResponse errorResponse = ApiResponse.parse(e.response);
        setBusyForObject("loginButton", false);

        appService.showMessage(message: errorResponse.message);
      }
    }
  }

  register() async {
    if (registrationFormKey.currentState!.validate()) {
      data = {
        "name": name!.text,
        "pin": pin!.text,
        "password": password!.text,
        "role": "staff",
      };
      setBusyForObject("registerButton", true);
      try {
        ApiResponse response = await authApi.registration(data!);
        debugPrint("success : ${response.data}");
        if (response.ok) {
          setBusyForObject("registerButton", false);
          Navigator.of(
            // ignore: use_build_context_synchronously
            StackedService.navigatorKey!.currentState!.context,
          ).pop();
          appService.showMessage(
            title: "Registration Success",

            message:
                "User creation successful, contact admin for account activation",
          );
        }
      } on DioException catch (e) {
        debugPrint("error : ${e.response!.data}");
        ApiResponse errorResponse = ApiResponse.parse(e.response);
        setBusyForObject("registerButton", false);

        appService.showMessage(message: errorResponse.message);
      }
    }
  }
}
