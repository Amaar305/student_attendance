import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_attendance/app/app.dart';
import 'package:student_attendance/core/common/common.dart';

class LecturerQuickActions extends StatelessWidget {
  const LecturerQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.lg,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _LecturerQuickAction(
            icon: Icons.add_circle,
            label: 'Start Class',
            onTap: () => context.push(AppRoutes.createSession),
          ),
        ),

        Expanded(
          child: _LecturerQuickAction(
            icon: Icons.sensors_sharp,
            label: 'Active Classes',
            onTap: () => context.push(AppRoutes.activeSessions),
          ),
        ),

        Expanded(
          child: _LecturerQuickAction(
            icon: Icons.groups_outlined,
            label: 'My Students',
            onTap: () => context.push(AppRoutes.myStudents),
          ),
        ),
      ],
    );
  }
}

class _LecturerQuickAction extends StatelessWidget {
  const _LecturerQuickAction({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const iconColor = AppColors.blue;

    return Tappable.faded(
      onTap: onTap,
      child: AppContainer(
        asTitle: true,
        height: 120,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: AppSpacing.sm,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(AppSpacing.xlg),
              ),
              child: Center(child: Icon(icon, color: iconColor, size: 22)),
            ),

            Text(
              label,
              style: context.titleSmall?.copyWith(
                fontWeight: AppFontWeight.medium,
                color: AppColors.primaryDarkBlue,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
