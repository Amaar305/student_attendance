import 'package:flutter/material.dart';

class BottomHintCard extends StatelessWidget {
  const BottomHintCard({super.key, required this.onManualEntry});
  final VoidCallback onManualEntry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.qr_code_scanner, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Align the QR code inside the frame to mark attendance.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          TextButton(onPressed: onManualEntry, child: const Text('Manual')),
        ],
      ),
    );
  }
}
