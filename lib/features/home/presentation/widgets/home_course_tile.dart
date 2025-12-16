import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance/core/common/widgets/app_container.dart';

class HomeCourseTile extends StatelessWidget {
  const HomeCourseTile({
    super.key,
    required this.title,
    required this.studentCount,
    this.icon = Icons.computer_rounded,
    this.ctaLabel = 'View details',
  });

  final String title;
  final int studentCount;
  final IconData icon;
  final String ctaLabel;

  @override
  Widget build(BuildContext context) {
    const primary = AppColors.primaryDarkBlue;
    return AppContainer(
      asTitle: true,
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        spacing: AppSpacing.md,
        children: [
          _CourseIcon(icon: icon, primary: primary),
          Expanded(
            child: _CourseInfo(
              title: title,
              studentCount: studentCount,
              ctaLabel: ctaLabel,
              primary: primary,
            ),
          ),
          _CourseAction(primary: primary),
        ],
      ),
    );
  }
}

class _CourseIcon extends StatelessWidget {
  const _CourseIcon({required this.icon, required this.primary});

  final IconData icon;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        color: AppColors.blue.withValues(alpha: 0.35),
        // gradient: LinearGradient(
        //   colors: [AppColors.blue, primary.withValues(alpha: 0.85)],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Icon(icon, color: AppColors.blue, size: 24),
    );
  }
}

class _CourseInfo extends StatelessWidget {
  const _CourseInfo({
    required this.title,
    required this.studentCount,
    required this.ctaLabel,
    required this.primary,
  });

  final String title;
  final int studentCount;
  final String ctaLabel;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xs,
      children: [
        Text(
          title,
          style: context.titleSmall?.copyWith(
            fontWeight: AppFontWeight.medium,
            color: primary,
            letterSpacing: -0.2,
          ),
        ),
        Row(
          children: [
            Icon(
              Icons.people_alt_rounded,
              size: 16,
              color: primary.withValues(alpha: 0.65),
            ),
            Gap.h(AppSpacing.xs),
            Text(
              '$studentCount Students',
              style: context.labelMedium?.copyWith(
                color: primary.withValues(alpha: 0.7),
                fontWeight: AppFontWeight.medium,
              ),
            ),
            Gap.h(AppSpacing.sm),
            _CourseCtaChip(ctaLabel: ctaLabel, primary: primary),
          ],
        ),
      ],
    );
  }
}

class _CourseCtaChip extends StatelessWidget {
  const _CourseCtaChip({required this.ctaLabel, required this.primary});

  final String ctaLabel;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        ctaLabel,
        style: context.bodySmall?.copyWith(
          color: primary,
          fontWeight: AppFontWeight.semiBold,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _CourseAction extends StatelessWidget {
  const _CourseAction({required this.primary});

  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      width: 38,
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.arrow_forward_rounded, color: primary, size: 22),
    );
  }
}
