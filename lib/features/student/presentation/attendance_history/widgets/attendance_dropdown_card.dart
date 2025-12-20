import 'package:flutter/material.dart';

class AttendanceDropdownCard extends StatelessWidget {
  const AttendanceDropdownCard({
    super.key,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String title;
  final String value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w700,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
