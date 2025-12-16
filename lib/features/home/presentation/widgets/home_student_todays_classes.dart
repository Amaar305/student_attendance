import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class HomeStudentTodaysClasses extends StatelessWidget {
  const HomeStudentTodaysClasses({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Classes',
          style: context.titleMedium?.copyWith(
            fontWeight: AppFontWeight.semiBold,
            color: AppColors.primaryDarkBlue,
          ),
        ),
      ],
    );
  }
}
