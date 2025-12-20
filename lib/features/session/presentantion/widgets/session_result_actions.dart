import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:student_attendance/features/session/session.dart';

class SessionResultActions extends StatelessWidget {
  const SessionResultActions({super.key, required this.sessionResult});
  final SessionResult sessionResult;

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
                onPressed: () => _downloadQR(context, sessionResult.qrPayload),
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
                onPressed: () => _shareQR(context, sessionResult.qrPayload),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Future<void> _downloadQR(BuildContext context, String qrPayload) async {
  try {
    final qrPainter = QrPainter(
      data: qrPayload,
      version: QrVersions.auto,
      gapless: true,
    );

    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    if (directory == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to access storage')),
        );
      }
      return;
    }

    final file = File(
      '${directory.path}/attendance_qr_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    final picData = await qrPainter.toImageData(300);
    if (picData == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate QR image')),
        );
      }
      return;
    }

    await file.writeAsBytes(picData.buffer.asUint8List());
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('QR saved to ${file.path}')));
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Failed to download QR: $e')));
  }
}

Future<void> _shareQR(BuildContext context, String qrPayload) async {
  try {
    final qrPainter = QrPainter(
      data: qrPayload,
      version: QrVersions.auto,
      gapless: true,
    );

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/qr.png');

    final picData = await qrPainter.toImageData(300);
    if (picData != null) {
      await file.writeAsBytes(picData.buffer.asUint8List());
      // ignore: deprecated_member_use
      await Share.shareXFiles([XFile(file.path)], text: 'My QR Code');
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Failed to share QR: $e')));
  }
}
