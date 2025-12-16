import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance/features/splash/presentation/presentation.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0C1C3E), Color(0xFF133566), Color(0xFF1D4F91)],
        ),
      ),
      child: Stack(
        children: [
          AmbientCircle(
            size: 180,
            color: AppColors.lightBlue.withValues(alpha: 0.12),
            top: -60,
            right: -20,
          ),
          AmbientCircle(
            size: 140,
            color: AppColors.white.withValues(alpha: 0.08),
            bottom: -40,
            left: -10,
          ),
          child,
        ],
      ),
    );
  }
}
