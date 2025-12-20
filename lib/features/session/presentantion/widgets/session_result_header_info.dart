import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance/core/common/widgets/app_container.dart';
import 'package:student_attendance/features/session/session.dart';

class SessionResultHeaderInfo extends StatelessWidget {
  const SessionResultHeaderInfo({super.key, required this.sessionResult});
  final SessionResult sessionResult;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.xs,
        children: [
          Text(
            '${sessionResult.course.code}: ${sessionResult.course.name}',
            style: context.titleMedium?.copyWith(
              fontWeight: AppFontWeight.semiBold,
              color: AppColors.primaryDarkBlue,
            ),
          ),
          Text(
            'Lecture: ${sessionResult.session.topic}',
            style: context.bodyMedium?.copyWith(
              color: AppColors.emphasizeGrey,
              height: 1.4,
            ),
          ),
          Text(
            'ID: ${sessionResult.session.id}',
            style: context.bodyMedium?.copyWith(
              color: AppColors.emphasizeGrey,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
