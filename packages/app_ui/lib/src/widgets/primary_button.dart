// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    this.isLoading = false,
    super.key,
    this.onPressed,
    this.child,
    this.backgroundColor,
  });

  final bool isLoading;
  final String label;
  final VoidCallback? onPressed;
  final Widget? child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      fixedSize: const WidgetStatePropertyAll(Size.fromHeight(50)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      backgroundColor: WidgetStatePropertyAll(backgroundColor),
    );

    final childWidget = switch (isLoading) {
      true => Row(
          children: [
            Expanded(
              child: AppButton.inProgress(
                style: style,
                scale: 0.5,
              ),
            ),
          ],
        ),
      _ => AppButtonBig(
          text: label,
          loading: true,
          textStyle: GoogleFonts.exo(color: AppColors.white),
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.deepBlue,
            fixedSize: const Size.fromHeight(50),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            textStyle: GoogleFonts.poppins(
              color: AppColors.white,
              fontWeight: AppFontWeight.bold,
            ),
          ),
          onPressed: onPressed,
          child: child,
        ),
    };
    return childWidget;
  }
}
