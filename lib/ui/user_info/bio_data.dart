import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/shared/app_logo.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/custom_form_field.dart';
import 'package:leave_desk/shared/step_progress_indicator.dart';

class BioDataWidget extends StatefulWidget {
  final void Function(Map<String, String> Function())? onFormReady;
  final VoidCallback? onNext;
  final bool isLoading;

  const BioDataWidget({
    super.key,
    this.onFormReady,
    this.onNext,
    this.isLoading = false,
  });

  @override
  State<BioDataWidget> createState() => _BioDataWidgetState();
}

class _BioDataWidgetState extends State<BioDataWidget> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  // Controllers for all fields
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _otherNamesController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _homeTownController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _socialSecurityNumberController =
      TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _languagesSpokenController =
      TextEditingController();
  final TextEditingController _physicalDisabilityController =
      TextEditingController();
  final TextEditingController _previousNamesController =
      TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _cityTownController = TextEditingController();
  final TextEditingController _digitalAddressController =
      TextEditingController();
  final TextEditingController _streetNameController = TextEditingController();
  final TextEditingController _nearestLandmarkController =
      TextEditingController();
  final TextEditingController _postAddressController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();

  // Validator functions
  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  // Get post body
  Map<String, String> getPostBody() {
    return {
      "surname": _surnameController.text,
      "other_names": _otherNamesController.text,
      "date_of_birth": _dateOfBirthController.text,
      "nationality": _nationalityController.text,
      "home_town": _homeTownController.text,
      "region": _regionController.text,
      "gender": _genderController.text,
      "social_security_number": _socialSecurityNumberController.text,
      "bank": _bankController.text,
      "branch_name": _branchNameController.text,
      "account_name": _accountNameController.text,
      "languages_spoken": _languagesSpokenController.text,
      "physical_disability": _physicalDisabilityController.text,
      "image": _selectedImage?.path ?? "",
      "previous_names": _previousNamesController.text,
      "house_number": _houseNumberController.text,
      "city_town": _cityTownController.text,
      "digital_address": _digitalAddressController.text,
      "street_name": _streetNameController.text,
      "nearest_landmark": _nearestLandmarkController.text,
      "post_address": _postAddressController.text,
      "email_address": _emailAddressController.text,
      "telephone": _telephoneController.text,
    };
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
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
    _surnameController.dispose();
    _otherNamesController.dispose();
    _dateOfBirthController.dispose();
    _nationalityController.dispose();
    _homeTownController.dispose();
    _regionController.dispose();
    _genderController.dispose();
    _socialSecurityNumberController.dispose();
    _bankController.dispose();
    _branchNameController.dispose();
    _accountNameController.dispose();
    _languagesSpokenController.dispose();
    _physicalDisabilityController.dispose();
    _previousNamesController.dispose();
    _houseNumberController.dispose();
    _cityTownController.dispose();
    _digitalAddressController.dispose();
    _streetNameController.dispose();
    _nearestLandmarkController.dispose();
    _postAddressController.dispose();
    _emailAddressController.dispose();
    _telephoneController.dispose();
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
              // Profile Image Section
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey, width: 2),
                      ),
                      child: ClipOval(
                        child: _selectedImage != null
                            ? Image.file(_selectedImage!, fit: BoxFit.cover)
                            : Image.asset(
                                'assets/icons/avatar.png',
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Personal Information Section
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Surname',
                  hintText: 'Enter your surname',
                  controller: _surnameController,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
                CustomFormField(
                  label: 'Other Names',
                  hintText: 'Enter your other names',
                  controller: _otherNamesController,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
              ),

              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Previous Names',
                  hintText: 'Enter any previous names',
                  controller: _previousNamesController,
                  filled: true,
                ),
                CustomFormField(
                  label: 'Date of Birth',
                  hintText: 'Select date of birth',
                  controller: _dateOfBirthController,
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
                      _dateOfBirthController.text = date.toString().split(
                        ' ',
                      )[0];
                    }
                  },
                ),
              ),

              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Nationality',
                  hintText: 'Enter your nationality',
                  controller: _nationalityController,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: [
                          Text('Gender', style: TextStyle(color: Colors.grey)),
                          SizedBox(width: 4),
                          Text(
                            '*',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Select gender',
                        hintStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 17,
                          vertical: 14,
                        ),
                        filled: true,

                        fillColor: const Color(0xFFF9FAFB),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1,
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xffFDB35C),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xffFDB35C),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xffFDB35C),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'male', child: Text('Male')),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text('Female'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          _genderController.text = value;
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Home Town',
                  hintText: 'Enter your home town',
                  controller: _homeTownController,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
                CustomFormField(
                  label: 'Region',
                  hintText: 'Enter your region',
                  controller: _regionController,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
              ),

              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Social Security Number',
                  hintText: 'Enter SSN',
                  controller: _socialSecurityNumberController,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
                CustomFormField(
                  label: 'Languages Spoken',
                  hintText: 'Enter languages spoken',
                  controller: _languagesSpokenController,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
              ),

              CustomFormField(
                label: 'Physical Disability',
                hintText: 'Enter any physical disability',
                controller: _physicalDisabilityController,
                filled: true,
                isImportant: true,
                validator: _validateRequired,
              ),

              const SizedBox(height: 24),

              // Contact Information Section
              const Text(
                'Contact Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Email Address',
                  hintText: 'Enter your email',
                  controller: _emailAddressController,
                  filled: true,
                  keyboardType: TextInputType.emailAddress,
                  isImportant: true,
                  validator: _validateEmail,
                ),
                CustomFormField(
                  label: 'Telephone',
                  hintText: 'Enter your phone number',
                  controller: _telephoneController,
                  filled: true,
                  keyboardType: TextInputType.phone,
                  isImportant: true,
                  validator: _validateRequired,
                ),
              ),

              _buildTwoColumnRow(
                CustomFormField(
                  label: 'House Number',
                  hintText: 'Enter house number',
                  controller: _houseNumberController,
                  filled: true,
                ),
                CustomFormField(
                  label: 'Street Name',
                  hintText: 'Enter street name',
                  controller: _streetNameController,
                  filled: true,
                ),
              ),

              _buildTwoColumnRow(
                CustomFormField(
                  label: 'City/Town',
                  hintText: 'Enter city or town',
                  controller: _cityTownController,
                  filled: true,
                ),
                CustomFormField(
                  label: 'Digital Address',
                  hintText: 'Enter digital address',
                  controller: _digitalAddressController,
                  filled: true,
                ),
              ),

              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Nearest Landmark',
                  hintText: 'Enter nearest landmark',
                  controller: _nearestLandmarkController,
                  filled: true,
                ),
                CustomFormField(
                  label: 'Post Address',
                  hintText: 'Enter postal address',
                  controller: _postAddressController,
                  filled: true,
                ),
              ),

              const SizedBox(height: 24),

              // Banking Information Section
              const Text(
                'Banking Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildTwoColumnRow(
                CustomFormField(
                  label: 'Bank',
                  hintText: 'Enter your bank name',
                  controller: _bankController,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
                CustomFormField(
                  label: 'Branch Name',
                  hintText: 'Enter branch name',
                  controller: _branchNameController,
                  filled: true,
                  isImportant: true,
                  validator: _validateRequired,
                ),
              ),

              CustomFormField(
                label: 'Account Name',
                hintText: 'Enter account name',
                controller: _accountNameController,
                filled: true,
                isImportant: true,
                validator: _validateRequired,
              ),

              const SizedBox(height: 32),

              // Next Button
              Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.chevron_right, color: Colors.white, size: 24),
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
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
