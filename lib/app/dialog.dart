import 'package:flutter/material.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:stacked_services/stacked_services.dart';

enum DialogType { basic, confirmation }

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final builders = {
    DialogType.basic: (context, request, completer) => AlertDialog(
      backgroundColor: AppColors.baseColor,
      title: Text(request.title ?? 'Default Title'),
      content: Text(request.description ?? 'Default Description'),
      actions: [
        TextButton(
          onPressed: () => completer(DialogResponse(confirmed: true)),
          child: const Text('OK'),
        ),
      ],
    ),
    DialogType.confirmation: (context, request, completer) => AlertDialog(
      backgroundColor: AppColors.baseColor,
      title: Text(request.title ?? 'Confirm'),
      content: Text(request.description ?? 'Are you sure?'),
      actions: [
        TextButton(
          onPressed: () => completer(DialogResponse(confirmed: false)),
          child: Text(request.secondaryButtonTitle ?? 'Cancel'),
        ),
        TextButton(
          onPressed: () => completer(DialogResponse(confirmed: true)),
          child: Text(request.mainButtonTitle ?? 'Confirm'),
        ),
      ],
    ),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
