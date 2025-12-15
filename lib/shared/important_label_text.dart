import 'package:flutter/material.dart';

class ImportantLabelText extends StatelessWidget {
  final String label;

  const ImportantLabelText({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black38),
        ),
        const SizedBox(
          width: 10,
        ),
        const Text(
          "*",
          style: TextStyle(color: Colors.red),
        )
      ],
    );
  }
}
