import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_attendance/app/app.dart';
import 'package:student_attendance/core/common/common.dart';

class StudentQuickAction extends StatelessWidget {
  const StudentQuickAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.lg,
      children: [
        Expanded(
          child: _QuickActionTile(
            icon: Icons.history,
            label: 'View History',
            onTap: () => context.push(AppRoutes.attendanceHistory),
          ),
        ),

        Expanded(
          child: _QuickActionTile(
            icon: Icons.person,
            label: 'Profile',
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tappable.faded(
      onTap: onTap,
      child: AppContainer(
        asTitle: true,
        child: Row(
          children: [
            Icon(icon, color: AppColors.deepBlue),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: context.titleSmall?.copyWith(
                fontWeight: AppFontWeight.semiBold,
                color: AppColors.primaryDarkBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
