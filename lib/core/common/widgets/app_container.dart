import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({
    super.key,
    this.child,
    this.asTitle = false,
    this.height,
    this.width,
    this.padding,
  });
  final Widget? child;
  final bool asTitle;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding?? const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: asTitle
            ? Border.all(
                color: AppColors.primary2.withValues(alpha: 0.2),
                width: 0.5,
              )
            : null,
        boxShadow: asTitle
            ? [
                BoxShadow(
                  color: AppColors.primary2.withValues(alpha: 0.02),
                  offset: Offset(0, 2),
                  blurRadius: 2,
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.primary2.withValues(alpha: 0.08),
                  offset: Offset(0, 2),
                  blurRadius: 9,
                  spreadRadius: 3,
                ),
              ],
      ),
      child: child,
    );
  }
}
