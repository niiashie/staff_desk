import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';

class PageTitle extends StatelessWidget {
  final String? name;
  const PageTitle({super.key, this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      name!,
      style: const TextStyle(
        color: AppColors.crudTextColor,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
    );
  }
}
