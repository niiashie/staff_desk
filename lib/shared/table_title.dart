import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';

class TableTitle extends StatelessWidget {
  final String name;
  final double? leftPadding;
  const TableTitle({super.key, required this.name, this.leftPadding = 0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: leftPadding!),
          child: Text(
            name,
            style: TextStyle(
              color: AppColors.crudTextColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
