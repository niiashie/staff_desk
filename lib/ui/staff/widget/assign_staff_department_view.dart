import 'dart:async';
import 'package:flutter/material.dart';
import 'package:leave_desk/api/user_api.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/models/branch.dart';
import 'package:leave_desk/models/department.dart';
import 'package:leave_desk/models/navigation_item.dart';
import 'package:leave_desk/models/user.dart';
import 'package:leave_desk/services/app_service.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/loading.dart';
import 'package:leave_desk/shared/page_title.dart';

class AssignStaffDepartmentView extends StatefulWidget {
  final User user;
  final StreamController<bool>? reloadController;

  const AssignStaffDepartmentView({
    super.key,
    required this.user,
    this.reloadController,
  });

  @override
  State<AssignStaffDepartmentView> createState() =>
      _AssignStaffDepartmentViewState();
}

class _AssignStaffDepartmentViewState extends State<AssignStaffDepartmentView> {
  final UserApi _userApi = UserApi();
  final _formKey = GlobalKey<FormState>();
  var appService = locator<AppService>();

  List<Department> _departments = [];
  List<Department> _selectedDepartments = [];
  Branch? _selectedUserBranch;

  bool _isLoadingData = false;
  bool _isSubmitting = false;
  int? _removingDepartmentId;

  String? _error;

  @override
  void initState() {
    super.initState();
    //_loadData();
  }

  Future<void> _loadDepartments() async {
    try {
      debugPrint("Calling getDepartment endpoint...");
      final departmentsResponse = await _userApi.getDepartment(
        branchId: _selectedUserBranch!.id.toString(),
      );

      if (departmentsResponse.ok) {
        _departments = (departmentsResponse.data as List)
            .map((e) => Department.fromJson(e as Map<String, dynamic>))
            .toList();
        debugPrint(
          "getDepartment succeeded: ${_departments.length} departments loaded",
        );
      } else {
        throw Exception(
          'Departments endpoint failed: ${departmentsResponse.message ?? "Unknown error"}',
        );
      }
    } catch (e) {
      debugPrint("ERROR in _loadDepartments: $e");
      throw Exception('Departments endpoint error: $e');
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoadingData = true;
      _error = null;
    });

