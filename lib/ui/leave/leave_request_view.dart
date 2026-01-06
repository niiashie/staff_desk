import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/custom_form_field.dart';
import 'package:leave_desk/shared/loading.dart';
import 'package:leave_desk/shared/page_title.dart';
import 'package:leave_desk/ui/leave/leave_view_model.dart';
import 'package:stacked/stacked.dart';

class LeaveRequestView extends StackedView<LeaveViewModel> {
  const LeaveRequestView({Key? key}) : super(key: key);

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => true;

  @override
  void onViewModelReady(LeaveViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 35),
      child: viewModel.busy("loading")
          ? Center(child: Loading(title: "Loading"))
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  PageTitle(name: "Leave Request"),
                  const SizedBox(height: 15),
                  Container(
                    width: 450,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Form(
                        key: viewModel.leaveRequestFormKey,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Provide the details required for leave application. You have ${viewModel.appService.currentUser!.leave!.daysLeft} days of work leave left",
                              ),

                              const SizedBox(height: 25),

                              // Hand Over Person Dropdown
                              CustomFormField(
                                label: "Hand Over Person",
                                hintText: viewModel.selectedHandOverUser != null
                                    ? "${viewModel.selectedHandOverUser!.name} (${viewModel.selectedHandOverUser!.pin})"
                                    : "Select hand over person",
                                filled: true,
                                isImportant: true,
                                controller: viewModel.handOverController,
                                readOnly: true,
                                onTap: () =>
                                    _showHandOverDialog(context, viewModel),
                              ),
                              const SizedBox(height: 15),

                              // Leave Type Dropdown
                              CustomFormField(
                                label: "Leave Type",
                                hintText:
                                    viewModel.selectedLeaveType ??
                                    "Select leave type",
                                filled: true,
                                controller: viewModel.descriptionController,
                                isImportant: true,
                                readOnly: true,
                                onTap: () =>
                                    _showLeaveTypeDialog(context, viewModel),
                              ),
                              const SizedBox(height: 15),

                              // Number of Days
                              CustomFormField(
                                label: "Number of Days",
                                hintText: "Enter number of days",
                                controller: viewModel.numberOfDaysController,
                                filled: true,
                                isImportant: true,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Number of days is required';
                                  }
                                  final number = int.tryParse(value);
                                  if (number == null) {
                                    return 'Please enter a valid number';
                                  }
                                  if (number <= 0) {
                                    return 'Number of days must be greater than 0';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),

                              // Start Date
                              CustomFormField(
                                label: "Start Date",
                                hintText: "YYYY-MM-DD",
                                controller: viewModel.startDateController,
                                filled: true,
                                isImportant: true,
                                readOnly: true,
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now().add(
                                      Duration(days: 100),
                                    ),
                                  );
                                  if (date != null) {
                                    viewModel.startDateController.text = date
                                        .toString()
                                        .split(' ')[0];
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Start date is required';
                                  }
                                  if (!RegExp(
                                    r'^\d{4}-\d{2}-\d{2}$',
                                  ).hasMatch(value)) {
                                    return 'Date must be in YYYY-MM-DD format';
                                  }
                                  // Check if start date is after end date
                                  if (viewModel
                                      .endDateController
                                      .text
                                      .isNotEmpty) {
                                    try {
                                      final startDate = DateTime.parse(value);
                                      final endDate = DateTime.parse(
                                        viewModel.endDateController.text,
                                      );
                                      if (startDate.isAfter(endDate)) {
                                        return 'Start date must be before end date';
                                      }
                                    } catch (e) {
                                      // Invalid date format, let the format validator catch it
                                    }
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),

                              // End Date
                              CustomFormField(
                                label: "End Date",
                                hintText: "YYYY-MM-DD",
                                controller: viewModel.endDateController,
                                filled: true,
                                isImportant: true,
                                readOnly: true,
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now().add(
                                      Duration(days: 100),
                                    ),
                                  );
                                  if (date != null) {
                                    viewModel.endDateController.text = date
                                        .toString()
                                        .split(' ')[0];
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'End date is required';
                                  }
                                  if (!RegExp(
                                    r'^\d{4}-\d{2}-\d{2}$',
                                  ).hasMatch(value)) {
                                    return 'Date must be in YYYY-MM-DD format';
                                  }
                                  // Check if end date is before start date
                                  if (viewModel
                                      .startDateController
                                      .text
                                      .isNotEmpty) {
                                    try {
                                      final startDate = DateTime.parse(
                                        viewModel.startDateController.text,
                                      );
                                      final endDate = DateTime.parse(value);
                                      if (endDate.isBefore(startDate)) {
                                        return 'End date must be after start date';
                                      }
                                    } catch (e) {
                                      // Invalid date format, let the format validator catch it
                                    }
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 25),

                              Align(
                                alignment: Alignment.bottomRight,
                                child: CustomButton(
                                  width: 100,
                                  isLoading: viewModel.busy(
                                    "submitLeaveLoader",
                                  ),
                                  height: 40,
                                  color: AppColors.primaryColor,
                                  elevation: 2,
                                  title: Text(
                                    "Submit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  ontap: () {
                                    viewModel.submitLeaveRequest();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _showHandOverDialog(BuildContext context, LeaveViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Hand Over Person"),
        content: SizedBox(
          width: 400,
          child: viewModel.availableUsers.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("No users available"),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: viewModel.availableUsers.length,
                  itemBuilder: (context, index) {
                    final user = viewModel.availableUsers[index];
                    final isSelected =
                        viewModel.selectedHandOverUser?.id == user.id;
                    return ListTile(
                      title: Text("${user.name} (${user.role!.name})"),
                      tileColor: isSelected
                          ? AppColors.primaryColor.withOpacity(0.1)
                          : null,
                      onTap: () {
                        viewModel.setHandOverUser(user);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _showLeaveTypeDialog(BuildContext context, LeaveViewModel viewModel) {
    final leaveTypes = ['annual', 'sick', 'maternity', 'unpaid', 'casual'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Leave Type"),
        content: SizedBox(
          width: 300,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: leaveTypes.length,
            itemBuilder: (context, index) {
              final type = leaveTypes[index];
              final isSelected = viewModel.selectedLeaveType == type;
              return ListTile(
                title: Text(type.toUpperCase()),
                tileColor: isSelected
                    ? AppColors.primaryColor.withOpacity(0.1)
                    : null,
                onTap: () {
                  viewModel.setLeaveType(type);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  LeaveViewModel viewModelBuilder(BuildContext context) => LeaveViewModel();
}
