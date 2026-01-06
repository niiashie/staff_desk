import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/models/user.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/custom_form_field.dart';

enum EditCategory {
  bioData,
  employmentRecord,
  familyData,
  educationTraining,
  emergencyContacts,
  beneficiaries,
  referees,
}

class ChildFormData {
  final TextEditingController nameController;
  final TextEditingController dobController;
  final int? id;

  ChildFormData({
    required this.nameController,
    required this.dobController,
    this.id,
  });
}

class AcademicQualificationFormData {
  final TextEditingController qualificationController;
  final TextEditingController institutionController;
  final TextEditingController yearController;
  final int? id;

  AcademicQualificationFormData({
    required this.qualificationController,
    required this.institutionController,
    required this.yearController,
    this.id,
  });
}

class TrainingFormData {
  final TextEditingController courseController;
  final TextEditingController institutionController;
  final TextEditingController yearController;
  final TextEditingController locationController;
  final int? id;

  TrainingFormData({
    required this.courseController,
    required this.institutionController,
    required this.yearController,
    required this.locationController,
    this.id,
  });
}

class EmergencyContactFormData {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController telephoneController;
  final int? id;

  EmergencyContactFormData({
    required this.nameController,
    required this.addressController,
    required this.telephoneController,
    this.id,
  });
}

class BeneficiaryFormData {
  final TextEditingController nameController;
  final TextEditingController addressTelephoneController;
  final TextEditingController relationshipController;
  final TextEditingController percentageController;
  final int? id;

  BeneficiaryFormData({
    required this.nameController,
    required this.addressTelephoneController,
    required this.relationshipController,
    required this.percentageController,
    this.id,
  });
}

class RefereeFormData {
  final TextEditingController nameController;
  final TextEditingController occupationController;
  final TextEditingController addressController;
  final int? id;

  RefereeFormData({
    required this.nameController,
    required this.occupationController,
    required this.addressController,
    this.id,
  });
}

class EditStaffInfoView extends StatefulWidget {
  final User? user;
  final EditCategory? category;

  const EditStaffInfoView({super.key, this.user, this.category});

  @override
  State<EditStaffInfoView> createState() => _EditStaffInfoViewState();
}

