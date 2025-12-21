import 'package:flutter/material.dart';
import 'package:student_attendance/features/student/student.dart';

class StudentStatusPill extends StatelessWidget {
  const StudentStatusPill({super.key, required this.status});
  final ClassStatus status;

  @override
  Widget build(BuildContext context) {
    String label;
    Color bg;
    Color fg;

    switch (status) {
      case ClassStatus.present:
        label = 'Present';
        bg = Colors.green.withValues(alpha: 0.15);
        fg = Colors.green[800]!;
        break;
      case ClassStatus.late:
        label = 'Late';
        bg = Colors.orange.withValues(alpha: 0.15);
        fg = Colors.orange[800]!;
        break;
      case ClassStatus.upcoming:
        label = 'Upcoming';
        bg = Colors.blue.withValues(alpha: 0.12);
        fg = Colors.blue[800]!;
        break;
      case ClassStatus.ongoing:
        label = 'Ongoing';
        bg = Colors.purple.withValues(alpha: 0.12);
        fg = Colors.purple[800]!;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w900, color: fg),
      ),
    );
  }
}
