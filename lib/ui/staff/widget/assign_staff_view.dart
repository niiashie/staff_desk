import 'dart:async';
import 'package:flutter/material.dart';
import 'package:leave_desk/api/user_api.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/models/branch.dart';
import 'package:leave_desk/models/navigation_item.dart';
import 'package:leave_desk/models/role.dart';
import 'package:leave_desk/models/user.dart';
import 'package:leave_desk/services/app_service.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/loading.dart';
import 'package:leave_desk/shared/page_title.dart';

class AssignStaffView extends StatefulWidget {
  final User user;
  final StreamController<bool>? reloadController;

  const AssignStaffView({super.key, required this.user, this.reloadController});

  @override
  State<AssignStaffView> createState() => _AssignStaffViewState();
}

class _AssignStaffViewState extends State<AssignStaffView> {
  final UserApi _userApi = UserApi();
  final _formKey = GlobalKey<FormState>();

  List<Role> _roles = [];
  var appService = locator<AppService>();
  List<Branch> _branches = [];

  int? _selectedRoleId;
  int? _selectedBranchId;

  bool _isLoadingData = true;
  bool _isSubmitting = false;
  int? _removingBranchId;

  String? _error;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Future<void> _loadRoles() async {
    try {
      debugPrint("Calling getRoles endpoint...");
      final rolesResponse = await _userApi.getRoles();

      if (rolesResponse.ok) {
        _roles = (rolesResponse.data as List)
            .map((e) => Role.fromJson(e as Map<String, dynamic>))
            .toList();
        debugPrint("getRoles succeeded: ${_roles.length} roles loaded");
      } else {
        throw Exception(
          'Roles endpoint failed: ${rolesResponse.message ?? "Unknown error"}',
        );
      }
    } catch (e) {
      debugPrint("ERROR in _loadRoles: $e");
      throw Exception('Roles endpoint error: $e');
    }
  }

  Future<void> _loadBranches() async {
    try {
      debugPrint("Calling getBranch endpoint...");
      final branchesResponse = await _userApi.getBranch();

      if (branchesResponse.ok) {
        _branches = (branchesResponse.data as List)
            .map((e) => Branch.fromJson(e as Map<String, dynamic>))
            .toList();
        debugPrint("getBranch succeeded: ${_branches.length} branches loaded");
      } else {
        throw Exception(
          'Branches endpoint failed: ${branchesResponse.message ?? "Unknown error"}',
        );
      }
    } catch (e) {
      debugPrint("ERROR in _loadBranches: $e");
      throw Exception('Branches endpoint error: $e');
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoadingData = true;
      _error = null;
    });

    try {
      await _loadRoles();
      await _loadBranches();

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

  Future<void> _removeBranch(int? branchId) async {
    if (branchId == null) return;

    // Show confirmation dialog
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Branch'),
        content: const Text(
          'Are you sure you want to remove this branch assignment?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldRemove != true) return;

    setState(() {
      _removingBranchId = branchId;
    });

    try {
      final payload = {"user_id": widget.user.id, "branch_id": branchId};

      final response = await _userApi.unassignUserFromBranch(payload);

      if (mounted) {
        setState(() {
          _removingBranchId = null;
        });

        if (response.ok) {
          // Notify listeners to reload
          widget.reloadController?.add(true);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'Branch removed successfully'),
              backgroundColor: Colors.green,
            ),
          );
          // Refresh the page or pop with result to reload user data
          Navigator.of(context).pop(true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'Failed to remove branch'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _removingBranchId = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Map<String, dynamic> _prepareAssignmentPayload() {
    return {
      "user_id": widget.user.id,
      "branch_id": _selectedBranchId,
      "role_id": _selectedRoleId,
    };
  }

  Future<void> _submitAssignment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final payload = _prepareAssignmentPayload();
      final response = await _userApi.assignUserToBranch(payload);

      if (response.ok) {
        if (mounted) {
          // Notify listeners to reload
          widget.reloadController?.add(true);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'User assigned successfully'),
              backgroundColor: AppColors.primaryColor,
            ),
          );

          appService.controller.add(NavigationItem("", "/staff", "pop"));
          Navigator.of(context).pop(true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'Failed to assign user'),
              backgroundColor: Colors.red,
            ),
          );
        }
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
    return Stack(
      children: [
        Container(
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
                      PageTitle(name: "Assign Staff to Branch"),
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
                                    "Assign user to a branch with a specific role",
                                  ),
                                  const SizedBox(height: 25),

                                  // Current Branches Section
                                  if (widget.user.branches != null &&
                                      widget.user.branches!.isNotEmpty) ...[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Current Branches',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          height: 50,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                widget.user.branches!.length,
                                            itemBuilder: (context, index) {
                                              final branch =
                                                  widget.user.branches![index];
                                              final isRemoving =
                                                  _removingBranchId ==
                                                  branch.id;
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 8.0,
                                                ),
                                                child: Chip(
                                                  backgroundColor: AppColors
                                                      .primaryColor
                                                      .withAlpha(25),
                                                  label: Text(
                                                    branch.branchName ?? 'N/A',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  deleteIcon: isRemoving
                                                      ? SizedBox(
                                                          width: 18,
                                                          height: 18,
                                                          child: CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                  Color
                                                                >(
                                                                  AppColors
                                                                      .primaryColor,
                                                                ),
                                                          ),
                                                        )
                                                      : Icon(
                                                          Icons.close,
                                                          size: 18,
                                                          color: AppColors
                                                              .primaryColor,
                                                        ),
                                                  onDeleted: isRemoving
                                                      ? null
                                                      : () => _removeBranch(
                                                          branch.id,
                                                        ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                  ],

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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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

                                  // Role Dropdown
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: const TextSpan(
                                          text: 'Select Role',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: ' *',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<int>(
                                        initialValue: _selectedRoleId,
                                        decoration: InputDecoration(
                                          hintText: 'Select a role',
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
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          errorStyle: const TextStyle(
                                            color: Color(0xffFDB35C),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: Color(0xffFDB35C),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Color(0xffFDB35C),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: Color(0xffFDB35C),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.crudTextColor,
                                        ),
                                        items: _roles.map((role) {
                                          return DropdownMenuItem<int>(
                                            value: role.id,
                                            child: Text(role.name ?? ''),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedRoleId = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please select a role';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),

                                  // Branch Dropdown
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: const TextSpan(
                                          text: 'Select Branch',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: ' *',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<int>(
                                        initialValue: _selectedBranchId,
                                        decoration: InputDecoration(
                                          hintText: 'Select a branch',
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
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          errorStyle: const TextStyle(
                                            color: Color(0xffFDB35C),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: Color(0xffFDB35C),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Color(0xffFDB35C),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: Color(0xffFDB35C),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.crudTextColor,
                                        ),
                                        items: _branches.map((branch) {
                                          return DropdownMenuItem<int>(
                                            value: branch.id,
                                            child: Text(
                                              branch.branchName ?? '',
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedBranchId = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please select a branch';
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
        ),
      ],
    );
  }
}
