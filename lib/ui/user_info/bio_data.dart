import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/services/app_service.dart';
import 'package:leave_desk/services/image_compression_service.dart';
import 'package:leave_desk/shared/app_logo.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/custom_form_field.dart';

class BioDataWidget extends StatefulWidget {
  final void Function(Map<String, dynamic> Function(), bool Function())?
  onFormReady;
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
  final appService = locator<AppService>();
  bool _isCompressingImage = false;
  bool _hasDataChanged = false;

  // Store original values for comparison
  Map<String, dynamic>? _originalData;

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
  Map<String, dynamic> getPostBody() {
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
      "image": _selectedImage,
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
      File imageFile = File(image.path);

      // Set compressing state
      setState(() {
        _isCompressingImage = true;
      });

      // Compress image to be within 2MB limit
      File? compressedImage = await ImageCompressionService.compressImage(
        imageFile,
        maxSizeInKB: 2048,
      );

      if (compressedImage != null) {
        setState(() {
          _selectedImage = compressedImage;
          _isCompressingImage = false;
        });

        // Show success message with file size
        int sizeInKB = await compressedImage.length() ~/ 1024;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image compressed successfully (${sizeInKB}KB)'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        setState(() {
          _isCompressingImage = false;
        });

        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Failed to compress image. Please try another image.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Prefill form with existing bio data if available
    _prefillBioData();
    // Store original data for comparison
    _storeOriginalData();
    // Add listeners to detect changes
    _addChangeListeners();
    // Pass the getPostBody and shouldSubmitData methods to parent widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onFormReady?.call(getPostBody, shouldSubmitData);
    });
  }

  // Prefill form with existing bio data
  void _prefillBioData() {
    final bioData = appService.currentUser?.bioData;
    if (bioData != null) {
      _surnameController.text = bioData.surname ?? '';
      _otherNamesController.text = bioData.otherNames ?? '';
      _dateOfBirthController.text = bioData.dateOfBirth ?? '';
      _nationalityController.text = bioData.nationality ?? '';
      _homeTownController.text = bioData.homeTown ?? '';
      _regionController.text = bioData.region ?? '';
      _genderController.text = bioData.gender ?? '';
      _socialSecurityNumberController.text = bioData.socialSecurityNumber ?? '';
      _bankController.text = bioData.bank ?? '';
      _branchNameController.text = bioData.branchName ?? '';
      _accountNameController.text = bioData.accountName ?? '';
      _languagesSpokenController.text =
          bioData.languagesSpoken?.join(', ') ?? '';
      _physicalDisabilityController.text = bioData.physicalDisability ?? '';
      _previousNamesController.text = bioData.previousNames ?? '';
      _houseNumberController.text = bioData.houseNumber ?? '';
      _cityTownController.text = bioData.cityTown ?? '';
      _digitalAddressController.text = bioData.digitalAddress ?? '';
      _streetNameController.text = bioData.streetName ?? '';
      _nearestLandmarkController.text = bioData.nearestLandmark ?? '';
      _postAddressController.text = bioData.postAddress ?? '';
      _emailAddressController.text = bioData.emailAddress ?? '';
      _telephoneController.text = bioData.telephone ?? '';
    }
  }

  // Store original data
  void _storeOriginalData() {
    _originalData = getPostBody();
  }

  // Add change listeners to all controllers
  void _addChangeListeners() {
    void listener() => _checkForChanges();
    _surnameController.addListener(listener);
    _otherNamesController.addListener(listener);
    _dateOfBirthController.addListener(listener);
    _nationalityController.addListener(listener);
    _homeTownController.addListener(listener);
    _regionController.addListener(listener);
    _genderController.addListener(listener);
    _socialSecurityNumberController.addListener(listener);
    _bankController.addListener(listener);
    _branchNameController.addListener(listener);
    _accountNameController.addListener(listener);
    _languagesSpokenController.addListener(listener);
    _physicalDisabilityController.addListener(listener);
    _previousNamesController.addListener(listener);
    _houseNumberController.addListener(listener);
    _cityTownController.addListener(listener);
    _digitalAddressController.addListener(listener);
    _streetNameController.addListener(listener);
    _nearestLandmarkController.addListener(listener);
    _postAddressController.addListener(listener);
    _emailAddressController.addListener(listener);
    _telephoneController.addListener(listener);
  }

  // Check if data has changed
  void _checkForChanges() {
    if (_originalData == null) return;

    final currentData = getPostBody();
    bool hasChanged = false;

    // Compare all text fields
    _originalData!.forEach((key, value) {
      if (key != 'image') {
        // Skip image comparison in text check
        if (currentData[key] != value) {
          hasChanged = true;
        }
      }
    });

    // Check if image has been added/changed
    if (_selectedImage != null && _originalData!['image'] != _selectedImage) {
      hasChanged = true;
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
      'shouldSubmitData: bioData exists = ${appService.currentUser?.bioData != null}, hasDataChanged = $_hasDataChanged',
    );
    // If bio data already exists and nothing changed, skip submission
    if (appService.currentUser?.bioData != null && !_hasDataChanged) {
      debugPrint('shouldSubmitData: returning false (no changes)');
      return false;
    }
    debugPrint('shouldSubmitData: returning true (should submit)');
    return true;
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
                        child: _isCompressingImage
                            ? Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : _selectedImage != null
                            ? Image.file(_selectedImage!, fit: BoxFit.cover)
                            : Image.asset(
                                'assets/icons/avatar.png',
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    if (!_isCompressingImage)
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
                      initialValue: appService.currentUser!.bioData?.gender!
                          .toLowerCase(),
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
                      // ViewModel will check shouldSubmitData() and decide whether to make API call
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
