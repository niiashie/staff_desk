import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/custom_form_field.dart';

class FamilyData extends StatefulWidget {
  final void Function(Map<String, dynamic> Function())? onFormReady;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final bool isLoading;

  const FamilyData({
    super.key,
    this.onFormReady,
    this.onNext,
    this.onPrevious,
    this.isLoading = false,
  });

  @override
  State<FamilyData> createState() => _FamilyDataState();
}

class _FamilyDataState extends State<FamilyData> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for all fields
  final TextEditingController _maritalStatusController =
      TextEditingController();
  final TextEditingController _spouseNameController = TextEditingController();
  final TextEditingController _spouseOccupationController =
      TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _fatherIsDeceasedController =
      TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _motherIsDeceasedController =
      TextEditingController();
  final TextEditingController _numberOfChildrenController =
      TextEditingController();

  // Dynamic list for children
  List<Map<String, TextEditingController>> _childrenControllers = [];
  int _numberOfChildren = 0;

  // Validator functions
  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  // Handle number of children change
  void _handleNumberOfChildrenChange(String value) {
    if (value.isEmpty) {
      setState(() {
        _numberOfChildren = 0;
        _childrenControllers.clear();
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
            content: const Text('Number of children should be numeric.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _numberOfChildrenController.clear();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Update number of children and create/remove controllers
    setState(() {
      _numberOfChildren = number;

      // Clear existing controllers
      for (var controllers in _childrenControllers) {
        controllers['name']?.dispose();
        controllers['dob']?.dispose();
      }
      _childrenControllers.clear();

      // Create new controllers
      for (int i = 0; i < number; i++) {
        _childrenControllers.add({
          'name': TextEditingController(),
          'dob': TextEditingController(),
        });
      }
    });
  }

  // Get post body
  Map<String, dynamic> getPostBody() {
    List<Map<String, String>> children = [];
    for (int i = 0; i < _childrenControllers.length; i++) {
      children.add({
        'name': _childrenControllers[i]['name']?.text ?? '',
        'date_of_birth': _childrenControllers[i]['dob']?.text ?? '',
      });
    }

    return {
      "marital_status": _maritalStatusController.text,
      "spouse_name": _spouseNameController.text,
      "spouse_occupation": _spouseOccupationController.text,
      "father_name": _fatherNameController.text,
      "father_is_deceased": _fatherIsDeceasedController.text,
      "mother_name": _motherNameController.text,
      "mother_is_deceased": _motherIsDeceasedController.text,
      "number_of_children": _numberOfChildrenController.text,
      "children": children,
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
    _maritalStatusController.dispose();
    _spouseNameController.dispose();
    _spouseOccupationController.dispose();
    _fatherNameController.dispose();
    _fatherIsDeceasedController.dispose();
    _motherNameController.dispose();
    _motherIsDeceasedController.dispose();
    _numberOfChildrenController.dispose();

    // Dispose children controllers
    for (var controllers in _childrenControllers) {
      controllers['name']?.dispose();
      controllers['dob']?.dispose();
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
              controller.text = value;
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

  Widget _buildChildrenSection() {
    if (_numberOfChildren == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Children',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...List.generate(_numberOfChildren, (index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Child ${index + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Name of Child',
                  hintText: 'Enter child\'s name',
                  controller: _childrenControllers[index]['name']!,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
                CustomFormField(
                  label: 'Date of Birth',
                  hintText: 'Select date of birth',
                  controller: _childrenControllers[index]['dob']!,
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
                      _childrenControllers[index]['dob']!.text = date
                          .toString()
                          .split(' ')[0];
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
              // Family Information Section
              const Text(
                'Family Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Marital Status',
                  hintText: 'Enter marital status',
                  controller: _maritalStatusController,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
                CustomFormField(
                  label: 'Spouse Name',
                  hintText: 'Enter spouse name',
                  controller: _spouseNameController,
                  filled: true,
                ),
              ),

              CustomFormField(
                label: 'Spouse Occupation',
                hintText: 'Enter spouse occupation',
                controller: _spouseOccupationController,
                filled: true,
              ),

              const SizedBox(height: 24),

              // Parents Information Section
              const Text(
                'Parents Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Father\'s Name',
                  hintText: 'Enter father\'s name',
                  controller: _fatherNameController,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
                _buildDropdownField(
                  label: 'Father Deceased',
                  hintText: 'Select',
                  items: ['Yes', 'No'],
                  controller: _fatherIsDeceasedController,
                  isRequired: true,
                ),
              ),

              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Mother\'s Name',
                  hintText: 'Enter mother\'s name',
                  controller: _motherNameController,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
                _buildDropdownField(
                  label: 'Mother Deceased',
                  hintText: 'Select',
                  items: ['Yes', 'No'],
                  controller: _motherIsDeceasedController,
                  isRequired: true,
                ),
              ),

              const SizedBox(height: 24),

              // Children Section
              const Text(
                'Children Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              CustomFormField(
                label: 'Number of Children',
                hintText: 'Enter number of children',
                controller: _numberOfChildrenController,
                filled: true,
                isImportant: true,
                keyboardType: TextInputType.number,
                validator: _validateRequired,
                onChanged: _handleNumberOfChildrenChange,
              ),

              // Dynamic children fields
              _buildChildrenSection(),

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
