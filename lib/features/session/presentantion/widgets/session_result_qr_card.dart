import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance/core/common/widgets/app_container.dart';

class SessionResultQrCard extends StatelessWidget {
  const SessionResultQrCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Container(
        width: double.infinity,
        height: context.screenHeight * 0.3,
        color: AppColors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppSpacing.sm,
          children: [
            Icon(
              Icons.document_scanner_outlined,
              color: AppColors.brightGrey,
              size: 100,
            ),
            Text(
              'A4B7-9C1D',
              style: context.bodyMedium?.copyWith(
                color: AppColors.emphasizeGrey,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
