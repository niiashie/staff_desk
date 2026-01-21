import 'package:flutter/material.dart';
import 'package:leave_desk/models/age_category.dart';
import 'package:intl/intl.dart';

class StaffListView extends StatelessWidget {
  final List<AgeCategoryStaff> staff;
  final Color color;

  const StaffListView({
    super.key,
    required this.staff,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (staff.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            'No staff in this category',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: staff.map((staffMember) {
          return _buildStaffItem(staffMember);
        }).toList(),
      ),
    );
  }

  Widget _buildStaffItem(AgeCategoryStaff staffMember) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    String? formattedDOB;
    if (staffMember.dateOfBirth != null) {
      try {
        formattedDOB = dateFormat.format(DateTime.parse(staffMember.dateOfBirth!));
      } catch (e) {
        formattedDOB = staffMember.dateOfBirth;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          radius: 25,
          child: Text(
            staffMember.name != null && staffMember.name!.isNotEmpty
                ? staffMember.name![0].toUpperCase()
                : '?',
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                staffMember.name ?? 'N/A',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${staffMember.age ?? 'N/A'} yrs',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.cake, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  formattedDOB ?? 'N/A',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.badge, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  staffMember.role?.toUpperCase() ?? 'N/A',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (staffMember.departments != null &&
                staffMember.departments!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.business, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      staffMember.departments!.join(', '),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
