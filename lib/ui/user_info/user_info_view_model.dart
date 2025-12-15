import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leave_desk/api/user_api.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/models/api_response.dart';
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
  Map<String, String> Function()? _getBioDataForm;

  // Store the getPostBody function from FamilyData
  Map<String, dynamic> Function()? _getFamilyDataForm;

  // Store the getPostBody function from EmploymentData
  Map<String, String> Function()? _getEmploymentDataForm;

  // Store the getPostBody function from EducationTrainingData
  Map<String, dynamic> Function()? _getEducationTrainingDataForm;

  // Store the getPostBody function from RefereesData
  Map<String, dynamic> Function()? _getRefereesDataForm;

  // Store the getPostBody function from BeneficiaryData
  Map<String, dynamic> Function()? _getBeneficiaryDataForm;

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
  void onBioDataFormReady(Map<String, String> Function() getFormData) {
    _getBioDataForm = getFormData;
  }

  // Get the bio data form data
  Map<String, String>? getBioDataFormData() {
    return _getBioDataForm?.call();
  }

  // Submit bio data and move to next step
  Future<void> submitBioData() async {
    final formData = getBioDataFormData();
    if (formData != null) {
      isLoading = true;
      rebuildUi();

      try {
        debugPrint('Bio Data Form: $formData');

        ApiResponse response = await userApi.createBioData(formData);

        if (response.ok) {
          savedBioData = Map<String, dynamic>.from(formData);
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

  // Called when FamilyData is ready
  void onFamilyDataFormReady(Map<String, dynamic> Function() getFormData) {
    _getFamilyDataForm = getFormData;
  }

  // Get the family data form data
  Map<String, dynamic>? getFamilyDataFormData() {
    return _getFamilyDataForm?.call();
  }

  // Submit family data and move to next step
  Future<void> submitFamilyData() async {
    final formData = getFamilyDataFormData();
    if (formData != null) {
      isLoading = true;
      rebuildUi();

      try {
        debugPrint('Family Data Form: $formData');

        // TODO: Replace with actual API call when available
        // ApiResponse response = await userApi.createFamilyData(formData);

        // Simulating API success for now
        await Future.delayed(const Duration(seconds: 1));

        savedFamilyData = Map<String, dynamic>.from(formData);
        isLoading = false;
        currentStep++;
        rebuildUi();

        // if (response.ok) {
        //   isLoading = false;
        //   currentStep++;
        //   rebuildUi();
        // }
      } on DioException catch (e) {
        ApiResponse errorResponse = ApiResponse.parse(e.response);
        setBusyForObject("loginButton", false);

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
  void onEmploymentDataFormReady(Map<String, String> Function() getFormData) {
    _getEmploymentDataForm = getFormData;
  }

  // Get the employment data form data
  Map<String, String>? getEmploymentDataFormData() {
    return _getEmploymentDataForm?.call();
  }

  // Submit employment data and move to next step
  Future<void> submitEmploymentData() async {
    final formData = getEmploymentDataFormData();
    if (formData != null) {
      isLoading = true;
      rebuildUi();

      try {
        debugPrint('Employment Data Form: $formData');

        // TODO: Replace with actual API call when available
        // ApiResponse response = await userApi.createEmploymentData(formData);

        // Simulating API success for now
        await Future.delayed(const Duration(seconds: 1));

        savedEmploymentData = Map<String, dynamic>.from(formData);
        isLoading = false;
        currentStep++;
        rebuildUi();

        // if (response.ok) {
        //   isLoading = false;
        //   currentStep++;
        //   rebuildUi();
        // }
      } on DioException catch (e) {
        ApiResponse errorResponse = ApiResponse.parse(e.response);
        setBusyForObject("loginButton", false);

        appService.showMessage(message: errorResponse.message);
      }
    }
  }

  // Called when EducationTrainingData is ready
  void onEducationTrainingDataFormReady(
    Map<String, dynamic> Function() getFormData,
  ) {
    _getEducationTrainingDataForm = getFormData;
  }

  // Get the education training data form data
  Map<String, dynamic>? getEducationTrainingDataFormData() {
    return _getEducationTrainingDataForm?.call();
  }

  // Submit education training data and move to next step
  Future<void> submitEducationTrainingData() async {
    final formData = getEducationTrainingDataFormData();
    if (formData != null) {
      isLoading = true;
      rebuildUi();

      try {
        debugPrint('Education Training Data Form: $formData');

        // TODO: Replace with actual API call when available
        // ApiResponse response = await userApi.createEducationTrainingData(formData);

        // Simulating API success for now
        await Future.delayed(const Duration(seconds: 1));

        savedEducationTrainingData = Map<String, dynamic>.from(formData);
        isLoading = false;
        currentStep++;
        rebuildUi();

        // if (response.ok) {
        //   isLoading = false;
        //   currentStep++;
        //   rebuildUi();
        // }
      } on DioException catch (e) {
        ApiResponse errorResponse = ApiResponse.parse(e.response);
        setBusyForObject("loginButton", false);

        appService.showMessage(message: errorResponse.message);
      }
    }
  }

  // Called when RefereesData is ready
  void onRefereesDataFormReady(Map<String, dynamic> Function() getFormData) {
    _getRefereesDataForm = getFormData;
  }

  // Get the referees data form data
  Map<String, dynamic>? getRefereesDataFormData() {
    return _getRefereesDataForm?.call();
  }

  // Submit referees data and move to next step
  Future<void> submitRefereesData() async {
    final formData = getRefereesDataFormData();
    if (formData != null) {
      isLoading = true;
      rebuildUi();

      try {
        debugPrint('Referees Data Form: $formData');

        // TODO: Replace with actual API call when available
        // ApiResponse response = await userApi.createRefereesData(formData);

        // Simulating API success for now
        await Future.delayed(const Duration(seconds: 1));

        savedRefereesData = Map<String, dynamic>.from(formData);
        isLoading = false;
        currentStep++;
        rebuildUi();

        // if (response.ok) {
        //   isLoading = false;
        //   currentStep++;
        //   rebuildUi();
        // }
      } on DioException catch (e) {
        ApiResponse errorResponse = ApiResponse.parse(e.response);
        setBusyForObject("loginButton", false);

        appService.showMessage(message: errorResponse.message);
      }
    }
  }

  // Called when BeneficiaryData is ready
  void onBeneficiaryDataFormReady(Map<String, dynamic> Function() getFormData) {
    _getBeneficiaryDataForm = getFormData;
  }

  // Get the beneficiary data form data
  Map<String, dynamic>? getBeneficiaryDataFormData() {
    return _getBeneficiaryDataForm?.call();
  }

  // Submit beneficiary data and move to next step
  Future<void> submitBeneficiaryData() async {
    final formData = getBeneficiaryDataFormData();
    if (formData != null) {
      isLoading = true;
      rebuildUi();

      try {
        debugPrint('Beneficiary Data Form: $formData');

        // TODO: Replace with actual API call when available
        // ApiResponse response = await userApi.createBeneficiaryData(formData);

        // Simulating API success for now
        await Future.delayed(const Duration(seconds: 1));

        savedBeneficiaryData = Map<String, dynamic>.from(formData);
        isLoading = false;
        currentStep++;
        rebuildUi();

        // if (response.ok) {
        //   isLoading = false;
        //   currentStep++;
        //   rebuildUi();
        // }
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
  Future<void> submitEmergencyData() async {
    final formData = getEmergencyDataFormData();
    if (formData != null) {
      isLoading = true;
      rebuildUi();

      try {
        debugPrint('Emergency Data Form: $formData');

        // TODO: Replace with actual API call when available
        // ApiResponse response = await userApi.createEmergencyData(formData);

        // Simulating API success for now
        await Future.delayed(const Duration(seconds: 1));

        savedEmergencyData = Map<String, dynamic>.from(formData);
        isLoading = false;
        currentStep++;
        rebuildUi();

        // if (response.ok) {
        //   isLoading = false;
        //   currentStep++;
        //   rebuildUi();
        // }
      } on DioException catch (e) {
        ApiResponse errorResponse = ApiResponse.parse(e.response);
        setBusyForObject("loginButton", false);

        appService.showMessage(message: errorResponse.message);
      }
    }
  }
}
