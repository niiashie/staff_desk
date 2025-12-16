import 'package:flutter/material.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/services/app_service.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/custom_form_field.dart';

class EmploymentData extends StatefulWidget {
  final void Function(Map<String, dynamic> Function(), bool Function())?
      onFormReady;
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
  final appService = locator<AppService>();
  bool _hasDataChanged = false;

  // Store original values for comparison
  Map<String, dynamic>? _originalData;

  // Dropdown selected value
  String? _selectedEmploymentStatus;

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

  // Dynamic list for previous workplaces
  List<Map<String, TextEditingController>> _previousWorkPlacesControllers = [];
  int _numberOfPreviousWorkPlaces = 0;

  // Validator functions
  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  // Handle number of previous workplaces change
  void _handleNumberOfPreviousWorkPlacesChange(String value) {
    if (value.isEmpty) {
      setState(() {
        _numberOfPreviousWorkPlaces = 0;
        _previousWorkPlacesControllers.clear();
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
            content: const Text('Number of previous work places should be numeric.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _numberOfPreviousWorkPlaceController.clear();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Update number of previous workplaces and create/remove controllers
    setState(() {
      _numberOfPreviousWorkPlaces = number;

      // Clear existing controllers
      for (var controllers in _previousWorkPlacesControllers) {
        controllers['company_instituition']?.dispose();
        controllers['job_title']?.dispose();
        controllers['date']?.dispose();
      }
      _previousWorkPlacesControllers.clear();

      // Create new controllers
      for (int i = 0; i < number; i++) {
        final companyController = TextEditingController();
        final jobTitleController = TextEditingController();
        final dateController = TextEditingController();

        // Add listeners to new controllers
        companyController.addListener(() => _checkForChanges());
        jobTitleController.addListener(() => _checkForChanges());
        dateController.addListener(() => _checkForChanges());

        _previousWorkPlacesControllers.add({
          'company_instituition': companyController,
          'job_title': jobTitleController,
          'date': dateController,
        });
      }

      // Check for changes after updating work places count
      _checkForChanges();
    });
  }

  // Get post body
  Map<String, dynamic> getPostBody() {
    List<Map<String, String>> previousWorkPlaces = [];
    for (int i = 0; i < _previousWorkPlacesControllers.length; i++) {
      previousWorkPlaces.add({
        'company_instituition': _previousWorkPlacesControllers[i]['company_instituition']?.text ?? '',
        'job_title': _previousWorkPlacesControllers[i]['job_title']?.text ?? '',
        'date': _previousWorkPlacesControllers[i]['date']?.text ?? '',
      });
    }

    return {
      "present_job_title": _presentJobTitleController.text,
      "date_of_employment": _dateOfEmploymentController.text,
      "probation_period": _probationPeriodController.text,
      "employment_status": _employmentStatusController.text,
      "career_objects": _careerObjectsController.text,
      "number_of_previous_work_place": _numberOfPreviousWorkPlaceController.text,
      "immediate_supervisor": _immediateSupervisorController.text,
      "previous_work_places": previousWorkPlaces,
    };
  }

  @override
  void initState() {
    super.initState();
    // Prefill form with existing employment data if available
    _prefillEmploymentData();
    // Store original data for comparison
    _storeOriginalData();
    // Add listeners to detect changes
    _addChangeListeners();
    // Pass the getPostBody and shouldSubmitData methods to parent widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onFormReady?.call(getPostBody, shouldSubmitData);
    });
  }

  // Prefill form with existing employment data
  void _prefillEmploymentData() {
    final employmentRecord = appService.currentUser?.employmentRecord;
    if (employmentRecord != null) {
      _presentJobTitleController.text = employmentRecord.presentJobTitle ?? '';
      _dateOfEmploymentController.text =
          employmentRecord.dateOfEmployment ?? '';
      _probationPeriodController.text = employmentRecord.probationPeriod ?? '';
      _immediateSupervisorController.text =
          employmentRecord.immediateSupervisor ?? '';
      _employmentStatusController.text =
          employmentRecord.employmentStatus ?? '';
      _selectedEmploymentStatus = employmentRecord.employmentStatus;
      _careerObjectsController.text = employmentRecord.careerObjects ?? '';
      _numberOfPreviousWorkPlaceController.text =
          employmentRecord.numberOfPreviousWorkPlace?.toString() ?? '';

      // Prefill previous work places if available
      if (employmentRecord.previousWorkPlaces != null &&
          employmentRecord.previousWorkPlaces!.isNotEmpty) {
        _numberOfPreviousWorkPlaces =
            employmentRecord.previousWorkPlaces!.length;

        // Create controllers for each previous work place
        for (int i = 0; i < employmentRecord.previousWorkPlaces!.length; i++) {
          _previousWorkPlacesControllers.add({
            'company_instituition': TextEditingController(
              text: employmentRecord.previousWorkPlaces![i].companyInstitution ??
                  '',
            ),
            'job_title': TextEditingController(
              text: employmentRecord.previousWorkPlaces![i].jobTitle ?? '',
            ),
            'date': TextEditingController(
              text: employmentRecord.previousWorkPlaces![i].date ?? '',
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
    _presentJobTitleController.addListener(listener);
    _dateOfEmploymentController.addListener(listener);
    _probationPeriodController.addListener(listener);
    _immediateSupervisorController.addListener(listener);
    _employmentStatusController.addListener(listener);
    _careerObjectsController.addListener(listener);
    _numberOfPreviousWorkPlaceController.addListener(listener);

    // Add listeners for previous work places controllers
    for (var controllers in _previousWorkPlacesControllers) {
      controllers['company_instituition']?.addListener(listener);
      controllers['job_title']?.addListener(listener);
      controllers['date']?.addListener(listener);
    }
  }

  // Check if data has changed
  void _checkForChanges() {
    if (_originalData == null) return;

    final currentData = getPostBody();
    bool hasChanged = false;

    // Compare all fields except previous_work_places array
    _originalData!.forEach((key, value) {
      if (key != 'previous_work_places') {
        if (currentData[key] != value) {
          hasChanged = true;
        }
      }
    });

    // Compare previous work places array
    final originalWorkPlaces =
        _originalData!['previous_work_places'] as List<Map<String, String>>;
    final currentWorkPlaces =
        currentData['previous_work_places'] as List<Map<String, String>>;

    if (originalWorkPlaces.length != currentWorkPlaces.length) {
      hasChanged = true;
    } else {
      for (int i = 0; i < originalWorkPlaces.length; i++) {
        if (originalWorkPlaces[i]['company_instituition'] !=
                currentWorkPlaces[i]['company_instituition'] ||
            originalWorkPlaces[i]['job_title'] !=
                currentWorkPlaces[i]['job_title'] ||
            originalWorkPlaces[i]['date'] != currentWorkPlaces[i]['date']) {
          hasChanged = true;
          break;
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
      'shouldSubmitData: employmentRecord exists = ${appService.currentUser?.employmentRecord != null}, hasDataChanged = $_hasDataChanged',
    );
    // If employment record already exists and nothing changed, skip submission
    if (appService.currentUser?.employmentRecord != null && !_hasDataChanged) {
      debugPrint('shouldSubmitData: returning false (no changes)');
      return false;
    }
    debugPrint('shouldSubmitData: returning true (should submit)');
    return true;
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

    // Dispose previous workplaces controllers
    for (var controllers in _previousWorkPlacesControllers) {
      controllers['company_instituition']?.dispose();
      controllers['job_title']?.dispose();
      controllers['date']?.dispose();
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

  Widget _buildPreviousWorkPlacesSection() {
    if (_numberOfPreviousWorkPlaces == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Previous Work Places',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...List.generate(_numberOfPreviousWorkPlaces, (index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Previous Work Place ${index + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              CustomFormField(
                label: 'Company/Institution',
                hintText: 'Enter company or institution name',
                controller: _previousWorkPlacesControllers[index]['company_instituition']!,
                filled: true,
                isImportant: true,
                validator: _validateRequired,
              ),
              const SizedBox(height: 8),
              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Job Title',
                  hintText: 'Enter job title',
                  controller: _previousWorkPlacesControllers[index]['job_title']!,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
                CustomFormField(
                  label: 'Date',
                  hintText: 'Select date',
                  controller: _previousWorkPlacesControllers[index]['date']!,
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
                      _previousWorkPlacesControllers[index]['date']!.text =
                          date.toString().split(' ')[0];
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hintText,
    required List<String> items,
    required TextEditingController controller,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              Text(label, style: const TextStyle(color: Colors.grey)),
              if (isRequired) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ],
            ],
          ),
        ),
        DropdownButtonFormField<String>(
          initialValue: _selectedEmploymentStatus,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 14,
            ),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.black12),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Color(0xffFDB35C)),
              borderRadius: BorderRadius.circular(15),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Color(0xffFDB35C)),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Color(0xffFDB35C)),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedEmploymentStatus = value;
                controller.text = value;
              });
            }
          },
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }
              : null,
        ),
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
                _buildDropdownField(
                  label: 'Employment Status',
                  hintText: 'Select employment status',
                  items: ['Part Time', 'Permanent'],
                  controller: _employmentStatusController,
                  isRequired: true,
                ),
              ),

              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Number of Previous Work Place',
                  hintText: 'Enter number',
                  controller: _numberOfPreviousWorkPlaceController,
                  filled: true,
                  keyboardType: TextInputType.number,
                  onChanged: _handleNumberOfPreviousWorkPlacesChange,
                ),
                CustomFormField(
                  label: 'Immediate Supervisor',
                  hintText: 'Enter supervisor name',
                  controller: _immediateSupervisorController,
                  filled: true,
                ),
              ),

              // Dynamic previous workplaces fields
              _buildPreviousWorkPlacesSection(),

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
