import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance/app/app.dart';

class SplashLogoCard extends StatelessWidget {
  const SplashLogoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.xlg,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLogo(),
        Column(
          spacing: AppSpacing.sm,
          children: [
            Text(
              AppStrings.appName,
              style: context.titleLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              AppStrings.appHook,
              style: context.bodySmall?.copyWith(
                color: AppColors.white.withValues(alpha: 0.8),
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
