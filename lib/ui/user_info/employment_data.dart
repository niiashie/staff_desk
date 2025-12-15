import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/custom_form_field.dart';

class EmploymentData extends StatefulWidget {
  final void Function(Map<String, String> Function())? onFormReady;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final bool isLoading;

  const EmploymentData({
    super.key,
    this.onFormReady,
    this.onNext,
    this.onPrevious,
    this.isLoading = false,
  });

  @override
  State<EmploymentData> createState() => _EmploymentDataState();
}

class _EmploymentDataState extends State<EmploymentData> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for all fields
  final TextEditingController _numberOfPreviousWorkPlaceController =
      TextEditingController();
  final TextEditingController _presentJobTitleController =
      TextEditingController();
  final TextEditingController _dateOfEmploymentController =
      TextEditingController();
  final TextEditingController _probationPeriodController =
      TextEditingController();
  final TextEditingController _immediateSupervisorController =
      TextEditingController();
  final TextEditingController _employmentStatusController =
      TextEditingController();
  final TextEditingController _careerObjectsController =
      TextEditingController();

  // Validator functions
  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  // Get post body
  Map<String, String> getPostBody() {
    return {
      "number_of_previous_work_place":
          _numberOfPreviousWorkPlaceController.text,
      "present_job_title": _presentJobTitleController.text,
      "date_of_employment": _dateOfEmploymentController.text,
      "probation_period": _probationPeriodController.text,
      "immediate_supervisor": _immediateSupervisorController.text,
      "employment_status": _employmentStatusController.text,
      "career_objects": _careerObjectsController.text,
    };
  }

  @override
  void initState() {
    super.initState();
    // Pass the getPostBody method to parent widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onFormReady?.call(getPostBody);
    });
  }

  @override
  void dispose() {
    _numberOfPreviousWorkPlaceController.dispose();
    _presentJobTitleController.dispose();
    _dateOfEmploymentController.dispose();
    _probationPeriodController.dispose();
    _immediateSupervisorController.dispose();
    _employmentStatusController.dispose();
    _careerObjectsController.dispose();
    super.dispose();
  }

  Widget _buildTwoColumnRow(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Employment Information Section
              const Text(
                'Employment Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Present Job Title',
                  hintText: 'Enter your job title',
                  controller: _presentJobTitleController,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
                CustomFormField(
                  label: 'Date of Employment',
                  hintText: 'Select employment date',
                  controller: _dateOfEmploymentController,
                  filled: true,
                  readOnly: true,
                  isImportant: true,
                  validator: _validateRequired,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      _dateOfEmploymentController.text = date.toString().split(
                        ' ',
                      )[0];
                    }
                  },
                ),
              ),

              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Probation Period',
                  hintText: 'Enter probation period',
                  controller: _probationPeriodController,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
                CustomFormField(
                  label: 'Employment Status',
                  hintText: 'Enter employment status',
                  controller: _employmentStatusController,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
              ),

              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Number of Previous Work Place',
                  hintText: 'Enter number',
                  controller: _numberOfPreviousWorkPlaceController,
                  filled: true,
                  keyboardType: TextInputType.number,
                ),
                CustomFormField(
                  label: 'Immediate Supervisor',
                  hintText: 'Enter supervisor name',
                  controller: _immediateSupervisorController,
                  filled: true,
                ),
              ),

              CustomFormField(
                label: 'Career Objects',
                hintText: 'Enter your career objectives',
                controller: _careerObjectsController,
                filled: true,
                isImportant: true,
                validator: _validateRequired,
                maxLines: 4,
              ),

              const SizedBox(height: 32),

              // Previous and Next Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    borderColors: AppColors.primaryColor,
                    title: const Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Icon(
                          Icons.chevron_left,
                          color: AppColors.primaryColor,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Previous',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    color: Colors.white,
                    ontap: () {
                      widget.onPrevious?.call();
                    },
                    width: 150,
                    height: 50,
                  ),
                  CustomButton(
                    title: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 24,
                        ),
                      ],
                    ),
                    color: AppColors.primaryColor,
                    ontap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        widget.onNext?.call();
                      }
                    },
                    width: 150,
                    height: 50,
                    isLoading: widget.isLoading,
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
