import 'package:flutter/material.dart';
import 'package:student_attendance/features/student/student.dart';

class StudentTodayClassTile extends StatelessWidget {
  const StudentTodayClassTile({super.key, required this.item});
  final TodayClassItem item;

  @override
  Widget build(BuildContext context) {
    final timeText = _timeRange(item.startAt, item.endAt);
    final status = item.status;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  timeText,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          StudentStatusPill(status: status),
        ],
      ),
    );
  }

  String _timeRange(DateTime start, DateTime? end) {
    String fmt(DateTime d) {
      final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
      final m = d.minute.toString().padLeft(2, '0');
      final ampm = d.hour >= 12 ? 'PM' : 'AM';
      return '$h:$m $ampm';
    }

    if (end == null) return fmt(start);
    return '${fmt(start)} - ${fmt(end)}';
  }
}
