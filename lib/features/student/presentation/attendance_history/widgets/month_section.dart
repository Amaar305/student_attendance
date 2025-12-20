import 'package:flutter/material.dart';
import 'package:student_attendance/features/student/presentation/attendance_history/utils/month_group.dart';

import 'attendance_history_tile.dart';

class MonthSection extends StatelessWidget {
  const MonthSection({super.key, required this.group});
  final MonthGroup group;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),
          ...group.items.map((item) => AttendanceHistoryTile(item: item)),
        ],
      ),
    );
  }
}
