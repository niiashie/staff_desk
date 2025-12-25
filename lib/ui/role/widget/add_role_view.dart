import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/models/role.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/custom_form_field.dart';
import 'package:leave_desk/shared/page_title.dart';
import 'package:leave_desk/ui/role/role_view_nodel.dart';
import 'package:stacked/stacked.dart';

class AddRoleView extends StackedView<RoleViewNodel> {
  final Role? role;
  const AddRoleView({Key? key, this.role}) : super(key: key);

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => true;

  @override
  void onViewModelReady(RoleViewNodel viewModel) async {
    viewModel.init(role: role);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
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
            PageTitle(name: role != null ? "Update Role" : "Add Role"),

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
                  key: viewModel.addRoleFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Provide the details required to create user role",
                        ),
                        const SizedBox(height: 25),

                        CustomFormField(
                          label: "Role Name",
                          hintText: "Enter role name",
                          controller: viewModel.nameController,
                          filled: true,
                          isImportant: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Role name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        CustomFormField(
                          label: "Description",
                          hintText: "Enter role description",
                          controller: viewModel.descriptionController,
                          filled: true,
                          isImportant: true,
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Description is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        CustomFormField(
                          label: "Level",
                          hintText: "Enter role level",
                          controller: viewModel.levelController,
                          filled: true,
                          isImportant: true,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Level is required';
                            }
                            final level = int.tryParse(value);
                            if (level == null) {
                              return 'Level must be a valid number';
                            }
                            if (level < 0) {
                              return 'Level must be a positive number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                title: const Text("Is System Role"),
                                value: viewModel.isSystemRole,
                                onChanged: (value) {
                                  viewModel.setIsSystemRole(value ?? false);
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                title: const Text("Role is active"),
                                value: viewModel.isActive,
                                onChanged: (value) {
                                  viewModel.setIsActive(value ?? false);
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),

                        Align(
                          alignment: Alignment.bottomRight,
                          child: CustomButton(
                            width: 100,
                            isLoading: viewModel.busy("addRoleLoader"),
                            height: 40,
                            color: AppColors.primaryColor,
                            elevation: 2,
                            title: Text(
                              role != null ? "Update" : "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                            ontap: () {
                              role != null
                                  ? viewModel.updateRole(role!.id!)
                                  : viewModel.submitRole();
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
  RoleViewNodel viewModelBuilder(BuildContext context) => RoleViewNodel();
}
