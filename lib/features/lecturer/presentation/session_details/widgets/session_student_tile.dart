import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/lecturer/domain/entities/session_student_attendance.dart';

class SessionStudentTile extends StatelessWidget {
  const SessionStudentTile({super.key, required this.item});

  final SessionStudentAttendance item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final studentName = item.student.name?.trim().isNotEmpty == true
        ? item.student.name!
        : 'Student ${item.student.studentNumber ?? item.student.id}';
    final studentId = item.student.studentNumber ?? item.student.id;
    final statusLabel = _statusLabel(item.status);
    final statusColor = _statusColor(item.status);
    final checkInText = _checkInText(item.checkedInAt);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: _StatusDot(color: statusColor),
        title: Text(
          studentName,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          'ID: $studentId • $checkInText',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: _StatusBadge(label: statusLabel, color: statusColor),
      ),
    );
  }

  String _checkInText(DateTime? time) {
    if (time == null) return 'Not checked in';
    return DateFormat('h:mm a').format(time.toLocal());
  }

  String _statusLabel(AttendanceStatus? status) {
    if (status == AttendanceStatus.late) return 'Late';
    if (status == AttendanceStatus.present) return 'Present';
    return 'Absent';
  }

  Color _statusColor(AttendanceStatus? status) {
    if (status == AttendanceStatus.late) return AppColors.orange;
    if (status == AttendanceStatus.present) return AppColors.green;
    return AppColors.red;
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: color,
          fontSize: 12,
        ),
      ),
    );
  }
}
