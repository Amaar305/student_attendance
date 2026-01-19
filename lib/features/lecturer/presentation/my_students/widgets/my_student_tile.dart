import 'package:flutter/material.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';

class MyStudentTile extends StatelessWidget {
  const MyStudentTile({super.key, required this.item});

  final CourseStudent item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final studentName = item.student.name?.trim().isNotEmpty == true
        ? item.student.name!
        : 'Student ${item.student.studentNumber ?? item.student.id}';
    final studentId = item.student.studentNumber ?? item.student.id;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          studentName,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          'ID: $studentId • ${item.courseTitle}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
