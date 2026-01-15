import 'package:flutter/material.dart';

class ListContainer extends StatelessWidget {
  final int index;
  final Widget child;
  final bool? showHiddenWidget;
  final Widget? hiddenWidget;
  const ListContainer({
    super.key,
    required this.index,
    required this.child,
    this.showHiddenWidget = false,
    this.hiddenWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 40,
          color: index % 2 == 0 ? Colors.transparent : Colors.white,
          child: child,
        ),
        Visibility(
          visible: showHiddenWidget!,
          child: hiddenWidget ?? SizedBox(),
        ),
      ],
    );
  }
}
