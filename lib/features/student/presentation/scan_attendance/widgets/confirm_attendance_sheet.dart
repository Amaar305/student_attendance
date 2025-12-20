import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance/features/student/student.dart';

class ConfirmAttendanceSheet extends StatelessWidget {
  const ConfirmAttendanceSheet({
    super.key,
    required this.preview,
    required this.onConfirm,
    required this.onCancel,
  });

  final ScanPreview preview;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String fmtDate(DateTime d) => '${_monthName(d.month)} ${d.day}, ${d.year}';

    String fmtTime(DateTime d) {
      final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
      final m = d.minute.toString().padLeft(2, '0');
      final ampm = d.hour >= 12 ? 'PM' : 'AM';
      return '$h:$m $ampm';
    }

    final start = preview.startAt;
    final end = preview.endAt;
    final timeRange = end == null
        ? fmtTime(start)
        : '${fmtTime(start)} - ${fmtTime(end)}';

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const Gap.v(14),
              Text(
                'Confirm Attendance',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap.v(14),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Column(
                  children: [
                    _kvRow('Course', preview.courseTitle),
                    const Gap.v(10),
                    _kvRow('Date', fmtDate(preview.startAt)),
                    const Gap.v(10),
                    _kvRow('Time', timeRange),
                    const Gap.v(10),
                    _kvRow('Lecturer', preview.lecturerName),
                  ],
                ),
              ),

              const Gap.v(14),

              PrimaryButton(label: 'Confirm Attendance', onPressed: onConfirm),
              const Gap.v(8),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: onCancel,
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kvRow(String k, String v) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            k,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            v,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  String _monthName(int m) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[m - 1];
  }
}
