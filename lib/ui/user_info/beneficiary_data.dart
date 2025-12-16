import 'package:flutter/material.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/services/app_service.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/custom_form_field.dart';

class BeneficiaryData extends StatefulWidget {
  final void Function(Map<String, dynamic> Function(), bool Function())?
      onFormReady;
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
  final appService = locator<AppService>();
  bool _hasDataChanged = false;

  // Store original values for comparison
  Map<String, dynamic>? _originalData;

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
        final nameController = TextEditingController();
        final addressController = TextEditingController();
        final relationshipController = TextEditingController();
        final percentageController = TextEditingController();

        // Add listeners to new controllers
        nameController.addListener(() => _checkForChanges());
        addressController.addListener(() => _checkForChanges());
        relationshipController.addListener(() => _checkForChanges());
        percentageController.addListener(() => _checkForChanges());

        _beneficiariesControllers.add({
          'name': nameController,
          'address_telephone_number': addressController,
          'relationship': relationshipController,
          'percentage_of_benefit': percentageController,
        });
      }

      // Check for changes after updating beneficiaries count
      _checkForChanges();
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
    // Prefill form with existing beneficiaries data if available
    _prefillBeneficiariesData();
    // Store original data for comparison
    _storeOriginalData();
    // Add listeners to detect changes
    _addChangeListeners();
    // Pass the getPostBody and shouldSubmitData methods to parent widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onFormReady?.call(getPostBody, shouldSubmitData);
    });
  }

  // Prefill form with existing beneficiaries data
  void _prefillBeneficiariesData() {
    final beneficiaries = appService.currentUser?.beneficiaries;
    if (beneficiaries != null && beneficiaries.isNotEmpty) {
      _numberOfBeneficiariesController.text = beneficiaries.length.toString();
      _numberOfBeneficiaries = beneficiaries.length;

      // Create controllers for each beneficiary
      for (int i = 0; i < beneficiaries.length; i++) {
        _beneficiariesControllers.add({
          'name': TextEditingController(text: beneficiaries[i].name ?? ''),
          'address_telephone_number': TextEditingController(
              text: beneficiaries[i].addressTelephoneNumber ?? ''),
          'relationship':
              TextEditingController(text: beneficiaries[i].relationship ?? ''),
          'percentage_of_benefit': TextEditingController(
              text: beneficiaries[i].percentageOfBenefit?.toString() ?? ''),
        });
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
    _numberOfBeneficiariesController.addListener(listener);

    // Add listeners for beneficiaries controllers
    for (var controllers in _beneficiariesControllers) {
      controllers['name']?.addListener(listener);
      controllers['address_telephone_number']?.addListener(listener);
      controllers['relationship']?.addListener(listener);
      controllers['percentage_of_benefit']?.addListener(listener);
    }
  }

  // Check if data has changed
  void _checkForChanges() {
    if (_originalData == null) return;

    final currentData = getPostBody();
    bool hasChanged = false;

    // Compare beneficiaries array
    final originalBeneficiaries =
        _originalData!['beneficiaries'] as List<Map<String, String>>;
    final currentBeneficiaries =
        currentData['beneficiaries'] as List<Map<String, String>>;

    if (originalBeneficiaries.length != currentBeneficiaries.length) {
      hasChanged = true;
    } else {
      for (int i = 0; i < originalBeneficiaries.length; i++) {
        if (originalBeneficiaries[i]['name'] != currentBeneficiaries[i]['name'] ||
            originalBeneficiaries[i]['address_telephone_number'] !=
                currentBeneficiaries[i]['address_telephone_number'] ||
            originalBeneficiaries[i]['relationship'] !=
                currentBeneficiaries[i]['relationship'] ||
            originalBeneficiaries[i]['percentage_of_benefit'] !=
                currentBeneficiaries[i]['percentage_of_benefit']) {
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
      'shouldSubmitData: beneficiaries exist = ${appService.currentUser?.beneficiaries != null && appService.currentUser!.beneficiaries!.isNotEmpty}, hasDataChanged = $_hasDataChanged',
    );
    // If beneficiaries already exist and nothing changed, skip submission
    if (appService.currentUser?.beneficiaries != null &&
        appService.currentUser!.beneficiaries!.isNotEmpty &&
        !_hasDataChanged) {
      debugPrint('shouldSubmitData: returning false (no changes)');
      return false;
    }
    debugPrint('shouldSubmitData: returning true (should submit)');
    return true;
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
