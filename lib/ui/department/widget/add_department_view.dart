import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/models/department.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/custom_form_field.dart';
import 'package:leave_desk/shared/loading.dart';
import 'package:leave_desk/shared/page_title.dart';
import 'package:leave_desk/ui/department/department_view_model.dart';
import 'package:stacked/stacked.dart';

class AddDepartmentView extends StackedView<DepartmentViewModel> {
  final Department? department;
  const AddDepartmentView({Key? key, this.department}) : super(key: key);

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => true;

  @override
  void onViewModelReady(DepartmentViewModel viewModel) async {
    await viewModel.init(selectedDepartment: department);
    viewModel.init(selectedDepartment: department);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 35),
      child: viewModel.busy("loading")
          ? Center(child: Loading())
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  // PageTitle(name: role != null ? "Update Role" : "Add Role"),
                  PageTitle(
                    name: department != null
                        ? "Update Department"
                        : "Add Department",
                  ),
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
                        key: viewModel.addDepartmentFormKey,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Provide the details required to create department",
                              ),
                              const SizedBox(height: 25),

                              CustomFormField(
                                label: "Department Name",
                                hintText: "Enter department name",
                                controller: viewModel.nameController,
                                filled: true,
                                isImportant: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Department name is required';
                                  }
                                  if (value.trim().length > 255) {
                                    return 'Name must not exceed 255 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),

                              CustomFormField(
                                label: "Department Code",
                                hintText: "Enter department code",
                                controller: viewModel.codeController,
                                filled: true,
                                isImportant: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Department code is required';
                                  }
                                  if (value.trim().length > 50) {
                                    return 'Code must not exceed 50 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),

                              CustomFormField(
                                label: "Description",
                                hintText:
                                    "Enter department description (optional)",
                                controller: viewModel.descriptionController,
                                filled: true,
                                isImportant: false,
                                maxLines: 3,
                              ),
                              const SizedBox(height: 15),

                              // Branch Dropdown
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
                                    initialValue: viewModel.selectedBranchId,
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
                                    items: viewModel.branches.map((branch) {
                                      return DropdownMenuItem<int>(
                                        value: branch.id,
                                        child: Text(branch.branchName ?? ''),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      viewModel.setSelectedBranch(value);
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
                              const SizedBox(height: 15),

                              CheckboxListTile(
                                title: const Text("Department is active"),
                                value: viewModel.isActive,
                                onChanged: (value) {
                                  viewModel.setIsActive(value ?? false);
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                              ),
                              const SizedBox(height: 25),

                              Align(
                                alignment: Alignment.bottomRight,
                                child: CustomButton(
                                  width: 100,
                                  isLoading: viewModel.busy(
                                    "addDepartmentLoader",
                                  ),
                                  height: 40,
                                  color: AppColors.primaryColor,
                                  elevation: 2,
                                  title: Text(
                                    department != null ? "Update" : "Submit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  ontap: () {
                                    department != null
                                        ? viewModel.updateDepartment(
                                            department!,
                                          )
                                        : viewModel.addDepartment();
                                  },
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

  @override
  DepartmentViewModel viewModelBuilder(BuildContext context) =>
      DepartmentViewModel();
}
