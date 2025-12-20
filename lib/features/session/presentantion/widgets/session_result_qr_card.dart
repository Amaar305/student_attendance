import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:student_attendance/core/common/widgets/app_container.dart';
import 'package:student_attendance/features/session/session.dart';

class SessionResultQrCard extends StatelessWidget {
  const SessionResultQrCard({super.key, required this.sessionResult});
  final SessionResult sessionResult;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Container(
        width: double.infinity,
        height: context.screenHeight * 0.3,
        color: AppColors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppSpacing.md,
          children: [
            QrImageView(
              data: sessionResult.qrPayload,
              version: QrVersions.auto,
              size: 120,
              backgroundColor: AppColors.white,
            ),
            Text(
              sessionResult.session.id,
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
