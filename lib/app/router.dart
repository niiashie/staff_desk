import 'package:flutter/material.dart';
import 'package:leave_desk/ui/auth/login_view.dart';
import 'package:leave_desk/ui/auth/registration_view.dart';
import 'package:leave_desk/ui/user_info/user_info_view.dart';
import 'package:leave_desk/utils.dart';
import '../constants/routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (context) => const LoginView());
      case Routes.register:
        return Utils.slideRightTransition(const RegistrationView());
      case Routes.userInfo:
        return Utils.slideRightTransition(const UserInfoView());
      default:
        return MaterialPageRoute(builder: (context) => const LoginView());
    }
  }
}
