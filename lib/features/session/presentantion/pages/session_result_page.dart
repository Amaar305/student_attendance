import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance/features/session/session.dart';

class SessionResultPage extends StatelessWidget {
  const SessionResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: Text('Session QR Code')),
      body: AppConstrainedScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SessionResultHeaderInfo(),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SessionResultQrCard(),
            ),

            const SessionResultActions(),
          ],
        ),
      ),
    );
  }
}
