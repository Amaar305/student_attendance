import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_logo}
/// The Application logo that display large Instagram text in a svg format.
/// {@endtemplate}
class AppLogo extends StatelessWidget {
  /// {@macro app_log}
  const AppLogo({
    super.key,
    this.width,
    this.height,
    this.color,
    this.logoSize,
  });

  /// The width of the logo.
  final double? width;

  /// The height of the logo.
  final double? height;

  /// The color of the logo.
  final Color? color;

  /// The width of the icon
  final double? logoSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 96,
      height: height ?? 96,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.lightBlue,
            AppColors.white.withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.lg),
      ),
      child: Icon(
        Icons.radar_rounded,
        size: logoSize ?? 56,
        color: AppColors.blue,
      ),
    );
  }
}
