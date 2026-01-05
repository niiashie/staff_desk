import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leave_desk/api/user_api.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/models/navigation_item.dart';
import 'package:leave_desk/models/user.dart';
import 'package:leave_desk/services/app_service.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/page_title.dart';

class StaffLeaveInfoView extends StatefulWidget {
  final User user;
  final StreamController<bool>? reloadController;

  const StaffLeaveInfoView({
    super.key,
    required this.user,
    this.reloadController,
  });

  @override
  State<StaffLeaveInfoView> createState() => _StaffLeaveInfoViewState();
}

class _StaffLeaveInfoViewState extends State<StaffLeaveInfoView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _numberOfDaysController = TextEditingController();
  final TextEditingController _daysGoneController = TextEditingController();
  final TextEditingController _daysLeftController = TextEditingController();

  bool _isSubmitting = false;
  var appService = locator<AppService>();
  bool _isUpdateMode = false;

  @override
  void initState() {
    super.initState();
    _checkAndPopulateLeaveData();
  }

  void _checkAndPopulateLeaveData() {
    if (widget.user.leave != null) {
      setState(() {
        _isUpdateMode = true;
        _numberOfDaysController.text =
            widget.user.leave!.numberOfDays?.toString() ?? '';
        _daysGoneController.text =
            widget.user.leave!.daysGone?.toString() ?? '';
        _daysLeftController.text =
            widget.user.leave!.daysLeft?.toString() ?? '';
      });
    }
  }

  @override
  void dispose() {
    _numberOfDaysController.dispose();
    _daysGoneController.dispose();
    _daysLeftController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _preparePayload() {
    return {
      "user_id": widget.user.id,
      "number_of_days": _numberOfDaysController.text.trim(),
      "days_gone": _daysGoneController.text.trim(),
      "days_left": _daysLeftController.text.trim(),
    };
  }

  Future<void> _submitLeaveInfo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final payload = _preparePayload();
      UserApi _userApi = UserApi();

      final response = _isUpdateMode
          ? await _userApi.updateStaffLeave(payload)
          : await _userApi.createStaffLeave(payload);

      debugPrint("Leave info payload: $payload");

      if (response.ok) {
        widget.reloadController?.add(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isUpdateMode
                  ? 'Leave information updated successfully'
                  : 'Leave information submitted successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
        appService.controller.add(NavigationItem("", "/staff", "pop"));
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 35),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            PageTitle(name: "Staff Leave Duration"),
            const SizedBox(height: 15),
            Container(
              width: 450,
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Set leave duration information for staff member",
                        ),
                        const SizedBox(height: 25),

                        // User Info Section
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: AppColors.primaryColor,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.user.name ?? 'N/A',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'ROLE: ${widget.user.role!.name ?? 'N/A'}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Number of Days Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                text: 'Number of Days',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _numberOfDaysController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                hintText: 'Enter total number of days',
                                hintStyle: const TextStyle(
                                  color: AppColors.crudTextColor,
                                  fontSize: 14,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF9FAFB),
                                contentPadding: const EdgeInsets.only(
                                  top: 14,
                                  bottom: 14,
                                  left: 17,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                errorStyle: const TextStyle(
                                  color: Color(0xffFDB35C),
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
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Color(0xffFDB35C),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.crudTextColor,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Number of days is required';
                                }
                                final intValue = int.tryParse(value.trim());
                                if (intValue == null || intValue <= 0) {
                                  return 'Please enter a valid number greater than 0';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Days Gone Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                text: 'Days Gone',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _daysGoneController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                hintText: 'Enter days gone',
                                hintStyle: const TextStyle(
                                  color: AppColors.crudTextColor,
                                  fontSize: 14,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF9FAFB),
                                contentPadding: const EdgeInsets.only(
                                  top: 14,
                                  bottom: 14,
                                  left: 17,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                errorStyle: const TextStyle(
                                  color: Color(0xffFDB35C),
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
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Color(0xffFDB35C),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.crudTextColor,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Days gone is required';
                                }
                                final intValue = int.tryParse(value.trim());
                                if (intValue == null || intValue < 0) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Days Left Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                text: 'Days Left',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _daysLeftController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                hintText: 'Enter days left',
                                hintStyle: const TextStyle(
                                  color: AppColors.crudTextColor,
                                  fontSize: 14,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF9FAFB),
                                contentPadding: const EdgeInsets.only(
                                  top: 14,
                                  bottom: 14,
                                  left: 17,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                errorStyle: const TextStyle(
                                  color: Color(0xffFDB35C),
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
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Color(0xffFDB35C),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.crudTextColor,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Days left is required';
                                }
                                final intValue = int.tryParse(value.trim());
                                if (intValue == null || intValue < 0) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),

                        // Submit Button
                        Align(
                          alignment: Alignment.bottomRight,
                          child: CustomButton(
                            width: 100,
                            isLoading: _isSubmitting,
                            height: 40,
                            color: AppColors.primaryColor,
                            elevation: 2,
                            title: Text(
                              _isUpdateMode ? "Update" : "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                            ontap: _submitLeaveInfo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
