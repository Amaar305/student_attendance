import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_attendance/app/routes/app_routes.dart';
import 'package:student_attendance/core/common/common.dart';

class ScanQrcodeContainer extends StatelessWidget {
  const ScanQrcodeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Expanded(child: _ScanDetails()),
          SizedBox(width: AppSpacing.lg),
          _ScanActionButton(),
        ],
      ),
    );
  }
}

class _ScanDetails extends StatelessWidget {
  const _ScanDetails();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xs,
      children: [
        Text(
          'Scan to Mark Attendance',
          style: context.titleMedium?.copyWith(
            fontWeight: AppFontWeight.semiBold,
            color: AppColors.primaryDarkBlue,
          ),
        ),
        Text(
          'Point your camera at the QR code to sign in for your class',
          style: context.bodyMedium?.copyWith(
            color: AppColors.emphasizeGrey,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _ScanActionButton extends StatelessWidget {
  const _ScanActionButton();

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: 'Scan',
      icon: const Icon(Icons.qr_code_scanner, color: AppColors.white),
      textStyle: context.labelLarge?.copyWith(
        color: AppColors.white,
        fontWeight: AppFontWeight.semiBold,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.deepBlue,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      onPressed: () => context.push(AppRoutes.scanAttendance),
    );
  }
}
