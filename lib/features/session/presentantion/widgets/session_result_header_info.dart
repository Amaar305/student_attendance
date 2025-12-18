import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance/core/common/widgets/app_container.dart';

class SessionResultHeaderInfo extends StatelessWidget {
  const SessionResultHeaderInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.xs,
        children: [
          Text(
            'CSC1211: Intro to Programming',
            style: context.titleMedium?.copyWith(
              fontWeight: AppFontWeight.semiBold,
              color: AppColors.primaryDarkBlue,
            ),
          ),
          Text(
            'Lecture5: Data Structures',
            style: context.bodyMedium?.copyWith(
              color: AppColors.emphasizeGrey,
              height: 1.4,
            ),
          ),
          Text(
            'ID: A4B7-9C1D',
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
