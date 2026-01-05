import 'dart:async';
import 'package:flutter/material.dart';
import 'package:leave_desk/api/user_api.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/models/department.dart';
import 'package:leave_desk/models/navigation_item.dart';
import 'package:leave_desk/models/user.dart';
import 'package:leave_desk/services/app_service.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/loading.dart';
import 'package:leave_desk/shared/page_title.dart';

class AssignDepartmentManager extends StatefulWidget {
  final Department? department;
  final StreamController<bool>? reloadController;

  const AssignDepartmentManager({
    super.key,
    this.department,
    this.reloadController,
  });

  @override
  State<AssignDepartmentManager> createState() =>
      _AssignDepartmentManagerState();
}

class _AssignDepartmentManagerState extends State<AssignDepartmentManager> {
  final UserApi _userApi = UserApi();
  final _formKey = GlobalKey<FormState>();
  final appService = locator<AppService>();

  List<User> _users = [];
  User? _currentManager;
  int? _selectedUserId;

  bool _isLoadingData = true;
  bool _isSubmitting = false;
  bool _isUnassigning = false;

  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadUsers() async {
    try {
      debugPrint("Fetching users for branch...");

      // Get branch ID from selected branch or department's branch
      final branchId =
          appService.selectedBranch?.id ?? widget.department?.branchId;

      if (branchId == null) {
        throw Exception('No branch selected');
      }

      final usersResponse = await _userApi.getUsers(
        branchId: branchId.toString(),
      );

      if (usersResponse.ok) {
        final data = usersResponse.data;
        List<User> users = [];

        if (data is Map && data.containsKey('data')) {
          users = (data['data'] as List)
              .map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList();
        } else if (data is List) {
          users = data
              .map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList();
        }

        _users = users;
        debugPrint("Users loaded: ${_users.length} users");
      } else {
        throw Exception(
          'Failed to load users: ${usersResponse.message ?? "Unknown error"}',
        );
      }
    } catch (e) {
      debugPrint("ERROR in _loadUsers: $e");
      throw Exception('Failed to load users: $e');
    }
  }

  void _checkCurrentManager() {
    // Check if department has a manager
    if (widget.department?.manager != null) {
      _currentManager = widget.department!.manager;
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoadingData = true;
      _error = null;
    });

    try {
      _checkCurrentManager();
      await _loadUsers();

      setState(() {
        _isLoadingData = false;
      });
    } catch (e) {
      debugPrint("ERROR in _loadData: $e");
      setState(() {
        _error = e.toString();
        _isLoadingData = false;
      });
    }
  }

  Future<void> _unassignManager() async {
    if (_currentManager == null) return;

    // Show confirmation dialog
    final shouldUnassign = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unassign Manager'),
        content: const Text(
          'Are you sure you want to unassign this manager from the department?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Unassign', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldUnassign != true) return;

    setState(() {
      _isUnassigning = true;
    });

    try {
      final payload = {"department_id": widget.department!.id};
      final response = await _userApi.unassignManagerFromDepartment(payload);

      if (response.ok) {
        setState(() {
          _isUnassigning = false;
          _currentManager = null;
        });

        // Notify listeners to reload
        widget.reloadController?.add(true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Manager unassigned successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUnassigning = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _submitAssignment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final payload = {
        "department_id": widget.department!.id,
        "manager_id": _selectedUserId,
      };

      final response = await _userApi.assignManagerToDepartment(payload);

      if (response.ok) {
        // Notify listeners to reload
        widget.reloadController?.add(true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Manager assigned successfully'),
            backgroundColor: Colors.green,
          ),
        );
        appService.controller.add(NavigationItem("", "/departments", "pop"));
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
      child: _isLoadingData
          ? Center(child: Loading())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_error!, style: TextStyle(color: Colors.red)),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _loadData,
                    icon: Icon(Icons.refresh),
                    label: Text('Retry'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  PageTitle(name: "Assign Department Manager"),
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
                              const Text("Assign a manager to the department"),
                              const SizedBox(height: 25),

                              // Current Manager Section
                              if (_currentManager != null) ...[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Current Manager',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Chip(
                                      backgroundColor: AppColors.primaryColor
                                          .withAlpha(25),
                                      label: Text(
                                        _currentManager!.name ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      deleteIcon: _isUnassigning
                                          ? SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(AppColors.primaryColor),
                                              ),
                                            )
                                          : Icon(
                                              Icons.close,
                                              size: 18,
                                              color: AppColors.primaryColor,
                                            ),
                                      onDeleted: _isUnassigning
                                          ? null
                                          : _unassignManager,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                              ],

                              // Department Info Section
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
                                      Icons.business_center,
                                      color: AppColors.primaryColor,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.department?.name ?? 'N/A',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'CODE: ${widget.department?.code ?? 'N/A'}',
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

                              // User Dropdown
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      text: 'Select Manager',
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
                                  DropdownButtonFormField<int>(
                                    value: _selectedUserId,
                                    decoration: InputDecoration(
                                      hintText: 'Select a user',
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
                                    items: _users.map((user) {
                                      return DropdownMenuItem<int>(
                                        value: user.id,
                                        child: Text(user.name ?? 'N/A'),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedUserId = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select a user';
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
                                    "Submit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  ontap: _submitAssignment,
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
