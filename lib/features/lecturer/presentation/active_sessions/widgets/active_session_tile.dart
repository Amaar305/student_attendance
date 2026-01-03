import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/core/common/widgets/app_container.dart';

class ActiveSessionTile extends StatelessWidget {
  const ActiveSessionTile({
    super.key,
    required this.session,
    required this.course,
    required this.isClosing,
    required this.onCancel,
  });

  final Session session;
  final Course? course;
  final bool isClosing;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final title = course?.title ?? 'Course';
    final date = _formatDate(session.dateTimeStart);
    final time = _formatTimeRange(session.dateTimeStart, session.dateTimeEnd);
    final topic = session.topic?.trim();

    return AppContainer(
      asTitle: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: context.titleSmall?.copyWith(
                    fontWeight: AppFontWeight.semiBold,
                    color: AppColors.primaryDarkBlue,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const _StatusPill(),
            ],
          ),
          Text(
            '$date • $time',
            style: context.bodySmall?.copyWith(
              color: AppColors.emphasizeGrey,
            ),
          ),
          if (topic != null && topic.isNotEmpty)
            Text(
              'Topic: $topic',
              style: context.bodySmall?.copyWith(
                color: AppColors.primaryDarkBlue,
              ),
            ),
          Row(
            children: [
              Text(
                'Attendance: ${session.attendanceCount}',
                style: context.bodySmall?.copyWith(
                  color: AppColors.primaryDarkBlue.withValues(alpha: 0.7),
                  fontWeight: AppFontWeight.medium,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 34,
                child: AppButton(
                  text: isClosing ? 'Cancelling...' : 'Cancel',
                  textStyle: context.labelMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: AppFontWeight.semiBold,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isClosing ? null : onCancel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'Open',
        style: context.labelSmall?.copyWith(
          color: AppColors.green,
          fontWeight: AppFontWeight.semiBold,
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) =>
    DateFormat('MMMM d, yyyy').format(date.toLocal());

String _formatTimeRange(DateTime start, DateTime? end) {
  final startText = DateFormat('h:mm a').format(start.toLocal());
  if (end == null) return startText;
  final endText = DateFormat('h:mm a').format(end.toLocal());
  return '$startText - $endText';
}
