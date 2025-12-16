import 'package:flutter/material.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/services/app_service.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/custom_form_field.dart';

class EducationTrainingData extends StatefulWidget {
  final void Function(Map<String, dynamic> Function(), bool Function())?
      onFormReady;
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
  final appService = locator<AppService>();
  bool _hasDataChanged = false;

  // Store original values for comparison
  Map<String, dynamic>? _originalData;

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
        final yearController = TextEditingController();
        final institutionController = TextEditingController();
        final qualificationController = TextEditingController();

        // Add listeners to new controllers
        yearController.addListener(() => _checkForChanges());
        institutionController.addListener(() => _checkForChanges());
        qualificationController.addListener(() => _checkForChanges());

        _academicQualificationsControllers.add({
          'year': yearController,
          'institution': institutionController,
          'qualification': qualificationController,
        });
      }

      // Check for changes after updating qualifications count
      _checkForChanges();
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
        final institutionController = TextEditingController();
        final yearController = TextEditingController();
        final courseController = TextEditingController();
        final locationController = TextEditingController();

        // Add listeners to new controllers
        institutionController.addListener(() => _checkForChanges());
        yearController.addListener(() => _checkForChanges());
        courseController.addListener(() => _checkForChanges());
        locationController.addListener(() => _checkForChanges());

        _professionalTrainingsControllers.add({
          'instituition': institutionController,
          'year': yearController,
          'course': courseController,
          'location': locationController,
        });
      }

      // Check for changes after updating trainings count
      _checkForChanges();
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
    // Prefill form with existing education training data if available
    _prefillEducationTrainingData();
    // Store original data for comparison
    _storeOriginalData();
    // Add listeners to detect changes
    _addChangeListeners();
    // Pass the getPostBody and shouldSubmitData methods to parent widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onFormReady?.call(getPostBody, shouldSubmitData);
    });
  }

  // Prefill form with existing education training data
  void _prefillEducationTrainingData() {
    final educationTraining = appService.currentUser?.educationTraining;
    if (educationTraining != null) {
      _numberOfAcademicQualificationsController.text =
          educationTraining.numberOfAcademicQualifications?.toString() ?? '';
      _numberOfProfessionalTrainingController.text =
          educationTraining.numberOfProfessionalTraining?.toString() ?? '';
      _hobbiesSpecialInterestController.text =
          educationTraining.hobbiesSpecialInterest ?? '';

      // Prefill academic qualifications if available
      if (educationTraining.academicQualifications != null &&
          educationTraining.academicQualifications!.isNotEmpty) {
        _numberOfAcademicQualifications =
            educationTraining.academicQualifications!.length;

        // Create controllers for each academic qualification
        for (int i = 0;
            i < educationTraining.academicQualifications!.length;
            i++) {
          _academicQualificationsControllers.add({
            'year': TextEditingController(
              text: educationTraining.academicQualifications![i].year ?? '',
            ),
            'institution': TextEditingController(
              text:
                  educationTraining.academicQualifications![i].institution ?? '',
            ),
            'qualification': TextEditingController(
              text: educationTraining.academicQualifications![i].qualification ??
                  '',
            ),
          });
        }
      }

      // Prefill professional trainings if available
      if (educationTraining.trainings != null &&
          educationTraining.trainings!.isNotEmpty) {
        _numberOfProfessionalTraining = educationTraining.trainings!.length;

        // Create controllers for each professional training
        for (int i = 0; i < educationTraining.trainings!.length; i++) {
          _professionalTrainingsControllers.add({
            'instituition': TextEditingController(
              text: educationTraining.trainings![i].institution ?? '',
            ),
            'year': TextEditingController(
              text: educationTraining.trainings![i].year ?? '',
            ),
            'course': TextEditingController(
              text: educationTraining.trainings![i].course ?? '',
            ),
            'location': TextEditingController(
              text: educationTraining.trainings![i].location ?? '',
            ),
          });
        }
      }
    }
  }

  // Store original data
  void _storeOriginalData() {
    _originalData = getPostBody();
  }

  // Add change listeners to all controllers
  void _addChangeListeners() {
    void listener() => _checkForChanges();
    _numberOfAcademicQualificationsController.addListener(listener);
    _numberOfProfessionalTrainingController.addListener(listener);
    _hobbiesSpecialInterestController.addListener(listener);

    // Add listeners for academic qualifications controllers
    for (var controllers in _academicQualificationsControllers) {
      controllers['year']?.addListener(listener);
      controllers['institution']?.addListener(listener);
      controllers['qualification']?.addListener(listener);
    }

    // Add listeners for professional trainings controllers
    for (var controllers in _professionalTrainingsControllers) {
      controllers['instituition']?.addListener(listener);
      controllers['year']?.addListener(listener);
      controllers['course']?.addListener(listener);
      controllers['location']?.addListener(listener);
    }
  }

  // Check if data has changed
  void _checkForChanges() {
    if (_originalData == null) return;

    final currentData = getPostBody();
    bool hasChanged = false;

    // Compare main fields
    if (_originalData!['number_of_academic_qualifications'] !=
            currentData['number_of_academic_qualifications'] ||
        _originalData!['number_of_professional_training'] !=
            currentData['number_of_professional_training'] ||
        _originalData!['hobbies_special_interes'] !=
            currentData['hobbies_special_interes']) {
      hasChanged = true;
    }

    // Compare academic qualifications array
    if (!hasChanged) {
      final originalQualifications =
          _originalData!['academic_qualifications'] as List<Map<String, String>>;
      final currentQualifications =
          currentData['academic_qualifications'] as List<Map<String, String>>;

      if (originalQualifications.length != currentQualifications.length) {
        hasChanged = true;
      } else {
        for (int i = 0; i < originalQualifications.length; i++) {
          if (originalQualifications[i]['year'] != currentQualifications[i]['year'] ||
              originalQualifications[i]['institution'] !=
                  currentQualifications[i]['institution'] ||
              originalQualifications[i]['qualification'] !=
                  currentQualifications[i]['qualification']) {
            hasChanged = true;
            break;
          }
        }
      }
    }

    // Compare professional trainings array
    if (!hasChanged) {
      final originalTrainings =
          _originalData!['professional_trainings'] as List<Map<String, String>>;
      final currentTrainings =
          currentData['professional_trainings'] as List<Map<String, String>>;

      if (originalTrainings.length != currentTrainings.length) {
        hasChanged = true;
      } else {
        for (int i = 0; i < originalTrainings.length; i++) {
          if (originalTrainings[i]['instituition'] !=
                  currentTrainings[i]['instituition'] ||
              originalTrainings[i]['year'] != currentTrainings[i]['year'] ||
              originalTrainings[i]['course'] != currentTrainings[i]['course'] ||
              originalTrainings[i]['location'] != currentTrainings[i]['location']) {
            hasChanged = true;
            break;
          }
        }
      }
    }

    if (hasChanged != _hasDataChanged) {
      setState(() {
        _hasDataChanged = hasChanged;
      });
    }
  }

  // Check if data has changed and should be submitted
  bool shouldSubmitData() {
    debugPrint(
      'shouldSubmitData: educationTraining exists = ${appService.currentUser?.educationTraining != null}, hasDataChanged = $_hasDataChanged',
    );
    // If education training already exists and nothing changed, skip submission
    if (appService.currentUser?.educationTraining != null && !_hasDataChanged) {
      debugPrint('shouldSubmitData: returning false (no changes)');
      return false;
    }
    debugPrint('shouldSubmitData: returning true (should submit)');
    return true;
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
