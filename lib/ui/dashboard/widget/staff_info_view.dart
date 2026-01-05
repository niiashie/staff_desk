import 'package:flutter/material.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/models/navigation_item.dart';
import 'package:leave_desk/models/user.dart';
import 'package:leave_desk/services/app_service.dart';
import 'package:leave_desk/ui/dashboard/widget/edit_staff_info_view.dart';
import 'package:leave_desk/utils.dart';

class StaffInfoView extends StatefulWidget {
  final User user;

  const StaffInfoView({super.key, required this.user});

  @override
  State<StaffInfoView> createState() => _StaffInfoViewState();
}

class _StaffInfoViewState extends State<StaffInfoView> {
  var appService = locator<AppService>();
  @override
  void initState() {
    debugPrint("completeness : ${widget.user.percentageCompleteness}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          // Profile Completeness Widget
          _buildProfileCompletenessWidget(),
          SizedBox(height: 20),

          // Bio Data Section
          _buildBioDataSection(),
          SizedBox(height: 20),

          // Employment Record Section
          _buildEmploymentRecordSection(),
          SizedBox(height: 20),

          // Family Data Section
          _buildFamilyDataSection(),
          SizedBox(height: 20),

          // Education & Training Section
          _buildEducationTrainingSection(),
          SizedBox(height: 20),

          // Emergency Contacts Section
          _buildEmergencyContactsSection(),
          SizedBox(height: 20),

          // Beneficiaries Section
          _buildBeneficiariesSection(),
          SizedBox(height: 20),

          // Referees Section
          _buildRefereesSection(),
          SizedBox(height: 20),

          // Branches & Departments Section
          if ((widget.user.branches != null &&
                  widget.user.branches!.isNotEmpty) ||
              (widget.user.departments != null &&
                  widget.user.departments!.isNotEmpty))
            _buildBranchesDepartmentsSection(),

          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildProfileCompletenessWidget() {
    final completeness = widget.user.percentageCompleteness ?? 0;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: completeness >= 80
              ? [Colors.green.shade400, Colors.green.shade600]
              : completeness >= 50
              ? [Colors.orange.shade400, Colors.orange.shade600]
              : [Colors.red.shade400, Colors.red.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                (completeness >= 80
                        ? Colors.green
                        : completeness >= 50
                        ? Colors.orange
                        : Colors.red)
                    .withValues(alpha: 0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$completeness%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile Completeness',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  completeness >= 80
                      ? 'Your profile is looking great!'
                      : completeness >= 50
                      ? 'Almost there! Keep adding details.'
                      : 'Please complete your profile information.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: completeness / 100,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBioDataSection() {
    final bioData = widget.user.bioData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'Personal Information',
          Icons.person_outline,
          Colors.purple,
          onEdit: () {
            appService.controller.add(
              NavigationItem("Edit Staff Details", "/editStaff", "sub"),
            );

            Navigator.of(Utils.sideMenuNavigationKey.currentContext!).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return EditStaffInfoView(
                    user: widget.user,
                    category: EditCategory.bioData,
                  );
                },
              ),
            );
          },
        ),
        SizedBox(height: 12),
        if (bioData == null)
          _buildPendingWidget(
            'Personal information has not been provided yet.',
            Colors.purple,
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              if (bioData.surname != null || bioData.otherNames != null)
                _buildInfoCard(
                  'Full Name',
                  '${bioData.surname ?? ''} ${bioData.otherNames ?? ''}',
                  Icons.person,
                  Colors.purple,
                ),
              if (bioData.gender != null)
                _buildInfoCard(
                  'Gender',
                  bioData.gender!,
                  Icons.wc,
                  Colors.purple,
                ),
              if (bioData.dateOfBirth != null)
                _buildInfoCard(
                  'Date of Birth',
                  bioData.dateOfBirth!,
                  Icons.cake,
                  Colors.purple,
                ),
              if (bioData.nationality != null)
                _buildInfoCard(
                  'Nationality',
                  bioData.nationality!,
                  Icons.flag,
                  Colors.purple,
                ),
              if (bioData.homeTown != null)
                _buildInfoCard(
                  'Home Town',
                  bioData.homeTown!,
                  Icons.home,
                  Colors.purple,
                ),
              if (bioData.region != null)
                _buildInfoCard(
                  'Region',
                  bioData.region!,
                  Icons.location_on,
                  Colors.purple,
                ),
              if (bioData.emailAddress != null)
                _buildInfoCard(
                  'Email',
                  bioData.emailAddress!,
                  Icons.email,
                  Colors.purple,
                ),
              if (bioData.telephone != null)
                _buildInfoCard(
                  'Phone',
                  bioData.telephone!,
                  Icons.phone,
                  Colors.purple,
                ),
              if (bioData.cityTown != null)
                _buildInfoCard(
                  'City/Town',
                  bioData.cityTown!,
                  Icons.location_city,
                  Colors.purple,
                ),
              if (bioData.digitalAddress != null)
                _buildInfoCard(
                  'Digital Address',
                  bioData.digitalAddress!,
                  Icons.pin_drop,
                  Colors.purple,
                ),
              if (bioData.bank != null)
                _buildInfoCard(
                  'Bank',
                  bioData.bank!,
                  Icons.account_balance,
                  Colors.purple,
                ),
              if (bioData.accountName != null)
                _buildInfoCard(
                  'Account Name',
                  bioData.accountName!,
                  Icons.account_circle,
                  Colors.purple,
                ),
              if (bioData.socialSecurityNumber != null)
                _buildInfoCard(
                  'SSN',
                  bioData.socialSecurityNumber!,
                  Icons.badge,
                  Colors.purple,
                ),
              if (bioData.languagesSpoken != null &&
                  bioData.languagesSpoken!.isNotEmpty)
                _buildInfoCard(
                  'Languages',
                  bioData.languagesSpoken!.join(', '),
                  Icons.language,
                  Colors.purple,
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildEmploymentRecordSection() {
    final employment = widget.user.employmentRecord;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'Employment Record',
          Icons.work_outline,
          Colors.orange,
          onEdit: () {
            appService.controller.add(
              NavigationItem(
                "Edit Employment Record",
                "/editEmployment",
                "sub",
              ),
            );

            Navigator.of(Utils.sideMenuNavigationKey.currentContext!).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return EditStaffInfoView(
                    user: widget.user,
                    category: EditCategory.employmentRecord,
                  );
                },
              ),
            );
          },
        ),
        SizedBox(height: 12),
        if (employment == null)
          _buildPendingWidget(
            'Employment record has not been provided yet.',
            Colors.orange,
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              if (employment.presentJobTitle != null)
                _buildInfoCard(
                  'Job Title',
                  employment.presentJobTitle!,
                  Icons.work,
                  Colors.orange,
                ),
              if (employment.employmentStatus != null)
                _buildInfoCard(
                  'Employment Status',
                  employment.employmentStatus!,
                  Icons.badge,
                  Colors.orange,
                ),
              if (employment.dateOfEmployment != null)
                _buildInfoCard(
                  'Employment Date',
                  employment.dateOfEmployment!,
                  Icons.calendar_today,
                  Colors.orange,
                ),
              if (employment.probationPeriod != null)
                _buildInfoCard(
                  'Probation Period',
                  employment.probationPeriod!,
                  Icons.schedule,
                  Colors.orange,
                ),
              if (employment.immediateSupervisor != null)
                _buildInfoCard(
                  'Supervisor',
                  employment.immediateSupervisor!,
                  Icons.supervisor_account,
                  Colors.orange,
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildFamilyDataSection() {
    final familyData = widget.user.familyData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'Family Information',
          Icons.family_restroom,
          Colors.pink,
          onEdit: () {
            appService.controller.add(
              NavigationItem("Edit Family Information", "/editFamily", "sub"),
            );

            Navigator.of(Utils.sideMenuNavigationKey.currentContext!).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return EditStaffInfoView(
                    user: widget.user,
                    category: EditCategory.familyData,
                  );
                },
              ),
            );
          },
        ),
        SizedBox(height: 12),
        if (familyData == null)
          _buildPendingWidget(
            'Family information has not been provided yet.',
            Colors.pink,
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              if (familyData.maritalStatus != null)
                _buildInfoCard(
                  'Marital Status',
                  familyData.maritalStatus!,
                  Icons.favorite,
                  Colors.pink,
                ),
              if (familyData.spouseName != null)
                _buildInfoCard(
                  'Spouse Name',
                  familyData.spouseName!,
                  Icons.person,
                  Colors.pink,
                ),
              if (familyData.spouseOccupation != null)
                _buildInfoCard(
                  'Spouse Occupation',
                  familyData.spouseOccupation!,
                  Icons.work,
                  Colors.pink,
                ),
              if (familyData.fatherName != null)
                _buildInfoCard(
                  'Father Name',
                  familyData.fatherName!,
                  Icons.person,
                  Colors.pink,
                ),
              if (familyData.motherName != null)
                _buildInfoCard(
                  'Mother Name',
                  familyData.motherName!,
                  Icons.person,
                  Colors.pink,
                ),
              if (familyData.numberOfChildren != null)
                _buildInfoCard(
                  'Number of Children',
                  familyData.numberOfChildren!,
                  Icons.child_care,
                  Colors.pink,
                ),
              // Display children details
              if (familyData.children != null &&
                  familyData.children!.isNotEmpty)
                ...familyData.children!.map((child) {
                  return _buildInfoCard(
                    'Child: ${child.name ?? 'N/A'}',
                    'Date of Birth: ${child.dateOfBirth ?? 'N/A'}',
                    Icons.child_friendly,
                    Colors.pink,
                  );
                }),
            ],
          ),
      ],
    );
  }

  Widget _buildEducationTrainingSection() {
    final education = widget.user.educationTraining;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'Education & Training',
          Icons.school_outlined,
          Colors.teal,
          onEdit: () {
            appService.controller.add(
              NavigationItem(
                "Edit Education & Training",
                "/editEducation",
                "sub",
              ),
            );

            Navigator.of(Utils.sideMenuNavigationKey.currentContext!).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return EditStaffInfoView(
                    user: widget.user,
                    category: EditCategory.educationTraining,
                  );
                },
              ),
            );
          },
        ),
        SizedBox(height: 12),
        if (education == null)
          _buildPendingWidget(
            'Education and training information has not been provided yet.',
            Colors.teal,
          )
        else if (education.academicQualifications != null &&
            education.academicQualifications!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  'Academic Qualifications',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal.shade700,
                  ),
                ),
              ),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: education.academicQualifications!.map((qual) {
                  return _buildInfoCard(
                    qual.qualification ?? 'N/A',
                    '${qual.institution ?? 'N/A'} - ${qual.year ?? 'N/A'}',
                    Icons.school,
                    Colors.teal,
                  );
                }).toList(),
              ),
            ],
          ),
        if (education != null &&
            education.trainings != null &&
            education.trainings!.isNotEmpty) ...[
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              'Professional Training',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.teal.shade700,
              ),
            ),
          ),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: education.trainings!.map((training) {
              return _buildInfoCard(
                training.course ?? 'N/A',
                '${training.institution ?? 'N/A'} - ${training.year ?? 'N/A'}',
                Icons.workspace_premium,
                Colors.teal,
              );
            }).toList(),
          ),
        ],
        if (education != null &&
            (education.academicQualifications == null ||
                education.academicQualifications!.isEmpty) &&
            (education.trainings == null || education.trainings!.isEmpty))
          _buildPendingWidget(
            'Education and training information has not been provided yet.',
            Colors.teal,
          ),
      ],
    );
  }

  Widget _buildEmergencyContactsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'Emergency Contacts',
          Icons.emergency,
          Colors.red,
          onEdit: () {
            appService.controller.add(
              NavigationItem(
                "Edit Emergency Contacts",
                "/editEmergency",
                "sub",
              ),
            );

            Navigator.of(Utils.sideMenuNavigationKey.currentContext!).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return EditStaffInfoView(
                    user: widget.user,
                    category: EditCategory.emergencyContacts,
                  );
                },
              ),
            );
          },
        ),
        SizedBox(height: 12),
        if (widget.user.emergencies == null || widget.user.emergencies!.isEmpty)
          _buildPendingWidget(
            'Emergency contacts have not been provided yet.',
            Colors.red,
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: widget.user.emergencies!.map((emergency) {
              return _buildInfoCard(
                emergency.name ?? 'N/A',
                '${emergency.telephoneNumber ?? 'N/A'}\n${emergency.address ?? 'N/A'}',
                Icons.contact_emergency,
                Colors.red,
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildBeneficiariesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'Beneficiaries',
          Icons.people_outline,
          Colors.green,
          onEdit: () {
            appService.controller.add(
              NavigationItem("Edit Beneficiaries", "/editBeneficiaries", "sub"),
            );

            Navigator.of(Utils.sideMenuNavigationKey.currentContext!).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return EditStaffInfoView(
                    user: widget.user,
                    category: EditCategory.beneficiaries,
                  );
                },
              ),
            );
          },
        ),
        SizedBox(height: 12),
        if (widget.user.beneficiaries == null ||
            widget.user.beneficiaries!.isEmpty)
          _buildPendingWidget(
            'Beneficiaries information has not been provided yet.',
            Colors.green,
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: widget.user.beneficiaries!.map((beneficiary) {
              return _buildInfoCard(
                beneficiary.name ?? 'N/A',
                '${beneficiary.relationship ?? 'N/A'} - ${beneficiary.percentageOfBenefit ?? 0}%',
                Icons.person_add,
                Colors.green,
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildRefereesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'Referees',
          Icons.supervisor_account,
          Colors.indigo,
          onEdit: () {
            appService.controller.add(
              NavigationItem("Edit Referees", "/editReferees", "sub"),
            );

            Navigator.of(Utils.sideMenuNavigationKey.currentContext!).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return EditStaffInfoView(
                    user: widget.user,
                    category: EditCategory.referees,
                  );
                },
              ),
            );
          },
        ),
        SizedBox(height: 12),
        if (widget.user.referees == null || widget.user.referees!.isEmpty)
          _buildPendingWidget(
            'Referees information has not been provided yet.',
            Colors.indigo,
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: widget.user.referees!.map((referee) {
              return _buildInfoCard(
                referee.name ?? 'N/A',
                '${referee.occupation ?? 'N/A'}\n${referee.address ?? 'N/A'}',
                Icons.person_pin,
                Colors.indigo,
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildBranchesDepartmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Organization', Icons.business, Colors.cyan),
        SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            if (widget.user.branches != null)
              ...widget.user.branches!.map((branch) {
                return _buildInfoCard(
                  'Branch',
                  '${branch.branchName ?? 'N/A'}\n${branch.city ?? 'N/A'}',
                  Icons.business,
                  Colors.cyan,
                );
              }),
            if (widget.user.departments != null)
              ...widget.user.departments!.map((dept) {
                return _buildInfoCard(
                  'Department',
                  dept.name ?? 'N/A',
                  Icons.apartment,
                  Colors.cyan,
                );
              }),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(
    String title,
    IconData icon,
    Color color, {
    VoidCallback? onEdit,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
        if (onEdit != null)
          IconButton(
            icon: Icon(Icons.edit, color: color, size: 20),
            onPressed: onEdit,
            tooltip: 'Edit $title',
          ),
      ],
    );
  }

  Widget _buildPendingWidget(String message, Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          style: BorderStyle.solid,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: color.withValues(alpha: 0.6),
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
