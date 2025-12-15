import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/custom_form_field.dart';

class RefereesData extends StatefulWidget {
  final void Function(Map<String, dynamic> Function())? onFormReady;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final bool isLoading;
  final Map<String, dynamic>? initialData;

  const RefereesData({
    super.key,
    this.onFormReady,
    this.onNext,
    this.onPrevious,
    this.isLoading = false,
    this.initialData,
  });

  @override
  State<RefereesData> createState() => _RefereesDataState();
}

class _RefereesDataState extends State<RefereesData> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for main fields
  final TextEditingController _numberOfRefereesController =
      TextEditingController();

  // Dynamic list for referees
  List<Map<String, TextEditingController>> _refereesControllers = [];
  int _numberOfReferees = 0;

  // Validator functions
  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  // Handle number of referees change
  void _handleNumberOfRefereesChange(String value) {
    if (value.isEmpty) {
      setState(() {
        _numberOfReferees = 0;
        _refereesControllers.clear();
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
            content: const Text('Number of referees should be numeric.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _numberOfRefereesController.clear();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Update number of referees and create/remove controllers
    setState(() {
      _numberOfReferees = number;

      // Clear existing controllers
      for (var controllers in _refereesControllers) {
        controllers['name']?.dispose();
        controllers['occupation']?.dispose();
        controllers['address']?.dispose();
      }
      _refereesControllers.clear();

      // Create new controllers
      for (int i = 0; i < number; i++) {
        _refereesControllers.add({
          'name': TextEditingController(),
          'occupation': TextEditingController(),
          'address': TextEditingController(),
        });
      }
    });
  }

  // Get post body
  Map<String, dynamic> getPostBody() {
    List<Map<String, String>> referees = [];
    for (int i = 0; i < _refereesControllers.length; i++) {
      referees.add({
        'name': _refereesControllers[i]['name']?.text ?? '',
        'occupation': _refereesControllers[i]['occupation']?.text ?? '',
        'address': _refereesControllers[i]['address']?.text ?? '',
      });
    }

    return {
      "referees": referees,
    };
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    // Pass the getPostBody method to parent widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onFormReady?.call(getPostBody);
    });
  }

  void _loadInitialData() {
    if (widget.initialData != null) {
      final referees = widget.initialData!['referees'] as List<dynamic>?;
      if (referees != null && referees.isNotEmpty) {
        _numberOfRefereesController.text = referees.length.toString();
        _numberOfReferees = referees.length;

        for (int i = 0; i < referees.length; i++) {
          final referee = referees[i] as Map<String, dynamic>;
          _refereesControllers.add({
            'name': TextEditingController(text: referee['name'] ?? ''),
            'occupation': TextEditingController(text: referee['occupation'] ?? ''),
            'address': TextEditingController(text: referee['address'] ?? ''),
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _numberOfRefereesController.dispose();

    // Dispose referees controllers
    for (var controllers in _refereesControllers) {
      controllers['name']?.dispose();
      controllers['occupation']?.dispose();
      controllers['address']?.dispose();
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

  Widget _buildRefereesSection() {
    if (_numberOfReferees == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Referees',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...List.generate(_numberOfReferees, (index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Referee ${index + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Name',
                  hintText: 'Enter referee name',
                  controller: _refereesControllers[index]['name']!,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
                CustomFormField(
                  label: 'Occupation',
                  hintText: 'Enter occupation',
                  controller: _refereesControllers[index]['occupation']!,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
              ),
              const SizedBox(height: 8),
              CustomFormField(
                label: 'Address',
                hintText: 'Enter address',
                controller: _refereesControllers[index]['address']!,
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
              // Referees Information Section
              const Text(
                'Referees Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              CustomFormField(
                label: 'Number of Referees',
                hintText: 'Enter number of referees',
                controller: _numberOfRefereesController,
                filled: true,
                isImportant: true,
                keyboardType: TextInputType.number,
                validator: _validateRequired,
                onChanged: _handleNumberOfRefereesChange,
              ),

              // Dynamic referees fields
              _buildRefereesSection(),

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
