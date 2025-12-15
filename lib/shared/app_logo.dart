import 'package:flutter/material.dart';
import 'package:leave_desk/constants/images.dart';
import 'package:leave_desk/constants/spaces.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Image.asset(AppImages.logo, width: 100, height: 80),
        const SizedBox(height: 5),
        const Text(
          "Staff Desk",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: AppfontSizes.large,
          ),
        ),
        AppSpaces.smallVerticalHeight,
      ],
    );
  }
}
