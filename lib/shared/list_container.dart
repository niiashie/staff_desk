import 'package:flutter/material.dart';

class ListContainer extends StatelessWidget {
  final int index;
  final Widget child;
  const ListContainer({super.key, required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      color: index % 2 == 0 ? Colors.transparent : Colors.white,
      child: child,
    );
  }
}
