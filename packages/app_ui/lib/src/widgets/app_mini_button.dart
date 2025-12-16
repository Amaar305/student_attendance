// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppMiniButton extends StatelessWidget {
  const AppMiniButton({
    required this.label,
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.child,
  });
  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: label,
      onPressed: isLoading ? null : onPressed,
      textStyle: const TextStyle(color: AppColors.blue, fontSize: 10),
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        fixedSize: const WidgetStatePropertyAll(Size(150, 50)),
        backgroundColor: const WidgetStatePropertyAll(
          AppColors.white,
        ),
      ),
      child: child,
    );
  }
}
