import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';

class Loading extends StatelessWidget {
  final String? title;
  const Loading({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
            strokeWidth: 3,
          ),
        ),
        SizedBox(height: 15),
        Text(
          title ?? "Loading",
          style: TextStyle(color: AppColors.crudTextColor, fontSize: 13),
        ),
      ],
    );
  }
}
