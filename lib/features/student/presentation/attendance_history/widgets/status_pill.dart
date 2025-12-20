import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.label, required this.status});
  final String label;
  final AttendanceStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = status == AttendanceStatus.late
        ? (Colors.orange.withValues(alpha: 0.15), Colors.orange[800]!)
        : (Colors.green.withValues(alpha: 0.15), Colors.green[800]!);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w800, color: fg),
      ),
    );
  }
}
