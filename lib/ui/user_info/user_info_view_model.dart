import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leave_desk/api/user_api.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/constants/routes.dart';
import 'package:leave_desk/models/api_response.dart';
import 'package:leave_desk/models/beneficiary.dart';
import 'package:leave_desk/models/bio_data.dart';
import 'package:leave_desk/models/education_training.dart';
import 'package:leave_desk/models/emergency_contact.dart';
import 'package:leave_desk/models/employment_record.dart';
import 'package:leave_desk/models/family_data.dart';
import 'package:leave_desk/models/referee.dart';
import 'package:leave_desk/services/app_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UserInfoViewModel extends BaseViewModel {
  int currentStep = 1;
  List<String> labels = [
    'Bio Data',
    'Family Data',
    'Employment Record',
    'Education/Training',
    'Referees',
    'Beneficiary',
    'Emergency Contact',
  ];
  UserApi userApi = UserApi();
  var appService = locator<AppService>();

  double? screenWidth, containerWidth;
  bool isMobile = false;
  bool isLoading = false;

  // Store the getPostBody function from BioDataWidget
  Map<String, dynamic> Function()? _getBioDataForm;
  bool Function()? _shouldSubmitBioData;

  // Store the getPostBody function from FamilyData
  Map<String, dynamic> Function()? _getFamilyDataForm;
  bool Function()? _shouldSubmitFamilyData;

  // Store the getPostBody function from EmploymentData
  Map<String, dynamic> Function()? _getEmploymentDataForm;
  bool Function()? _shouldSubmitEmploymentData;

  // Store the getPostBody function from EducationTrainingData
  Map<String, dynamic> Function()? _getEducationTrainingDataForm;
  bool Function()? _shouldSubmitEducationTrainingData;

  // Store the getPostBody function from RefereesData
  Map<String, dynamic> Function()? _getRefereesDataForm;
  bool Function()? _shouldSubmitRefereesData;

  // Store the getPostBody function from BeneficiaryData
  Map<String, dynamic> Function()? _getBeneficiaryDataForm;
  bool Function()? _shouldSubmitBeneficiaryData;

  // Store the getPostBody function from EmergencyData
  Map<String, dynamic> Function()? _getEmergencyDataForm;

  // Store saved form data
  Map<String, dynamic>? savedBioData;
  Map<String, dynamic>? savedFamilyData;
  Map<String, dynamic>? savedEmploymentData;
  Map<String, dynamic>? savedEducationTrainingData;
  Map<String, dynamic>? savedRefereesData;
  Map<String, dynamic>? savedBeneficiaryData;
  Map<String, dynamic>? savedEmergencyData;

  init() {
    screenWidth = MediaQuery.of(
      StackedService.navigatorKey!.currentState!.context,
    ).size.width;
    isMobile = screenWidth! < 600;
    containerWidth = isMobile ? screenWidth! - 40 : 850.0;
  }

  onStepTapped(step) {
    currentStep = step;
    rebuildUi();
  }

  // Called when BioDataWidget is ready
  void onBioDataFormReady(
    Map<String, dynamic> Function() getFormData,
    bool Function() shouldSubmitData,
  ) {
    _getBioDataForm = getFormData;
    _shouldSubmitBioData = shouldSubmitData;
  }

  // Get the bio data form data
  Map<String, dynamic>? getBioDataFormData() {
    return _getBioDataForm?.call();
  }

  // Submit bio data and move to next step
  Future<void> submitBioData() async {
    final formData = getBioDataFormData();
    if (formData != null) {
      // Check if data has changed before submitting
      final shouldSubmit = _shouldSubmitBioData?.call() ?? true;

      if (!shouldSubmit) {
        // No changes detected, skip to next step
        currentStep++;
        rebuildUi();
        return;
      }

      isLoading = true;
      rebuildUi();

      try {
        ApiResponse response = await userApi.createBioData(formData);

        if (response.ok) {
          savedBioData = Map<String, dynamic>.from(formData);
          isLoading = false;
          currentStep++;
          rebuildUi();
        }
      } on DioException catch (e) {
        debugPrint("error : ${e.response!.data}");
        isLoading = false;
        rebuildUi();
        ApiResponse errorResponse = ApiResponse.parse(e.response);
        setBusyForObject("loginButton", false);

        appService.showMessage(message: errorResponse.message);
      }
    }
  }

  // Submit bio data and move to next step
  Future<void> updateBioData() async {
    debugPrint("Updating bio data");
    final formData = getBioDataFormData();
    if (formData != null) {
      // Check if data has changed before submitting
      final shouldSubmit = _shouldSubmitBioData?.call() ?? true;

      if (!shouldSubmit) {
        // No changes detected, skip to next step
        debugPrint("No changes in bio data, skipping update");
        currentStep++;
        rebuildUi();
        return;
      }

      isLoading = true;
      rebuildUi();

      try {
        ApiResponse response = await userApi.updateBioData(formData);

        if (response.ok) {
          savedBioData = Map<String, dynamic>.from(formData);
          isLoading = false;
          currentStep++;
          rebuildUi();
        }
      } on DioException catch (e) {
        debugPrint("error : ${e.response!.data}");
        isLoading = false;
        rebuildUi();
        ApiResponse errorResponse = ApiResponse.parse(e.response);
        setBusyForObject("loginButton", false);

        appService.showMessage(message: errorResponse.message);
      }
    }
  }

  // Called when FamilyData is ready
  void onFamilyDataFormReady(
    Map<String, dynamic> Function() getFormData,
    bool Function() shouldSubmitData,
  ) {
    _getFamilyDataForm = getFormData;
    _shouldSubmitFamilyData = shouldSubmitData;
  }

  // Get the family data form data
  Map<String, dynamic>? getFamilyDataFormData() {
    return _getFamilyDataForm?.call();
  }

  // Submit family data and move to next step
  Future<void> submitFamilyData() async {
    final formData = getFamilyDataFormData();
    if (formData != null) {
      // Check if data has changed before submitting
      final shouldSubmit = _shouldSubmitFamilyData?.call() ?? true;

      if (!shouldSubmit) {
        // No changes detected, skip to next step
        currentStep++;
        rebuildUi();
        return;
      }

      isLoading = true;
      rebuildUi();

      try {
        debugPrint('Family Data Form: $formData');

        ApiResponse response = await userApi.createFamilyData(formData);

        if (response.ok) {
          savedFamilyData = Map<String, dynamic>.from(formData);
          isLoading = false;
          currentStep++;
          rebuildUi();
        }
      } on DioException catch (e) {
        isLoading = false;
        rebuildUi();
        ApiResponse errorResponse = ApiResponse.parse(e.response);

        appService.showMessage(message: errorResponse.message);
      }
    }
  }

  Future<void> updateFamilyData() async {
    final formData = getFamilyDataFormData();
    if (formData != null) {
      // Check if data has changed before submitting
      final shouldSubmit = _shouldSubmitFamilyData?.call() ?? true;

      if (!shouldSubmit) {
        // No changes detected, skip to next step
        currentStep++;
        rebuildUi();
        return;
      }

      isLoading = true;
      rebuildUi();

      try {
        debugPrint('Family Data Form: $formData');

        ApiResponse response = await userApi.updateFamilyData(formData);

        if (response.ok) {
          savedFamilyData = Map<String, dynamic>.from(formData);
          isLoading = false;
          currentStep++;
          rebuildUi();
        }
      } on DioException catch (e) {
        isLoading = false;
        rebuildUi();
        ApiResponse errorResponse = ApiResponse.parse(e.response);

        appService.showMessage(message: errorResponse.message);
      }
    }
  }

  // Go to previous step
  void goToPreviousStep() {
    if (currentStep > 1) {
      currentStep--;
      rebuildUi();
    }
  }

  // Called when EmploymentData is ready
  void onEmploymentDataFormReady(
    Map<String, dynamic> Function() getFormData,
    bool Function() shouldSubmitData,
  ) {
    _getEmploymentDataForm = getFormData;
    _shouldSubmitEmploymentData = shouldSubmitData;
  }

  // Get the employment data form data
  Map<String, dynamic>? getEmploymentDataFormData() {
    return _getEmploymentDataForm?.call();
  }

  // Submit employment data and move to next step
  Future<void> submitEmploymentData() async {
    final formData = getEmploymentDataFormData();
    if (formData != null) {
      // Check if data has changed before submitting
      final shouldSubmit = _shouldSubmitEmploymentData?.call() ?? true;

      if (!shouldSubmit) {
        // No changes detected, skip to next step
        currentStep++;
        rebuildUi();
        return;
      }

      isLoading = true;
      rebuildUi();

      try {
        debugPrint('Employment Data Form: $formData');

        ApiResponse response = await userApi.createEmploymentData(formData);

        if (response.ok) {
          savedEmploymentData = Map<String, dynamic>.from(formData);
          isLoading = false;
          currentStep++;
          rebuildUi();
        }
      } on DioException catch (e) {
        isLoading = false;
        rebuildUi();
        debugPrint("error : ${e.response!.data}");
        ApiResponse errorResponse = ApiResponse.parse(e.response);
        setBusyForObject("loginButton", false);

        appService.showMessage(message: errorResponse.message);
      }
    }
  }

  Future<void> updateEmploymentData() async {
    debugPrint("Updating record");
    final formData = getEmploymentDataFormData();
    if (formData != null) {
      // Check if data has changed before submitting
      final shouldSubmit = _shouldSubmitEmploymentData?.call() ?? true;

      if (!shouldSubmit) {
        // No changes detected, skip to next step
        currentStep++;
        rebuildUi();
        return;
      }

      isLoading = true;
      rebuildUi();

      try {
        // debugPrint('Employment Data Form: $formData');

        ApiResponse response = await userApi.updateEmploymentData(formData);

        if (response.ok) {
          savedEmploymentData = Map<String, dynamic>.from(formData);
          isLoading = false;
          currentStep++;
          rebuildUi();
        }
      } on DioException catch (e) {
        isLoading = false;
        rebuildUi();
        debugPrint("error : ${e.response!.data}");
        ApiResponse errorResponse = ApiResponse.parse(e.response);
        setBusyForObject("loginButton", false);

        appService.showMessage(message: errorResponse.message);
      }
    }
  }

  // Called when EducationTrainingData is ready
  void onEducationTrainingDataFormReady(
    Map<String, dynamic> Function() getFormData,
    bool Function() shouldSubmitData,
  ) {
    _getEducationTrainingDataForm = getFormData;
    _shouldSubmitEducationTrainingData = shouldSubmitData;
  }

  // Get the education training data form data
  Map<String, dynamic>? getEducationTrainingDataFormData() {
    return _getEducationTrainingDataForm?.call();
  }

  // Submit education training data and move to next step
  Future<void> submitEducationTrainingData(String type) async {
    final formData = getEducationTrainingDataFormData();
    if (formData != null) {
      // Check if data has changed before submitting
      final shouldSubmit = _shouldSubmitEducationTrainingData?.call() ?? true;

      if (!shouldSubmit) {
        // No changes detected, skip to next step
        currentStep++;
        rebuildUi();
        return;
      }

      isLoading = true;
      rebuildUi();

      try {
        debugPrint('Education Training Data Form: $formData');

        ApiResponse response = type == "submit"
            ? await userApi.createEducationTraining(formData)
            : await userApi.updateEducationTraining(formData);

        if (response.ok) {
          savedEducationTrainingData = Map<String, dynamic>.from(formData);
          isLoading = false;
          currentStep++;
          rebuildUi();
        }
      } on DioException catch (e) {
        isLoading = false;
        rebuildUi();
        ApiResponse errorResponse = ApiResponse.parse(e.response);

        appService.showMessage(message: errorResponse.message);
      }
    }
  }

  // Called when RefereesData is ready
  void onRefereesDataFormReady(
    Map<String, dynamic> Function() getFormData,
    bool Function() shouldSubmitData,
  ) {
    _getRefereesDataForm = getFormData;
    _shouldSubmitRefereesData = shouldSubmitData;
  }

  // Get the referees data form data
  Map<String, dynamic>? getRefereesDataFormData() {
    return _getRefereesDataForm?.call();
  }

  // Submit referees data and move to next step
  Future<void> submitRefereesData(String type) async {
    final formData = getRefereesDataFormData();
    if (formData != null) {
      // Check if data has changed before submitting
      final shouldSubmit = _shouldSubmitRefereesData?.call() ?? true;

      if (!shouldSubmit) {
        // No changes detected, skip to next step
        currentStep++;
        rebuildUi();
        return;
      }

      isLoading = true;
      rebuildUi();

      try {
        debugPrint('Referees Data Form: $formData');

        ApiResponse response = type == "submit"
            ? await userApi.createReferee(formData)
            : await userApi.updateReferee(formData);

        if (response.ok) {
          savedRefereesData = Map<String, dynamic>.from(formData);
          isLoading = false;
          currentStep++;
          rebuildUi();
        }
      } on DioException catch (e) {
        isLoading = false;

        rebuildUi();
        ApiResponse errorResponse = ApiResponse.parse(e.response);
        setBusyForObject("loginButton", false);

        appService.showMessage(message: errorResponse.message);
      }
    }
  }

  // Called when BeneficiaryData is ready
  void onBeneficiaryDataFormReady(
    Map<String, dynamic> Function() getFormData,
    bool Function() shouldSubmitData,
  ) {
    _getBeneficiaryDataForm = getFormData;
    _shouldSubmitBeneficiaryData = shouldSubmitData;
  }

  // Get the beneficiary data form data
  Map<String, dynamic>? getBeneficiaryDataFormData() {
    return _getBeneficiaryDataForm?.call();
  }

  // Submit beneficiary data and move to next step
  Future<void> submitBeneficiaryData(String type) async {
    final formData = getBeneficiaryDataFormData();
    if (formData != null) {
      // Check if data has changed before submitting
      final shouldSubmit = _shouldSubmitBeneficiaryData?.call() ?? true;

      if (!shouldSubmit) {
        // No changes detected, skip to next step
        currentStep++;
        rebuildUi();
        return;
      }

      isLoading = true;
      rebuildUi();

      try {
        ApiResponse response = type == "submit"
            ? await userApi.createBeneficiary(formData)
            : await userApi.updateBeneficiary(formData);

        if (response.ok) {
          savedBeneficiaryData = Map<String, dynamic>.from(formData);
          isLoading = false;
          currentStep++;
          rebuildUi();
        }
      } on DioException catch (e) {
        ApiResponse errorResponse = ApiResponse.parse(e.response);
        setBusyForObject("loginButton", false);

        appService.showMessage(message: errorResponse.message);
      }
    }
  }

  // Called when EmergencyData is ready
  void onEmergencyDataFormReady(Map<String, dynamic> Function() getFormData) {
    _getEmergencyDataForm = getFormData;
  }

  // Get the emergency data form data
  Map<String, dynamic>? getEmergencyDataFormData() {
    return _getEmergencyDataForm?.call();
  }

  // Submit emergency data and move to next step
  Future<void> submitEmergencyData(String type) async {
    final formData = getEmergencyDataFormData();
    if (formData != null) {
      isLoading = true;
      rebuildUi();

      try {
        debugPrint('Emergency Data Form: $formData');

        ApiResponse response = type == "submit"
            ? await userApi.createEmergencyContact(formData)
            : await userApi.updateEmergencyContact(formData);

        if (response.ok) {
          debugPrint("results : ${response.data}");
          Map<String, dynamic> results = response.data;
          appService.currentUser!.bioData = BioData.fromJson(
            results['bio_data'],
          );
          appService.currentUser!.familyData = FamilyData.fromJson(
            results['family_data'],
          );
          appService.currentUser!.employmentRecord = EmploymentRecord.fromJson(
            results['employment_record'],
          );
          appService.currentUser!.educationTraining =
              EducationTraining.fromJson(results['education_training']);
          appService.currentUser!.emergencies = results['emergencies'].map(
            (e) => EmergencyContact.fromJson(e),
          ).toList();
          appService.currentUser!.beneficiaries = results['emergencies'].map(
            (e) => Beneficiary.fromJson(e),
          ).toList();
          appService.currentUser!.referees = results['referees'].map(
            (e) => Referee.fromJson(e),
          ).toList();

          isLoading = false;
          appService.showMessage(
            title: "Success",
            message: "Great, your data has been fully captured. Lets proceed",
          );
          Navigator.of(
            // ignore: use_build_context_synchronously
            StackedService.navigatorKey!.currentContext!,
          ).pushReplacementNamed(Routes.base);
          rebuildUi();
        }
      } on DioException catch (e) {
        isLoading = true;
        rebuildUi();
        ApiResponse errorResponse = ApiResponse.parse(e.response);
        setBusyForObject("loginButton", false);

        appService.showMessage(message: errorResponse.message);
      }
    }
  }
}