class _EditStaffInfoViewState extends State<EditStaffInfoView> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String get _categoryTitle {
    switch (widget.category) {
      case EditCategory.bioData:
        return 'Personal Information';
      case EditCategory.employmentRecord:
        return 'Employment Record';
      case EditCategory.familyData:
        return 'Family Information';
      case EditCategory.educationTraining:
        return 'Education & Training';
      case EditCategory.emergencyContacts:
        return 'Emergency Contacts';
      case EditCategory.beneficiaries:
        return 'Beneficiaries';
      case EditCategory.referees:
        return 'Referees';
      case null:
        return 'Edit Information';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show error if user or category is null
    if (widget.user == null || widget.category == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text('User and category are required')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              _categoryTitle,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                'Edit',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            constraints: BoxConstraints(maxWidth: 900),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCategoryForm(),
                  SizedBox(height: 30),
                  Center(
                    child: CustomButton(
                      title: Text(
                        _isLoading ? 'Updating...' : 'Update Information',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ontap: _isLoading ? null : _handleSubmit,
                      isLoading: _isLoading,
                      color: AppColors.primaryColor,
                      width: 300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryForm() {
    switch (widget.category) {
      case EditCategory.bioData:
        return _buildBioDataForm();
      case EditCategory.employmentRecord:
        return _buildEmploymentRecordForm();
      case EditCategory.familyData:
        return _buildFamilyDataForm();
      case EditCategory.educationTraining:
        return _buildEducationTrainingForm();
      case EditCategory.emergencyContacts:
        return _buildEmergencyContactsForm();
      case EditCategory.beneficiaries:
        return _buildBeneficiariesForm();
      case EditCategory.referees:
        return _buildRefereesForm();
      case null:
        return SizedBox();
    }
  }

  // Bio Data Form
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _otherNamesController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _homeTownController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _cityTownController = TextEditingController();
  final TextEditingController _digitalAddressController =
      TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _streetNameController = TextEditingController();
  final TextEditingController _postAddressController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _socialSecurityNumberController =
      TextEditingController();
  final TextEditingController _languagesSpokenController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (widget.user == null || widget.category == null) return;

    if (widget.category == EditCategory.bioData &&
        widget.user!.bioData != null) {
      final bioData = widget.user!.bioData!;
      _surnameController.text = bioData.surname ?? '';
      _otherNamesController.text = bioData.otherNames ?? '';
      _dateOfBirthController.text = bioData.dateOfBirth ?? '';
      _nationalityController.text = bioData.nationality ?? '';
      _homeTownController.text = bioData.homeTown ?? '';
      _regionController.text = bioData.region ?? '';
      _genderController.text = bioData.gender ?? '';
      _emailAddressController.text = bioData.emailAddress ?? '';
      _telephoneController.text = bioData.telephone ?? '';
      _cityTownController.text = bioData.cityTown ?? '';
      _digitalAddressController.text = bioData.digitalAddress ?? '';
      _houseNumberController.text = bioData.houseNumber ?? '';
      _streetNameController.text = bioData.streetName ?? '';
      _postAddressController.text = bioData.postAddress ?? '';
      _bankController.text = bioData.bank ?? '';
      _accountNameController.text = bioData.accountName ?? '';
      _socialSecurityNumberController.text = bioData.socialSecurityNumber ?? '';
      _languagesSpokenController.text =
          bioData.languagesSpoken?.join(', ') ?? '';
    } else if (widget.category == EditCategory.employmentRecord &&
        widget.user!.employmentRecord != null) {
      final employment = widget.user!.employmentRecord!;
      _presentJobTitleController.text = employment.presentJobTitle ?? '';
      _employmentStatusController.text = employment.employmentStatus ?? '';
      _dateOfEmploymentController.text = employment.dateOfEmployment ?? '';
      _probationPeriodController.text = employment.probationPeriod ?? '';
      _immediateSupervisorController.text =
          employment.immediateSupervisor ?? '';
      _careerObjectivesController.text = employment.careerObjects ?? '';
    } else if (widget.category == EditCategory.familyData &&
        widget.user!.familyData != null) {
      final familyData = widget.user!.familyData!;
      _maritalStatusController.text = familyData.maritalStatus ?? '';
      _spouseNameController.text = familyData.spouseName ?? '';
      _spouseOccupationController.text = familyData.spouseOccupation ?? '';
      _fatherNameController.text = familyData.fatherName ?? '';
      _motherNameController.text = familyData.motherName ?? '';
      _numberOfChildrenController.text = familyData.numberOfChildren ?? '';

      // Initialize children
      if (familyData.children != null) {
        _children = familyData.children!.map((child) {
          return ChildFormData(
            nameController: TextEditingController(text: child.name ?? ''),
            dobController: TextEditingController(text: child.dateOfBirth ?? ''),
            id: child.id,
          );
        }).toList();
      }
    } else if (widget.category == EditCategory.educationTraining &&
        widget.user!.educationTraining != null) {
      final education = widget.user!.educationTraining!;
      _hobbiesController.text = education.hobbiesSpecialInterest ?? '';

      // Initialize academic qualifications
      if (education.academicQualifications != null) {
        _academicQualifications = education.academicQualifications!.map((qual) {
          return AcademicQualificationFormData(
            qualificationController: TextEditingController(
              text: qual.qualification ?? '',
            ),
            institutionController: TextEditingController(
              text: qual.institution ?? '',
            ),
            yearController: TextEditingController(text: qual.year ?? ''),
            id: qual.id,
          );
        }).toList();
      }

      // Initialize trainings
      if (education.trainings != null) {
        _trainings = education.trainings!.map((training) {
          return TrainingFormData(
            courseController: TextEditingController(
              text: training.course ?? '',
            ),
            institutionController: TextEditingController(
              text: training.institution ?? '',
            ),
            yearController: TextEditingController(text: training.year ?? ''),
            locationController: TextEditingController(
              text: training.location ?? '',
            ),
            id: training.id,
          );
        }).toList();
      }
    } else if (widget.category == EditCategory.emergencyContacts &&
        widget.user!.emergencies != null) {
      _emergencyContacts = widget.user!.emergencies!.map((contact) {
        return EmergencyContactFormData(
          nameController: TextEditingController(text: contact.name ?? ''),
          addressController: TextEditingController(text: contact.address ?? ''),
          telephoneController: TextEditingController(
            text: contact.telephoneNumber ?? '',
          ),
          id: contact.id,
        );
      }).toList();
    } else if (widget.category == EditCategory.beneficiaries &&
        widget.user!.beneficiaries != null) {
      _beneficiaries = widget.user!.beneficiaries!.map((beneficiary) {
        return BeneficiaryFormData(
          nameController: TextEditingController(text: beneficiary.name ?? ''),
          addressTelephoneController: TextEditingController(
            text: beneficiary.addressTelephoneNumber ?? '',
          ),
          relationshipController: TextEditingController(
            text: beneficiary.relationship ?? '',
          ),
          percentageController: TextEditingController(
            text: beneficiary.percentageOfBenefit ?? '',
          ),
          id: beneficiary.id,
        );
      }).toList();
    } else if (widget.category == EditCategory.referees &&
        widget.user!.referees != null) {
      _referees = widget.user!.referees!.map((referee) {
        return RefereeFormData(
          nameController: TextEditingController(text: referee.name ?? ''),
          occupationController: TextEditingController(
            text: referee.occupation ?? '',
          ),
          addressController: TextEditingController(text: referee.address ?? ''),
          id: referee.id,
        );
      }).toList();
    }
  }

  Widget _buildBioDataForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Personal Details', Icons.person),
        _buildTwoColumnRow(
          _buildFormField(
            'Surname',
            _surnameController,
            validator: _validateRequired,
          ),
          _buildFormField(
            'Other Names',
            _otherNamesController,
            validator: _validateRequired,
          ),
        ),
        _buildTwoColumnRow(
          _buildFormField(
            'Date of Birth',
            _dateOfBirthController,
            validator: _validateRequired,
            hint: 'YYYY-MM-DD',
          ),
          _buildFormField(
            'Gender',
            _genderController,
            validator: _validateRequired,
          ),
        ),
        _buildTwoColumnRow(
          _buildFormField(
            'Nationality',
            _nationalityController,
            validator: _validateRequired,
          ),
          _buildFormField('Home Town', _homeTownController),
        ),
        _buildTwoColumnRow(
          _buildFormField('Region', _regionController),
          SizedBox(),
        ),
        SizedBox(height: 20),
        _buildSectionHeader('Contact Information', Icons.contact_mail),
        _buildTwoColumnRow(
          _buildFormField(
            'Email Address',
            _emailAddressController,
            validator: _validateEmail,
          ),
          _buildFormField(
            'Telephone',
            _telephoneController,
            validator: _validateRequired,
          ),
        ),
        _buildTwoColumnRow(
          _buildFormField('City/Town', _cityTownController),
          _buildFormField('Digital Address', _digitalAddressController),
        ),
        _buildTwoColumnRow(
          _buildFormField('House Number', _houseNumberController),
          _buildFormField('Street Name', _streetNameController),
        ),
        _buildTwoColumnRow(
          _buildFormField('Post Address', _postAddressController),
          SizedBox(),
        ),
        SizedBox(height: 20),
        _buildSectionHeader('Banking Information', Icons.account_balance),
        _buildTwoColumnRow(
          _buildFormField('Bank', _bankController),
          _buildFormField('Account Name', _accountNameController),
        ),
        _buildTwoColumnRow(
          _buildFormField(
            'Social Security Number',
            _socialSecurityNumberController,
          ),
          SizedBox(),
        ),
        SizedBox(height: 20),
        _buildSectionHeader('Other Information', Icons.info_outline),
        _buildTwoColumnRow(
          _buildFormField(
            'Languages Spoken (comma separated)',
            _languagesSpokenController,
          ),
          SizedBox(),
        ),
      ],
    );
  }

  // Employment Record Form
  final TextEditingController _presentJobTitleController =
      TextEditingController();
  final TextEditingController _employmentStatusController =
      TextEditingController();
  final TextEditingController _dateOfEmploymentController =
      TextEditingController();
  final TextEditingController _probationPeriodController =
      TextEditingController();
  final TextEditingController _immediateSupervisorController =
      TextEditingController();
  final TextEditingController _careerObjectivesController =
      TextEditingController();

  Widget _buildEmploymentRecordForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Current Employment', Icons.work),
        _buildTwoColumnRow(
          _buildFormField(
            'Job Title',
            _presentJobTitleController,
            validator: _validateRequired,
          ),
          _buildFormField(
            'Employment Status',
            _employmentStatusController,
            validator: _validateRequired,
          ),
        ),
        _buildTwoColumnRow(
          _buildFormField(
            'Date of Employment',
            _dateOfEmploymentController,
            hint: 'YYYY-MM-DD',
          ),
          _buildFormField('Probation Period', _probationPeriodController),
        ),
        _buildTwoColumnRow(
          _buildFormField(
            'Immediate Supervisor',
            _immediateSupervisorController,
          ),
          SizedBox(),
        ),
        _buildFormField(
          'Career Objectives',
          _careerObjectivesController,
          maxLines: 4,
        ),
      ],
    );
  }

  // Family Data Form
  final TextEditingController _maritalStatusController =
      TextEditingController();
  final TextEditingController _spouseNameController = TextEditingController();
  final TextEditingController _spouseOccupationController =
      TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _numberOfChildrenController =
      TextEditingController();

  // Children list
  List<ChildFormData> _children = [];

  // Education & Training lists
  List<AcademicQualificationFormData> _academicQualifications = [];
  List<TrainingFormData> _trainings = [];
  final TextEditingController _hobbiesController = TextEditingController();

  // Emergency contacts, beneficiaries, referees lists
  List<EmergencyContactFormData> _emergencyContacts = [];
  List<BeneficiaryFormData> _beneficiaries = [];
  List<RefereeFormData> _referees = [];

  Widget _buildFamilyDataForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Marital Information', Icons.favorite),
        _buildTwoColumnRow(
          _buildFormField(
            'Marital Status',
            _maritalStatusController,
            validator: _validateRequired,
          ),
          _buildFormField('Spouse Name', _spouseNameController),
        ),
        _buildTwoColumnRow(
          _buildFormField('Spouse Occupation', _spouseOccupationController),
          SizedBox(),
        ),
        SizedBox(height: 20),
        _buildSectionHeader('Parents Information', Icons.people),
        _buildTwoColumnRow(
          _buildFormField('Father Name', _fatherNameController),
          _buildFormField('Mother Name', _motherNameController),
        ),
        _buildTwoColumnRow(
          _buildFormField('Number of Children', _numberOfChildrenController),
          SizedBox(),
        ),
        SizedBox(height: 20),
        _buildSectionHeader('Children Information', Icons.child_care),
        ..._children.asMap().entries.map((entry) {
          final index = entry.key;
          final child = entry.value;
          return _buildChildCard(child, index);
        }),
        SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _addChild,
          icon: Icon(Icons.add, color: AppColors.primaryColor),
          label: Text(
            'Add Child',
            style: TextStyle(color: AppColors.primaryColor),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.primaryColor),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildChildCard(ChildFormData child, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.pink.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Child ${index + 1}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.pink.shade700,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeChild(index),
                  tooltip: 'Remove Child',
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildTwoColumnRow(
              _buildFormField(
                'Child Name',
                child.nameController,
                validator: _validateRequired,
              ),
              _buildFormField(
                'Date of Birth',
                child.dobController,
                validator: _validateRequired,
                hint: 'YYYY-MM-DD',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addChild() {
    setState(() {
      _children.add(
        ChildFormData(
          nameController: TextEditingController(),
          dobController: TextEditingController(),
        ),
      );
    });
  }

  void _removeChild(int index) {
    setState(() {
      _children[index].nameController.dispose();
      _children[index].dobController.dispose();
      _children.removeAt(index);
    });
  }

  Widget _buildEducationTrainingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Academic Qualifications', Icons.school),
        ..._academicQualifications.asMap().entries.map((entry) {
          final index = entry.key;
          final qualification = entry.value;
          return _buildAcademicQualificationCard(qualification, index);
        }),
        SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _addAcademicQualification,
          icon: Icon(Icons.add, color: AppColors.primaryColor),
          label: Text(
            'Add Academic Qualification',
            style: TextStyle(color: AppColors.primaryColor),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.primaryColor),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        SizedBox(height: 30),
        _buildSectionHeader('Professional Training', Icons.workspace_premium),
        ..._trainings.asMap().entries.map((entry) {
          final index = entry.key;
          final training = entry.value;
          return _buildTrainingCard(training, index);
        }),
        SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _addTraining,
          icon: Icon(Icons.add, color: AppColors.primaryColor),
          label: Text(
            'Add Training',
            style: TextStyle(color: AppColors.primaryColor),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.primaryColor),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        SizedBox(height: 30),
        _buildSectionHeader('Other Information', Icons.interests),
        _buildFormField(
          'Hobbies & Special Interests',
          _hobbiesController,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildAcademicQualificationCard(
    AcademicQualificationFormData qualification,
    int index,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.teal.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Academic Qualification ${index + 1}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal.shade700,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeAcademicQualification(index),
                  tooltip: 'Remove Qualification',
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildTwoColumnRow(
              _buildFormField(
                'Qualification',
                qualification.qualificationController,
                validator: _validateRequired,
              ),
              _buildFormField(
                'Institution',
                qualification.institutionController,
                validator: _validateRequired,
              ),
            ),
            _buildTwoColumnRow(
              _buildFormField(
                'Year',
                qualification.yearController,
                validator: _validateRequired,
              ),
              SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingCard(TrainingFormData training, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.teal.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Training ${index + 1}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal.shade700,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeTraining(index),
                  tooltip: 'Remove Training',
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildTwoColumnRow(
              _buildFormField(
                'Course/Program',
                training.courseController,
                validator: _validateRequired,
              ),
              _buildFormField(
                'Institution',
                training.institutionController,
                validator: _validateRequired,
              ),
            ),
            _buildTwoColumnRow(
              _buildFormField(
                'Year',
                training.yearController,
                validator: _validateRequired,
              ),
              _buildFormField('Location', training.locationController),
            ),
          ],
        ),
      ),
    );
  }

  void _addAcademicQualification() {
    setState(() {
      _academicQualifications.add(
        AcademicQualificationFormData(
          qualificationController: TextEditingController(),
          institutionController: TextEditingController(),
          yearController: TextEditingController(),
        ),
      );
    });
  }

  void _removeAcademicQualification(int index) {
    setState(() {
      _academicQualifications[index].qualificationController.dispose();
      _academicQualifications[index].institutionController.dispose();
      _academicQualifications[index].yearController.dispose();
      _academicQualifications.removeAt(index);
    });
  }

  void _addTraining() {
    setState(() {
      _trainings.add(
        TrainingFormData(
          courseController: TextEditingController(),
          institutionController: TextEditingController(),
          yearController: TextEditingController(),
          locationController: TextEditingController(),
        ),
      );
    });
  }

  void _removeTraining(int index) {
    setState(() {
      _trainings[index].courseController.dispose();
      _trainings[index].institutionController.dispose();
      _trainings[index].yearController.dispose();
      _trainings[index].locationController.dispose();
      _trainings.removeAt(index);
    });
  }

  Widget _buildEmergencyContactsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Emergency Contacts', Icons.emergency),
        ..._emergencyContacts.asMap().entries.map((entry) {
          final index = entry.key;
          final contact = entry.value;
          return _buildEmergencyContactCard(contact, index);
        }),
        SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _addEmergencyContact,
          icon: Icon(Icons.add, color: AppColors.primaryColor),
          label: Text(
            'Add Emergency Contact',
            style: TextStyle(color: AppColors.primaryColor),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.primaryColor),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildBeneficiariesForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Beneficiaries', Icons.people_outline),
        ..._beneficiaries.asMap().entries.map((entry) {
          final index = entry.key;
          final beneficiary = entry.value;
          return _buildBeneficiaryCard(beneficiary, index);
        }),
        SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _addBeneficiary,
          icon: Icon(Icons.add, color: AppColors.primaryColor),
          label: Text(
            'Add Beneficiary',
            style: TextStyle(color: AppColors.primaryColor),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.primaryColor),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildRefereesForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Referees', Icons.supervisor_account),
        ..._referees.asMap().entries.map((entry) {
          final index = entry.key;
          final referee = entry.value;
          return _buildRefereeCard(referee, index);
        }),
        SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _addReferee,
          icon: Icon(Icons.add, color: AppColors.primaryColor),
          label: Text(
            'Add Referee',
            style: TextStyle(color: AppColors.primaryColor),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.primaryColor),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyContactCard(
    EmergencyContactFormData contact,
    int index,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Emergency Contact ${index + 1}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeEmergencyContact(index),
                  tooltip: 'Remove Contact',
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildTwoColumnRow(
              _buildFormField(
                'Name',
                contact.nameController,
                validator: _validateRequired,
              ),
              _buildFormField(
                'Telephone',
                contact.telephoneController,
                validator: _validateRequired,
              ),
            ),
            _buildFormField(
              'Address',
              contact.addressController,
              validator: _validateRequired,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBeneficiaryCard(BeneficiaryFormData beneficiary, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Beneficiary ${index + 1}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeBeneficiary(index),
                  tooltip: 'Remove Beneficiary',
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildTwoColumnRow(
              _buildFormField(
                'Name',
                beneficiary.nameController,
                validator: _validateRequired,
              ),
              _buildFormField(
                'Relationship',
                beneficiary.relationshipController,
                validator: _validateRequired,
              ),
            ),
            _buildTwoColumnRow(
              _buildFormField(
                'Address/Telephone',
                beneficiary.addressTelephoneController,
                validator: _validateRequired,
              ),
              _buildFormField(
                'Percentage of Benefit (%)',
                beneficiary.percentageController,
                validator: _validateRequired,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRefereeCard(RefereeFormData referee, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.indigo.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Referee ${index + 1}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.indigo.shade700,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeReferee(index),
                  tooltip: 'Remove Referee',
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildTwoColumnRow(
              _buildFormField(
                'Name',
                referee.nameController,
                validator: _validateRequired,
              ),
              _buildFormField(
                'Occupation',
                referee.occupationController,
                validator: _validateRequired,
              ),
            ),
            _buildFormField(
              'Address',
              referee.addressController,
              validator: _validateRequired,
            ),
          ],
        ),
      ),
    );
  }

  void _addEmergencyContact() {
    setState(() {
      _emergencyContacts.add(
        EmergencyContactFormData(
          nameController: TextEditingController(),
          addressController: TextEditingController(),
          telephoneController: TextEditingController(),
        ),
      );
    });
  }

  void _removeEmergencyContact(int index) {
    setState(() {
      _emergencyContacts[index].nameController.dispose();
      _emergencyContacts[index].addressController.dispose();
      _emergencyContacts[index].telephoneController.dispose();
      _emergencyContacts.removeAt(index);
    });
  }

  void _addBeneficiary() {
    setState(() {
      _beneficiaries.add(
        BeneficiaryFormData(
          nameController: TextEditingController(),
          addressTelephoneController: TextEditingController(),
          relationshipController: TextEditingController(),
          percentageController: TextEditingController(),
        ),
      );
    });
  }

  void _removeBeneficiary(int index) {
    setState(() {
      _beneficiaries[index].nameController.dispose();
      _beneficiaries[index].addressTelephoneController.dispose();
      _beneficiaries[index].relationshipController.dispose();
      _beneficiaries[index].percentageController.dispose();
      _beneficiaries.removeAt(index);
    });
  }

  void _addReferee() {
    setState(() {
      _referees.add(
        RefereeFormData(
          nameController: TextEditingController(),
          occupationController: TextEditingController(),
          addressController: TextEditingController(),
        ),
      );
    });
  }

  void _removeReferee(int index) {
    setState(() {
      _referees[index].nameController.dispose();
      _referees[index].occupationController.dispose();
      _referees[index].addressController.dispose();
      _referees.removeAt(index);
    });
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 24),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTwoColumnRow(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller, {
    String? Function(String?)? validator,
    String? hint,
    int? maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
        CustomFormField(
          hintText: hint ?? 'Enter $label',
          controller: controller,
          validator: validator,
          filled: true,
          fillColor: Colors.white,
          borderRadius: 10,
          contentPadding: 0,
          maxLines: maxLines,
        ),
        SizedBox(height: 16),
      ],
    );
  }

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

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement API call based on category
      // final postData = _getPostData();
      // debugPrint('Post data: $postData');

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Information updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update information: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Map<String, dynamic> _getPostData() {
    switch (widget.category) {
      case EditCategory.bioData:
        return {
          'surname': _surnameController.text,
          'other_names': _otherNamesController.text,
          'date_of_birth': _dateOfBirthController.text,
          'nationality': _nationalityController.text,
          'home_town': _homeTownController.text,
          'region': _regionController.text,
          'gender': _genderController.text,
          'email_address': _emailAddressController.text,
          'telephone': _telephoneController.text,
          'city_town': _cityTownController.text,
          'digital_address': _digitalAddressController.text,
          'house_number': _houseNumberController.text,
          'street_name': _streetNameController.text,
          'post_address': _postAddressController.text,
          'bank': _bankController.text,
          'account_name': _accountNameController.text,
          'social_security_number': _socialSecurityNumberController.text,
          'languages_spoken': _languagesSpokenController.text,
        };
      case EditCategory.employmentRecord:
        return {
          'present_job_title': _presentJobTitleController.text,
          'employment_status': _employmentStatusController.text,
          'date_of_employment': _dateOfEmploymentController.text,
          'probation_period': _probationPeriodController.text,
          'immediate_supervisor': _immediateSupervisorController.text,
          'career_objects': _careerObjectivesController.text,
        };
      case EditCategory.familyData:
        return {
          'marital_status': _maritalStatusController.text,
          'spouse_name': _spouseNameController.text,
          'spouse_occupation': _spouseOccupationController.text,
          'father_name': _fatherNameController.text,
          'mother_name': _motherNameController.text,
          'number_of_children': _numberOfChildrenController.text,
          'children': _children.map((child) {
            return {
              'id': child.id,
              'name': child.nameController.text,
              'date_of_birth': child.dobController.text,
            };
          }).toList(),
        };
      case EditCategory.educationTraining:
        return {
          'hobbies_special_interes': _hobbiesController.text,
          'academic_qualifications': _academicQualifications.map((
            qualification,
          ) {
            return {
              'id': qualification.id,
              'qualification': qualification.qualificationController.text,
              'institution': qualification.institutionController.text,
              'year': qualification.yearController.text,
            };
          }).toList(),
          'trainings': _trainings.map((training) {
            return {
              'id': training.id,
              'course': training.courseController.text,
              'instituition': training.institutionController.text,
              'year': training.yearController.text,
              'location': training.locationController.text,
            };
          }).toList(),
        };
      case EditCategory.emergencyContacts:
        return {
          'emergencies': _emergencyContacts.map((contact) {
            return {
              'id': contact.id,
              'name': contact.nameController.text,
              'address': contact.addressController.text,
              'telephone_number': contact.telephoneController.text,
            };
          }).toList(),
        };
      case EditCategory.beneficiaries:
        return {
          'beneficiaries': _beneficiaries.map((beneficiary) {
            return {
              'id': beneficiary.id,
              'name': beneficiary.nameController.text,
              'address_telephone_number':
                  beneficiary.addressTelephoneController.text,
              'relationship': beneficiary.relationshipController.text,
              'percentage_of_benefit': beneficiary.percentageController.text,
            };
          }).toList(),
        };
      case EditCategory.referees:
        return {
          'referees': _referees.map((referee) {
            return {
              'id': referee.id,
              'name': referee.nameController.text,
              'occupation': referee.occupationController.text,
              'address': referee.addressController.text,
            };
          }).toList(),
        };
      default:
        return {};
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    _surnameController.dispose();
    _otherNamesController.dispose();
    _dateOfBirthController.dispose();
    _nationalityController.dispose();
    _homeTownController.dispose();
    _regionController.dispose();
    _genderController.dispose();
    _emailAddressController.dispose();
    _telephoneController.dispose();
    _cityTownController.dispose();
    _digitalAddressController.dispose();
    _houseNumberController.dispose();
    _streetNameController.dispose();
    _postAddressController.dispose();
    _bankController.dispose();
    _accountNameController.dispose();
    _socialSecurityNumberController.dispose();
    _languagesSpokenController.dispose();
    _presentJobTitleController.dispose();
    _employmentStatusController.dispose();
    _dateOfEmploymentController.dispose();
    _probationPeriodController.dispose();
    _immediateSupervisorController.dispose();
    _careerObjectivesController.dispose();
    _maritalStatusController.dispose();
    _spouseNameController.dispose();
    _spouseOccupationController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _numberOfChildrenController.dispose();

    // Dispose children controllers
    for (var child in _children) {
      child.nameController.dispose();
      child.dobController.dispose();
    }

    // Dispose academic qualifications controllers
    for (var qualification in _academicQualifications) {
      qualification.qualificationController.dispose();
      qualification.institutionController.dispose();
      qualification.yearController.dispose();
    }

    // Dispose trainings controllers
    for (var training in _trainings) {
      training.courseController.dispose();
      training.institutionController.dispose();
      training.yearController.dispose();
      training.locationController.dispose();
    }

    _hobbiesController.dispose();

    // Dispose emergency contacts controllers
    for (var contact in _emergencyContacts) {
      contact.nameController.dispose();
      contact.addressController.dispose();
      contact.telephoneController.dispose();
    }

    // Dispose beneficiaries controllers
    for (var beneficiary in _beneficiaries) {
      beneficiary.nameController.dispose();
      beneficiary.addressTelephoneController.dispose();
      beneficiary.relationshipController.dispose();
      beneficiary.percentageController.dispose();
    }

    // Dispose referees controllers
    for (var referee in _referees) {
      referee.nameController.dispose();
      referee.occupationController.dispose();
      referee.addressController.dispose();
    }

    super.dispose();
  }
}
