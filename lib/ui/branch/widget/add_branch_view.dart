import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/models/branch.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/shared/custom_form_field.dart';
import 'package:leave_desk/shared/page_title.dart';
import 'package:leave_desk/ui/branch/branch_view_model.dart';
import 'package:leave_desk/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddBranchView extends StackedView<BranchViewModel> {
  final Branch? branch;
  const AddBranchView({Key? key, this.branch}) : super(key: key);

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => true;

  @override
  void onViewModelReady(BranchViewModel viewModel) async {
    viewModel.init(branch: branch);
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
            // PageTitle(name: role != null ? "Update Role" : "Add Role"),
            PageTitle(name: branch != null ? "Update Branch" : "Add Branch"),
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
                  key: viewModel.addBranchFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Provide the details required to create branch",
                        ),
                        const SizedBox(height: 25),

                        CustomFormField(
                          label: "Branch Name",
                          hintText: "Enter branch name",
                          controller: viewModel.branchNameController,
                          filled: true,
                          isImportant: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Branch name is required';
                            }
                            if (value.trim().length > 255) {
                              return 'Branch name must not exceed 255 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        CustomFormField(
                          label: "Address",
                          hintText: "Enter branch address",
                          controller: viewModel.addressController,
                          filled: true,
                          isImportant: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Address is required';
                            }
                            if (value.trim().length > 255) {
                              return 'Address must not exceed 255 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        CustomFormField(
                          label: "City",
                          hintText: "Enter city",
                          controller: viewModel.cityController,
                          filled: true,
                          isImportant: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'City is required';
                            }
                            if (value.trim().length > 255) {
                              return 'City must not exceed 255 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        CustomFormField(
                          label: "Phone Number",
                          hintText: "Enter phone number",
                          controller: viewModel.phoneNumberController,
                          filled: true,
                          isImportant: true,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Phone number is required';
                            }
                            if (value.trim().length > 255) {
                              return 'Phone number must not exceed 255 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        CheckboxListTile(
                          title: const Text("Branch is active"),
                          value: viewModel.isActive,
                          onChanged: (value) {
                            viewModel.setIsActive(value ?? false);
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        const SizedBox(height: 25),

                        Align(
                          alignment: Alignment.bottomRight,
                          child: CustomButton(
                            width: 100,
                            isLoading: viewModel.busy("addBranchLoader"),
                            height: 40,
                            color: AppColors.primaryColor,
                            elevation: 2,
                            title: Text(
                              branch != null ? "Update" : "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                            ontap: () {
                              branch != null
                                  ? viewModel.updateBranch(branch!.id)
                                  : viewModel.submitBranch();
                              //viewModel.submitBranch();
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
  BranchViewModel viewModelBuilder(BuildContext context) => BranchViewModel();
}
