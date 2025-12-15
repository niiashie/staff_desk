import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/custom_form_field.dart';

class EducationTrainingData extends StatefulWidget {
  final void Function(Map<String, dynamic> Function())? onFormReady;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final bool isLoading;

  const EducationTrainingData({
    super.key,
    this.onFormReady,
    this.onNext,
    this.onPrevious,
    this.isLoading = false,
  });

  @override
  State<EducationTrainingData> createState() => _EducationTrainingDataState();
}

class _EducationTrainingDataState extends State<EducationTrainingData> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for main fields
  final TextEditingController _numberOfAcademicQualificationsController =
      TextEditingController();
  final TextEditingController _numberOfProfessionalTrainingController =
      TextEditingController();
  final TextEditingController _hobbiesSpecialInterestController =
      TextEditingController();

  // Dynamic lists for academic qualifications and professional trainings
  List<Map<String, TextEditingController>> _academicQualificationsControllers =
      [];
  List<Map<String, TextEditingController>> _professionalTrainingsControllers =
      [];
  int _numberOfAcademicQualifications = 0;
  int _numberOfProfessionalTraining = 0;

  // Validator functions
  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  // Handle number of academic qualifications change
  void _handleNumberOfAcademicQualificationsChange(String value) {
    if (value.isEmpty) {
      setState(() {
        _numberOfAcademicQualifications = 0;
        _academicQualificationsControllers.clear();
      });
      return;
    }

    // Check if value is numeric
    final number = int.tryParse(value);
    if (number == null) {
      // Show modal dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Invalid Input'),
            content: const Text(
                'Number of academic qualifications should be numeric.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _numberOfAcademicQualificationsController.clear();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Update number of academic qualifications and create/remove controllers
    setState(() {
      _numberOfAcademicQualifications = number;

      // Clear existing controllers
      for (var controllers in _academicQualificationsControllers) {
        controllers['year']?.dispose();
        controllers['institution']?.dispose();
        controllers['qualification']?.dispose();
      }
      _academicQualificationsControllers.clear();

      // Create new controllers
      for (int i = 0; i < number; i++) {
        _academicQualificationsControllers.add({
          'year': TextEditingController(),
          'institution': TextEditingController(),
          'qualification': TextEditingController(),
        });
      }
    });
  }

  // Handle number of professional training change
  void _handleNumberOfProfessionalTrainingChange(String value) {
    if (value.isEmpty) {
      setState(() {
        _numberOfProfessionalTraining = 0;
        _professionalTrainingsControllers.clear();
      });
      return;
    }

    // Check if value is numeric
    final number = int.tryParse(value);
    if (number == null) {
      // Show modal dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Invalid Input'),
            content: const Text(
                'Number of professional training should be numeric.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _numberOfProfessionalTrainingController.clear();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Update number of professional trainings and create/remove controllers
    setState(() {
      _numberOfProfessionalTraining = number;

      // Clear existing controllers
      for (var controllers in _professionalTrainingsControllers) {
        controllers['instituition']?.dispose();
        controllers['year']?.dispose();
        controllers['course']?.dispose();
        controllers['location']?.dispose();
      }
      _professionalTrainingsControllers.clear();

      // Create new controllers
      for (int i = 0; i < number; i++) {
        _professionalTrainingsControllers.add({
          'instituition': TextEditingController(),
          'year': TextEditingController(),
          'course': TextEditingController(),
          'location': TextEditingController(),
        });
      }
    });
  }

  // Get post body
  Map<String, dynamic> getPostBody() {
    List<Map<String, String>> academicQualifications = [];
    for (int i = 0; i < _academicQualificationsControllers.length; i++) {
      academicQualifications.add({
        'year': _academicQualificationsControllers[i]['year']?.text ?? '',
        'institution':
            _academicQualificationsControllers[i]['institution']?.text ?? '',
        'qualification':
            _academicQualificationsControllers[i]['qualification']?.text ?? '',
      });
    }

    List<Map<String, String>> professionalTrainings = [];
    for (int i = 0; i < _professionalTrainingsControllers.length; i++) {
      professionalTrainings.add({
        'instituition':
            _professionalTrainingsControllers[i]['instituition']?.text ?? '',
        'year': _professionalTrainingsControllers[i]['year']?.text ?? '',
        'course': _professionalTrainingsControllers[i]['course']?.text ?? '',
        'location':
            _professionalTrainingsControllers[i]['location']?.text ?? '',
      });
    }

    return {
      "number_of_academic_qualifications":
          _numberOfAcademicQualificationsController.text,
      "number_of_professional_training":
          _numberOfProfessionalTrainingController.text,
      "hobbies_special_interes": _hobbiesSpecialInterestController.text,
      "academic_qualifications": academicQualifications,
      "professional_trainings": professionalTrainings,
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
    _numberOfAcademicQualificationsController.dispose();
    _numberOfProfessionalTrainingController.dispose();
    _hobbiesSpecialInterestController.dispose();

    // Dispose academic qualifications controllers
    for (var controllers in _academicQualificationsControllers) {
      controllers['year']?.dispose();
      controllers['institution']?.dispose();
      controllers['qualification']?.dispose();
    }

    // Dispose professional trainings controllers
    for (var controllers in _professionalTrainingsControllers) {
      controllers['instituition']?.dispose();
      controllers['year']?.dispose();
      controllers['course']?.dispose();
      controllers['location']?.dispose();
    }

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

  Widget _buildAcademicQualificationsSection() {
    if (_numberOfAcademicQualifications == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Academic Qualifications',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...List.generate(_numberOfAcademicQualifications, (index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Qualification ${index + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Year',
                  hintText: 'Enter year',
                  controller:
                      _academicQualificationsControllers[index]['year']!,
                  filled: true,
                  isImportant: true,
                  keyboardType: TextInputType.number,
                  validator: _validateRequired,
                ),
                CustomFormField(
                  label: 'Institution',
                  hintText: 'Enter institution name',
                  controller:
                      _academicQualificationsControllers[index]['institution']!,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
              ),
              const SizedBox(height: 8),
              CustomFormField(
                label: 'Qualification',
                hintText: 'Enter qualification',
                controller: _academicQualificationsControllers[index]
                    ['qualification']!,
                filled: true,
                isImportant: true,
                validator: _validateRequired,
              ),
              const SizedBox(height: 16),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildProfessionalTrainingsSection() {
    if (_numberOfProfessionalTraining == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Professional Trainings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...List.generate(_numberOfProfessionalTraining, (index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Training ${index + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Institution',
                  hintText: 'Enter institution name',
                  controller: _professionalTrainingsControllers[index]
                      ['instituition']!,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
                CustomFormField(
                  label: 'Year',
                  hintText: 'Enter year',
                  controller:
                      _professionalTrainingsControllers[index]['year']!,
                  filled: true,
                  isImportant: true,
                  keyboardType: TextInputType.number,
                  validator: _validateRequired,
                ),
              ),
              const SizedBox(height: 8),
              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Course',
                  hintText: 'Enter course name',
                  controller:
                      _professionalTrainingsControllers[index]['course']!,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
                CustomFormField(
                  label: 'Location',
                  hintText: 'Enter location',
                  controller:
                      _professionalTrainingsControllers[index]['location']!,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        }),
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
              // Education and Training Information Section
              const Text(
                'Education and Training Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Number of Academic Qualifications',
                  hintText: 'Enter number',
                  controller: _numberOfAcademicQualificationsController,
                  filled: true,
                  isImportant: true,
                  keyboardType: TextInputType.number,
                  validator: _validateRequired,
                  onChanged: _handleNumberOfAcademicQualificationsChange,
                ),
                CustomFormField(
                  label: 'Number of Professional Training',
                  hintText: 'Enter number',
                  controller: _numberOfProfessionalTrainingController,
                  filled: true,
                  isImportant: true,
                  keyboardType: TextInputType.number,
                  validator: _validateRequired,
                  onChanged: _handleNumberOfProfessionalTrainingChange,
                ),
              ),

              const SizedBox(height: 8),

              CustomFormField(
                label: 'Hobbies and Special Interest',
                hintText: 'Enter hobbies and special interests',
                controller: _hobbiesSpecialInterestController,
                filled: true,
                isImportant: true,
                validator: _validateRequired,
              ),

              // Dynamic academic qualifications fields
              _buildAcademicQualificationsSection(),

              // Dynamic professional trainings fields
              _buildProfessionalTrainingsSection(),

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
