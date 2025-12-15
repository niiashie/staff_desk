import 'package:flutter/material.dart';
import 'package:leave_desk/app/dialog.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/app/router.dart';
import 'package:leave_desk/app/theme.dart';
import 'package:leave_desk/constants/app.dart';
import 'package:leave_desk/constants/routes.dart';
import 'package:stacked_services/stacked_services.dart';

void main() {
  setupLocator();
  setupDialogUi();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: AppK.debugShowCheckedModeBanner,
      title: AppK.name,
      theme: AppTheme.light,
      initialRoute: Routes.login,
      onGenerateRoute: AppRouter.generateRoute,
      navigatorKey: StackedService.navigatorKey,
    );
  }
}
