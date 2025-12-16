import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/custom_form_field.dart';

class EmergencyData extends StatefulWidget {
  final void Function(Map<String, dynamic> Function())? onFormReady;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final bool isLoading;
  final Map<String, dynamic>? initialData;

  const EmergencyData({
    super.key,
    this.onFormReady,
    this.onNext,
    this.onPrevious,
    this.isLoading = false,
    this.initialData,
  });

  @override
  State<EmergencyData> createState() => _EmergencyDataState();
}

class _EmergencyDataState extends State<EmergencyData> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for main fields
  final TextEditingController _numberOfEmergenciesController =
      TextEditingController();

  // Dynamic list for emergencies
  List<Map<String, TextEditingController>> _emergenciesControllers = [];
  int _numberOfEmergencies = 0;

  // Validator functions
  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  // Handle number of emergencies change
  void _handleNumberOfEmergenciesChange(String value) {
    if (value.isEmpty) {
      setState(() {
        _numberOfEmergencies = 0;
        _emergenciesControllers.clear();
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
              'Number of emergency contacts should be numeric.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _numberOfEmergenciesController.clear();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Update number of emergencies and create/remove controllers
    setState(() {
      _numberOfEmergencies = number;

      // Clear existing controllers
      for (var controllers in _emergenciesControllers) {
        controllers['name']?.dispose();
        controllers['address']?.dispose();
        controllers['telephone_number']?.dispose();
      }
      _emergenciesControllers.clear();

      // Create new controllers
      for (int i = 0; i < number; i++) {
        _emergenciesControllers.add({
          'name': TextEditingController(),
          'address': TextEditingController(),
          'telephone_number': TextEditingController(),
        });
      }
    });
  }

  // Get post body
  Map<String, dynamic> getPostBody() {
    List<Map<String, String>> emergencies = [];
    for (int i = 0; i < _emergenciesControllers.length; i++) {
      emergencies.add({
        'name': _emergenciesControllers[i]['name']?.text ?? '',
        'address': _emergenciesControllers[i]['address']?.text ?? '',
        'telephone_number':
            _emergenciesControllers[i]['telephone_number']?.text ?? '',
      });
    }

    return {"emergencies": emergencies};
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
      final emergencies = widget.initialData!['emergencies'] as List<dynamic>?;
      if (emergencies != null && emergencies.isNotEmpty) {
        _numberOfEmergenciesController.text = emergencies.length.toString();
        _numberOfEmergencies = emergencies.length;

        for (int i = 0; i < emergencies.length; i++) {
          final emergency = emergencies[i] as Map<String, dynamic>;
          _emergenciesControllers.add({
            'name': TextEditingController(text: emergency['name'] ?? ''),
            'address': TextEditingController(text: emergency['address'] ?? ''),
            'telephone_number': TextEditingController(
              text: emergency['telephone_number'] ?? '',
            ),
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _numberOfEmergenciesController.dispose();

    // Dispose emergencies controllers
    for (var controllers in _emergenciesControllers) {
      controllers['name']?.dispose();
      controllers['address']?.dispose();
      controllers['telephone_number']?.dispose();
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

  Widget _buildEmergenciesSection() {
    if (_numberOfEmergencies == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Emergency Contacts',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...List.generate(_numberOfEmergencies, (index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Emergency Contact ${index + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Name',
                  hintText: 'Enter emergency contact name',
                  controller: _emergenciesControllers[index]['name']!,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
                CustomFormField(
                  label: 'Telephone Number',
                  hintText: 'Enter telephone number',
                  controller:
                      _emergenciesControllers[index]['telephone_number']!,
                  filled: true,
                  isImportant: true,
                  keyboardType: TextInputType.phone,
                  validator: _validateRequired,
                ),
              ),
              const SizedBox(height: 8),
              CustomFormField(
                label: 'Address',
                hintText: 'Enter address',
                controller: _emergenciesControllers[index]['address']!,
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
              // Emergency Contacts Information Section
              const Text(
                'Emergency Contacts Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              CustomFormField(
                label: 'Number of Emergency Contacts',
                hintText: 'Enter number of emergency contacts',
                controller: _numberOfEmergenciesController,
                filled: true,
                isImportant: true,
                keyboardType: TextInputType.number,
                validator: _validateRequired,
                onChanged: _handleNumberOfEmergenciesChange,
              ),

              // Dynamic emergencies fields
              _buildEmergenciesSection(),

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
                          'Finish',
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
