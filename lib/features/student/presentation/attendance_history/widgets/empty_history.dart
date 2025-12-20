import 'package:flutter/material.dart';

class EmptyHistory extends StatelessWidget {
  const EmptyHistory({super.key, required this.onClearFilters});
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.history, size: 34),
            const SizedBox(height: 10),
            const Text(
              'No attendance records yet',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              'Scan a session QR code to mark attendance. '
              'You can also adjust filters to see older records.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onClearFilters,
              child: const Text('Reset Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
