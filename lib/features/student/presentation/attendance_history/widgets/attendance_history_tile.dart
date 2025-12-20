import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/student/domain/entities/student_attendance_item.dart';

import 'status_pill.dart';

class AttendanceHistoryTile extends StatelessWidget {
  const AttendanceHistoryTile({super.key, required this.item});
  final StudentAttendanceItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final dateStr = _formatShortDate(item.timestamp);
    final status = item.status;
    final statusLabel = status == AttendanceStatus.late ? 'Late' : 'Present';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.courseTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  dateStr,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          StatusPill(label: statusLabel, status: status),
        ],
      ),
    );
  }

  String _formatShortDate(DateTime d) {
    const wd = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final w = wd[d.weekday - 1];
    final m = months[d.month - 1];
    return '$w, $m ${d.day}, ${d.year}';
  }
}
