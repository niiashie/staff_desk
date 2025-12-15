import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/custom_form_field.dart';

class BeneficiaryData extends StatefulWidget {
  final void Function(Map<String, dynamic> Function())? onFormReady;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final bool isLoading;
  final Map<String, dynamic>? initialData;

  const BeneficiaryData({
    super.key,
    this.onFormReady,
    this.onNext,
    this.onPrevious,
    this.isLoading = false,
    this.initialData,
  });

  @override
  State<BeneficiaryData> createState() => _BeneficiaryDataState();
}

class _BeneficiaryDataState extends State<BeneficiaryData> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for main fields
  final TextEditingController _numberOfBeneficiariesController =
      TextEditingController();

  // Dynamic list for beneficiaries
  List<Map<String, TextEditingController>> _beneficiariesControllers = [];
  int _numberOfBeneficiaries = 0;

  // Validator functions
  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  // Handle number of beneficiaries change
  void _handleNumberOfBeneficiariesChange(String value) {
    if (value.isEmpty) {
      setState(() {
        _numberOfBeneficiaries = 0;
        _beneficiariesControllers.clear();
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
            content: const Text('Number of beneficiaries should be numeric.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _numberOfBeneficiariesController.clear();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Update number of beneficiaries and create/remove controllers
    setState(() {
      _numberOfBeneficiaries = number;

      // Clear existing controllers
      for (var controllers in _beneficiariesControllers) {
        controllers['name']?.dispose();
        controllers['address_telephone_number']?.dispose();
        controllers['relationship']?.dispose();
        controllers['percentage_of_benefit']?.dispose();
      }
      _beneficiariesControllers.clear();

      // Create new controllers
      for (int i = 0; i < number; i++) {
        _beneficiariesControllers.add({
          'name': TextEditingController(),
          'address_telephone_number': TextEditingController(),
          'relationship': TextEditingController(),
          'percentage_of_benefit': TextEditingController(),
        });
      }
    });
  }

  // Get post body
  Map<String, dynamic> getPostBody() {
    List<Map<String, String>> beneficiaries = [];
    for (int i = 0; i < _beneficiariesControllers.length; i++) {
      beneficiaries.add({
        'name': _beneficiariesControllers[i]['name']?.text ?? '',
        'address_telephone_number':
            _beneficiariesControllers[i]['address_telephone_number']?.text ?? '',
        'relationship': _beneficiariesControllers[i]['relationship']?.text ?? '',
        'percentage_of_benefit':
            _beneficiariesControllers[i]['percentage_of_benefit']?.text ?? '',
      });
    }

    return {
      "beneficiaries": beneficiaries,
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
      final beneficiaries = widget.initialData!['beneficiaries'] as List<dynamic>?;
      if (beneficiaries != null && beneficiaries.isNotEmpty) {
        _numberOfBeneficiariesController.text = beneficiaries.length.toString();
        _numberOfBeneficiaries = beneficiaries.length;

        for (int i = 0; i < beneficiaries.length; i++) {
          final beneficiary = beneficiaries[i] as Map<String, dynamic>;
          _beneficiariesControllers.add({
            'name': TextEditingController(text: beneficiary['name'] ?? ''),
            'address_telephone_number': TextEditingController(text: beneficiary['address_telephone_number'] ?? ''),
            'relationship': TextEditingController(text: beneficiary['relationship'] ?? ''),
            'percentage_of_benefit': TextEditingController(text: beneficiary['percentage_of_benefit'] ?? ''),
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _numberOfBeneficiariesController.dispose();

    // Dispose beneficiaries controllers
    for (var controllers in _beneficiariesControllers) {
      controllers['name']?.dispose();
      controllers['address_telephone_number']?.dispose();
      controllers['relationship']?.dispose();
      controllers['percentage_of_benefit']?.dispose();
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

  Widget _buildBeneficiariesSection() {
    if (_numberOfBeneficiaries == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Beneficiaries',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...List.generate(_numberOfBeneficiaries, (index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Beneficiary ${index + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Name',
                  hintText: 'Enter beneficiary name',
                  controller: _beneficiariesControllers[index]['name']!,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
                CustomFormField(
                  label: 'Address & Telephone Number',
                  hintText: 'Enter address and telephone',
                  controller: _beneficiariesControllers[index]
                      ['address_telephone_number']!,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
              ),
              const SizedBox(height: 8),
              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Relationship',
                  hintText: 'Enter relationship',
                  controller: _beneficiariesControllers[index]['relationship']!,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
                CustomFormField(
                  label: 'Percentage of Benefit',
                  hintText: 'Enter percentage',
                  controller: _beneficiariesControllers[index]
                      ['percentage_of_benefit']!,
                  filled: true,
                  isImportant: true,
                  keyboardType: TextInputType.number,
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
              // Beneficiaries Information Section
              const Text(
                'Beneficiaries Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              CustomFormField(
                label: 'Number of Beneficiaries',
                hintText: 'Enter number of beneficiaries',
                controller: _numberOfBeneficiariesController,
                filled: true,
                isImportant: true,
                keyboardType: TextInputType.number,
                validator: _validateRequired,
                onChanged: _handleNumberOfBeneficiariesChange,
              ),

              // Dynamic beneficiaries fields
              _buildBeneficiariesSection(),

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
