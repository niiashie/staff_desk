import 'package:flutter/material.dart';
import 'package:leave_desk/models/user.dart';

class ViewStaffView extends StatefulWidget {
  final User user;
  const ViewStaffView({super.key, required this.user});

  @override
  State<ViewStaffView> createState() => _ViewStaffViewState();
}

class _ViewStaffViewState extends State<ViewStaffView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          widget.user.name ?? 'Staff Details',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black87),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade600],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  '${widget.user.percentageCompleteness ?? 0}% Complete',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Card
            _buildProfileHeader(),
            SizedBox(height: 20),

            // Bio Data Card
            if (widget.user.bioData != null) _buildBioDataCard(),
            if (widget.user.bioData != null) SizedBox(height: 16),

            // Family Data Card
            if (widget.user.familyData != null) _buildFamilyDataCard(),
            if (widget.user.familyData != null) SizedBox(height: 16),

            // Employment Record Card
            if (widget.user.employmentRecord != null)
              _buildEmploymentRecordCard(),
            if (widget.user.employmentRecord != null) SizedBox(height: 16),

            // Education Training Card
            if (widget.user.educationTraining != null)
              _buildEducationTrainingCard(),
            if (widget.user.educationTraining != null) SizedBox(height: 16),

            // Emergency Contacts Card
            if (widget.user.emergencies != null &&
                widget.user.emergencies!.isNotEmpty)
              _buildEmergencyContactsCard(),
            if (widget.user.emergencies != null &&
                widget.user.emergencies!.isNotEmpty)
              SizedBox(height: 16),

            // Beneficiaries Card
            if (widget.user.beneficiaries != null &&
                widget.user.beneficiaries!.isNotEmpty)
              _buildBeneficiariesCard(),
            if (widget.user.beneficiaries != null &&
                widget.user.beneficiaries!.isNotEmpty)
              SizedBox(height: 16),

            // Referees Card
            if (widget.user.referees != null &&
                widget.user.referees!.isNotEmpty)
              _buildRefereesCard(),
            if (widget.user.referees != null &&
                widget.user.referees!.isNotEmpty)
              SizedBox(height: 16),

            // Branches Card
            if (widget.user.branches != null &&
                widget.user.branches!.isNotEmpty)
              _buildBranchesCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: widget.user.bioData?.image != null
                ? ClipOval(
                    child: Image.network(
                      widget.user.bioData!.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.person, size: 40, color: Colors.blue);
                      },
                    ),
                  )
                : Icon(Icons.person, size: 40, color: Colors.blue),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name ?? 'N/A',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.badge, color: Colors.white70, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'PIN: ${widget.user.pin ?? 'N/A'}',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.admin_panel_settings,
                      color: Colors.white70,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      widget.user.role?.name ?? 'No Role',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.user.status == 'active'
                        ? Colors.green
                        : Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.user.status?.toUpperCase() ?? 'N/A',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBioDataCard() {
    final bioData = widget.user.bioData!;
    return _buildExpandableCard(
      title: 'Bio Data',
      icon: Icons.person_outline,
      color: Colors.purple,
      children: [
        _buildInfoRow(
          'Full Name',
          '${bioData.surname ?? ''} ${bioData.otherNames ?? ''}',
        ),
        _buildInfoRow('Gender', bioData.gender ?? 'N/A'),
        _buildInfoRow('Date of Birth', bioData.dateOfBirth ?? 'N/A'),
        _buildInfoRow('Nationality', bioData.nationality ?? 'N/A'),
        _buildInfoRow('Home Town', bioData.homeTown ?? 'N/A'),
        _buildInfoRow('Region', bioData.region ?? 'N/A'),
        Divider(height: 24),
        _buildSectionTitle('Contact Information'),
        _buildInfoRow(
          'Email',
          bioData.emailAddress ?? 'N/A',
          icon: Icons.email_outlined,
        ),
        _buildInfoRow(
          'Telephone',
          bioData.telephone ?? 'N/A',
          icon: Icons.phone_outlined,
        ),
        _buildInfoRow(
          'Address',
          '${bioData.houseNumber ?? ''}, ${bioData.streetName ?? ''}, ${bioData.cityTown ?? ''}',
        ),
        _buildInfoRow('Digital Address', bioData.digitalAddress ?? 'N/A'),
        _buildInfoRow('Post Address', bioData.postAddress ?? 'N/A'),
        Divider(height: 24),
        _buildSectionTitle('Banking Information'),
        _buildInfoRow(
          'Bank',
          bioData.bank ?? 'N/A',
          icon: Icons.account_balance,
        ),
        _buildInfoRow('Branch', bioData.branchName ?? 'N/A'),
        _buildInfoRow('Account Name', bioData.accountName ?? 'N/A'),
        _buildInfoRow('SSN', bioData.socialSecurityNumber ?? 'N/A'),
        Divider(height: 24),
        _buildSectionTitle('Other Information'),
        _buildInfoRow(
          'Languages Spoken',
          bioData.languagesSpoken?.join(', ') ?? 'N/A',
        ),
        _buildInfoRow(
          'Physical Disability',
          bioData.physicalDisability ?? 'N/A',
        ),
      ],
    );
  }

  Widget _buildFamilyDataCard() {
    final familyData = widget.user.familyData!;
    return _buildExpandableCard(
      title: 'Family Data',
      icon: Icons.family_restroom,
      color: Colors.pink,
      children: [
        _buildInfoRow('Marital Status', familyData.maritalStatus ?? 'N/A'),
        _buildInfoRow('Spouse Name', familyData.spouseName ?? 'N/A'),
        _buildInfoRow(
          'Spouse Occupation',
          familyData.spouseOccupation ?? 'N/A',
        ),
        Divider(height: 24),
        _buildSectionTitle('Parents Information'),
        _buildInfoRow('Father Name', familyData.fatherName ?? 'N/A'),
        _buildInfoRow(
          'Father Status',
          familyData.fatherIsDeceased == 'Yes' ? 'Deceased' : 'Alive',
          icon: Icons.info_outline,
        ),
        _buildInfoRow('Mother Name', familyData.motherName ?? 'N/A'),
        _buildInfoRow(
          'Mother Status',
          familyData.motherIsDeceased == 'Yes' ? 'Deceased' : 'Alive',
          icon: Icons.info_outline,
        ),
        _buildInfoRow('Number of Children', familyData.numberOfChildren ?? '0'),
      ],
    );
  }

  Widget _buildEmploymentRecordCard() {
    final employment = widget.user.employmentRecord!;
    debugPrint(
      'Previous Work Places: ${employment.previousWorkPlaces?.length}',
    );
    if (employment.previousWorkPlaces != null) {
      for (var workplace in employment.previousWorkPlaces!) {
        debugPrint('Workplace: ${workplace.companyInstitution}');
      }
    }
    return _buildExpandableCard(
      title: 'Employment Record',
      icon: Icons.work_outline,
      color: Colors.orange,
      children: [
        _buildInfoRow('Current Job Title', employment.presentJobTitle ?? 'N/A'),
        _buildInfoRow(
          'Employment Status',
          employment.employmentStatus ?? 'N/A',
        ),
        _buildInfoRow(
          'Date of Employment',
          employment.dateOfEmployment ?? 'N/A',
        ),
        _buildInfoRow('Probation Period', employment.probationPeriod ?? 'N/A'),
        _buildInfoRow(
          'Immediate Supervisor',
          employment.immediateSupervisor ?? 'N/A',
        ),
        if (employment.previousWorkPlaces != null &&
            employment.previousWorkPlaces!.isNotEmpty) ...[
          Divider(height: 24),
          _buildSectionTitle('Previous Work Places'),
          ...employment.previousWorkPlaces!.map(
            (workplace) => Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.business_center,
                        color: Colors.orange,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          workplace.companyInstitution ?? 'N/A',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  _buildInfoRow(
                    'Job Title',
                    workplace.jobTitle ?? 'N/A',
                    compact: true,
                  ),
                  _buildInfoRow(
                    'Period',
                    workplace.date ?? 'N/A',
                    compact: true,
                  ),
                ],
              ),
            ),
          ),
        ],
        Divider(height: 24),
        _buildSectionTitle('Career Objectives'),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            employment.careerObjects ?? 'N/A',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationTrainingCard() {
    final education = widget.user.educationTraining!;
    return _buildExpandableCard(
      title: 'Education & Training',
      icon: Icons.school_outlined,
      color: Colors.teal,
      children: [
        _buildInfoRow(
          'Academic Qualifications',
          education.numberOfAcademicQualifications ?? '0',
          icon: Icons.school,
        ),
        _buildInfoRow(
          'Professional Training',
          education.numberOfProfessionalTraining ?? '0',
          icon: Icons.workspace_premium,
        ),
        Divider(height: 24),
        _buildSectionTitle('Hobbies & Special Interests'),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            education.hobbiesSpecialInterest ?? 'N/A',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyContactsCard() {
    return _buildExpandableCard(
      title: 'Emergency Contacts',
      icon: Icons.emergency,
      color: Colors.red,
      children: widget.user.emergencies!.map((emergency) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.red.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person, color: Colors.red, size: 18),
                  SizedBox(width: 8),
                  Text(
                    emergency.name ?? 'N/A',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _buildInfoRow(
                'Address',
                emergency.address ?? 'N/A',
                compact: true,
              ),
              _buildInfoRow(
                'Phone',
                emergency.telephoneNumber ?? 'N/A',
                compact: true,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBeneficiariesCard() {
    return _buildExpandableCard(
      title: 'Beneficiaries',
      icon: Icons.people_outline,
      color: Colors.green,
      children: widget.user.beneficiaries!.map((beneficiary) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.green.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.green, size: 18),
                      SizedBox(width: 8),
                      Text(
                        beneficiary.name ?? 'N/A',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${beneficiary.percentageOfBenefit ?? 0}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _buildInfoRow(
                'Relationship',
                beneficiary.relationship ?? 'N/A',
                compact: true,
              ),
              _buildInfoRow(
                'Contact',
                beneficiary.addressTelephoneNumber ?? 'N/A',
                compact: true,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRefereesCard() {
    return _buildExpandableCard(
      title: 'Referees',
      icon: Icons.supervisor_account,
      color: Colors.indigo,
      children: widget.user.referees!.map((referee) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.indigo.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person, color: Colors.indigo, size: 18),
                  SizedBox(width: 8),
                  Text(
                    referee.name ?? 'N/A',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _buildInfoRow(
                'Occupation',
                referee.occupation ?? 'N/A',
                compact: true,
              ),
              _buildInfoRow('Address', referee.address ?? 'N/A', compact: true),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBranchesCard() {
    return _buildExpandableCard(
      title: 'Branches',
      icon: Icons.business,
      color: Colors.cyan,
      children: widget.user.branches!.map((branch) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.cyan.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.cyan.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.business, color: Colors.cyan, size: 18),
                  SizedBox(width: 8),
                  Text(
                    branch.branchName ?? 'N/A',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _buildInfoRow('Address', branch.address ?? 'N/A', compact: true),
              _buildInfoRow('City', branch.city ?? 'N/A', compact: true),
              if (branch.phoneNumber != null)
                _buildInfoRow('Phone', branch.phoneNumber!, compact: true),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExpandableCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.blue.shade700,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    IconData? icon,
    bool compact = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: compact ? 4 : 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: Colors.grey[600]),
            SizedBox(width: 8),
          ],
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: compact ? 13 : 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: compact ? 13 : 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
