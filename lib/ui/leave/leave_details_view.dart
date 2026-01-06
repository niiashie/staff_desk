import 'package:flutter/material.dart';
import 'package:leave_desk/models/leave_request.dart';
import 'package:leave_desk/models/user.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/ui/leave/leave_view_model.dart';
import 'package:stacked/stacked.dart';

class LeaveDetailView extends StackedView<LeaveViewModel> {
  final LeaveRequest? leaveRequest;
  const LeaveDetailView({Key? key, this.leaveRequest}) : super(key: key);

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => true;

  @override
  void onViewModelReady(LeaveViewModel viewModel) async {
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    if (leaveRequest == null) {
      return Center(child: Text('No leave request data available'));
    }

    final isAdmin =
        viewModel.appService.currentUser?.role?.name?.toLowerCase().contains(
          'admin',
        ) ??
        false;

    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          // Page Title
          Text(
            'Leave Detail',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Container
                  _buildStatusContainer(leaveRequest!.status),
                  const SizedBox(height: 20),

                  // Leave Request Details
                  _buildLeaveDetailsSection(),
                  const SizedBox(height: 20),

                  // User Details
                  _buildUserSection(
                    'Requestor Details',
                    leaveRequest!.user,
                    Colors.purple,
                  ),
                  const SizedBox(height: 20),

                  // Hand Over Person Details
                  if (leaveRequest!.handOver != null)
                    _buildUserSection(
                      'Hand Over Person',
                      leaveRequest!.handOver,
                      Colors.orange,
                    ),
                  if (leaveRequest!.handOver != null)
                    const SizedBox(height: 20),

                  // Approver Details (if provided)
                  if (leaveRequest!.approver != null)
                    _buildUserSection(
                      'Approver Details',
                      leaveRequest!.approver,
                      Colors.green,
                    ),
                  if (leaveRequest!.approver != null)
                    const SizedBox(height: 20),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Action Buttons (Bottom Right)
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isAdmin) ...[
                  CustomButton(
                    width: 120,
                    height: 40,
                    elevation: 2,
                    isLoading: viewModel.busy("rejectLeaveLoader"),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.clear, color: Colors.white, size: 14),
                        const SizedBox(width: 15),
                        Text("Reject", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    color: Colors.redAccent,
                    ontap: () => viewModel.onRejectLeave(leaveRequest!),
                  ),
                  const SizedBox(width: 12),

                  // Approve Button
                  CustomButton(
                    width: 120,
                    height: 40,
                    elevation: 2,
                    isLoading: viewModel.busy("rejectLeaveLoader"),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.check, color: Colors.white, size: 14),
                        const SizedBox(width: 15),
                        Text("Approve", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    color: Colors.green,
                    ontap: () => viewModel.onApproveLeave(leaveRequest!),
                  ),
                ] else ...[
                  // Cancel Button (for non-admin users)
                  CustomButton(
                    width: 120,
                    height: 40,
                    elevation: 2,
                    isLoading: viewModel.busy("cancelLeaveLoader"),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.clear, color: Colors.white, size: 14),
                        const SizedBox(width: 15),
                        Text("Delete", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    color: Colors.redAccent,
                    ontap: () => viewModel.onCancelLeave(leaveRequest!.id),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusContainer(String? status) {
    final statusLower = status?.toLowerCase() ?? '';
    Color statusColor;
    IconData statusIcon;

    switch (statusLower) {
      case 'approved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 24),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                status?.toUpperCase() ?? 'UNKNOWN',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Leave Information', Icons.event_note, Colors.blue),
        SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            if (leaveRequest!.description != null)
              _buildInfoCard(
                'Leave Type',
                leaveRequest!.description!,
                Icons.description,
                Colors.blue,
              ),
            if (leaveRequest!.numberOfDays != null)
              _buildInfoCard(
                'Number of Days',
                '${leaveRequest!.numberOfDays} days',
                Icons.calendar_today,
                Colors.blue,
              ),
            if (leaveRequest!.startDate != null)
              _buildInfoCard(
                'Start Date',
                leaveRequest!.startDate!,
                Icons.event,
                Colors.blue,
              ),
            if (leaveRequest!.endDate != null)
              _buildInfoCard(
                'End Date',
                leaveRequest!.endDate!,
                Icons.event_available,
                Colors.blue,
              ),
            if (leaveRequest!.createdAt != null)
              _buildInfoCard(
                'Requested On',
                leaveRequest!.createdAt!.split('T')[0],
                Icons.access_time,
                Colors.blue,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserSection(String title, User? user, Color color) {
    if (user == null) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title, Icons.person, color),
        SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            if (user.name != null)
              _buildInfoCard('Full Name', user.name!, Icons.person, color),
            if (user.role?.name != null)
              _buildInfoCard('Role', user.role!.name!, Icons.badge, color),
            if (user.bioData?.emailAddress != null)
              _buildInfoCard(
                'Email',
                user.bioData!.emailAddress!,
                Icons.email,
                color,
              ),
            if (user.bioData?.telephone != null)
              _buildInfoCard(
                'Phone',
                user.bioData!.telephone!,
                Icons.phone,
                color,
              ),
            if (user.employmentRecord?.presentJobTitle != null)
              _buildInfoCard(
                'Job Title',
                user.employmentRecord!.presentJobTitle!,
                Icons.work,
                color,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
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
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
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

  @override
  LeaveViewModel viewModelBuilder(BuildContext context) => LeaveViewModel();
}
