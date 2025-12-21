import 'package:flutter/material.dart';

class StudentEmptyToday extends StatelessWidget {
  const StudentEmptyToday({super.key, required this.onScan});
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.event_busy, size: 34),
            const SizedBox(height: 10),
            const Text(
              'No classes scheduled for today',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              'If you have a QR code from a lecturer, you can still scan it.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onScan,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan QR'),
            ),
          ],
        ),
      ),
    );
  }
}
