import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SessionResultActions extends StatelessWidget {
  const SessionResultActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.xlg,
      children: [
        Text(
          'Students, scan this code to mark your attendance.',
          textAlign: TextAlign.center,
          style: context.titleMedium?.copyWith(
            fontWeight: AppFontWeight.medium,
            color: AppColors.primaryDarkBlue,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Download QR',
                icon: const Icon(
                  Icons.download_rounded,
                  color: AppColors.white,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepBlue,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.md),
                  ),
                ),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppButton(
                text: 'Share QR',
                icon: const Icon(Icons.share_rounded, color: AppColors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightBlue,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.md),
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