    try {
      await _loadDepartments();

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

  Future<void> _removeDepartment(int? departmentId) async {
    if (departmentId == null) return;

    // Show confirmation dialog
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Department'),
        content: const Text(
          'Are you sure you want to remove this department assignment?',
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
      _removingDepartmentId = departmentId;
    });

    try {
      final payload = {
        "user_ids": [widget.user.id],
        "department_ids": [departmentId],
      };

      final response = await _userApi.unassignUserFromDepartment(payload);

      if (mounted) {
        setState(() {
          _removingDepartmentId = null;
        });

        if (response.ok) {
          // Notify listeners to reload
          widget.reloadController?.add(true);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response.message ?? 'Department removed successfully',
              ),
              backgroundColor: Colors.green,
            ),
          );
          // Refresh the page or pop with result to reload user data
          Navigator.of(context).pop(true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'Failed to remove department'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _removingDepartmentId = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Map<String, dynamic> _prepareAssignmentPayload() {
    return {
      "department_ids": _selectedDepartments.map((d) => d.id).toList(),
      "user_ids": [widget.user.id],
    };
  }

  Future<void> _submitAssignment() async {
    if (_selectedDepartments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one department'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final payload = _prepareAssignmentPayload();
      final response = await _userApi.assignUserToDepartment(payload);

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

  List<Department> _getAvailableDepartments() {
    final userDepartmentIds =
        widget.user.departments?.map((d) => d.id).toSet() ?? {};
    final selectedBranchId = _selectedUserBranch?.id;

    return _departments
        .where(
          (dept) =>
              !userDepartmentIds.contains(dept.id) &&
              (selectedBranchId == null || dept.branchId == selectedBranchId),
        )
        .toList();
  }

  Map<String, List<Department>> _groupDepartmentsByBranch() {
    final Map<String, List<Department>> grouped = {};

    if (widget.user.departments == null || widget.user.departments!.isEmpty) {
      return grouped;
    }

    for (var department in widget.user.departments!) {
      final branchName = department.branch?.branchName ?? 'Unknown Branch';
      if (!grouped.containsKey(branchName)) {
        grouped[branchName] = [];
      }
      grouped[branchName]!.add(department);
    }

    return grouped;
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
                  PageTitle(name: "Assign Staff to Departments"),
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
                              const Text("Assign user to departments"),
                              const SizedBox(height: 25),

                              // Current Departments Section - Grouped by Branch
                              if (widget.user.departments != null &&
                                  widget.user.departments!.isNotEmpty) ...[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Current Departments',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ...() {
                                      final groupedDepartments =
                                          _groupDepartmentsByBranch();
                                      return groupedDepartments.entries.map((
                                        entry,
                                      ) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Branch Name Header
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryColor
                                                    .withAlpha(15),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.business,
                                                    size: 14,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    entry.key,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            // Department Chips
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: entry.value.map((
                                                department,
                                              ) {
                                                final isRemoving =
                                                    _removingDepartmentId ==
                                                    department.id;
                                                return Chip(
                                                  backgroundColor: AppColors
                                                      .primaryColor
                                                      .withAlpha(25),
                                                  label: Text(
                                                    department.name ?? 'N/A',
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
                                                      : () => _removeDepartment(
                                                          department.id,
                                                        ),
                                                );
                                              }).toList(),
                                            ),
                                            const SizedBox(height: 12),
                                          ],
                                        );
                                      }).toList();
                                    }(),
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

                              // Branch Selection
                              if (widget.user.branches != null &&
                                  widget.user.branches!.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    DropdownButtonFormField<int>(
                                      initialValue: _selectedUserBranch?.id,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Select a branch',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[600],
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
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: AppColors.primaryColor,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                      ),
                                      items: widget.user.branches!.map((
                                        branch,
                                      ) {
                                        return DropdownMenuItem<int>(
                                          value: branch.id,
                                          child: Text(branch.branchName ?? ''),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            _selectedUserBranch = widget
                                                .user
                                                .branches!
                                                .firstWhere(
                                                  (b) => b.id == value,
                                                );
                                            // Clear selected departments when branch changes
                                            _selectedDepartments.clear();
                                            _loadData();
                                          });
                                        }
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
                              if (widget.user.branches != null &&
                                  widget.user.branches!.isNotEmpty)
                                const SizedBox(height: 15),

                              // Department Multi-Select
                              if (_selectedUserBranch != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Branch Name Header
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor.withAlpha(
                                          25,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.business,
                                            size: 16,
                                            color: AppColors.primaryColor,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Departments in: ${_selectedUserBranch!.branchName ?? "N/A"}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    RichText(
                                      text: const TextSpan(
                                        text: 'Select Departments',
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
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF9FAFB),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Colors.black12,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (_selectedDepartments.isNotEmpty)
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: _selectedDepartments
                                                  .map((dept) {
                                                    return Chip(
                                                      label: Text(
                                                        dept.name ?? '',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      deleteIcon: const Icon(
                                                        Icons.close,
                                                        size: 16,
                                                      ),
                                                      onDeleted: () {
                                                        setState(() {
                                                          _selectedDepartments
                                                              .remove(dept);
                                                        });
                                                      },
                                                    );
                                                  })
                                                  .toList(),
                                            ),
                                          const SizedBox(height: 8),
                                          PopupMenuButton<Department>(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.black26,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.add,
                                                    size: 16,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'Add Department',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            itemBuilder: (context) {
                                              final availableDepartments =
                                                  _getAvailableDepartments()
                                                      .where(
                                                        (dept) =>
                                                            !_selectedDepartments
                                                                .contains(dept),
                                                      )
                                                      .toList();

                                              if (availableDepartments
                                                  .isEmpty) {
                                                return [
                                                  const PopupMenuItem<
                                                    Department
                                                  >(
                                                    enabled: false,
                                                    child: Text(
                                                      'No departments available',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ];
                                              }

                                              return availableDepartments.map((
                                                dept,
                                              ) {
                                                return PopupMenuItem<
                                                  Department
                                                >(
                                                  value: dept,
                                                  child: Text(dept.name ?? ''),
                                                );
                                              }).toList();
                                            },
                                            onSelected: (Department dept) {
                                              setState(() {
                                                _selectedDepartments.add(dept);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
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
