import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SessionStatsRow extends StatelessWidget {
  const SessionStatsRow({
    super.key,
    required this.totalStudents,
    required this.presentCount,
    required this.absentCount,
  });

  final int totalStudents;
  final int presentCount;
  final int absentCount;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _SessionStatCard(
        title: 'Total Students',
        value: '$totalStudents',
        icon: Icons.people_alt_rounded,
        accentColor: AppColors.blue,
      ),
      _SessionStatCard(
        title: 'Present',
        value: '$presentCount',
        icon: Icons.check_circle_rounded,
        accentColor: AppColors.green,
      ),
      _SessionStatCard(
        title: 'Absent',
        value: '$absentCount',
        icon: Icons.cancel_rounded,
        accentColor: AppColors.red,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final spacing = AppSpacing.md;
        final columns = width >= 900
            ? 3
            : width >= 600
                ? 2
                : 1;
        final cardWidth = (width - (columns - 1) * spacing) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: cards
              .map((card) => SizedBox(width: cardWidth, child: card))
              .toList(),
        );
      },
    );
  }
}

class _SessionStatCard extends StatelessWidget {
  const _SessionStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor.withValues(alpha: 0.14),
            AppColors.brightGrey.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.brightGrey.withValues(alpha: 0.35)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            spacing: AppSpacing.sm,
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accentColor, size: 20),
              ),
              Flexible(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.labelMedium?.copyWith(
                    color: AppColors.emphasizeGrey,
                    fontWeight: AppFontWeight.semiBold,
                  ),
                ),
              ),
            ],
          ),
          Text(
            value,
            textAlign: TextAlign.center,
            style: context.headlineMedium?.copyWith(
              fontWeight: AppFontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
