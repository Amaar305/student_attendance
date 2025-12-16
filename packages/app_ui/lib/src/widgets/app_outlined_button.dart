// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    required this.isLoading,
    required this.label,
    super.key,
    this.onPressed,
  });

  final bool isLoading;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      fixedSize: const WidgetStatePropertyAll(Size.fromHeight(50)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );

    final child = switch (isLoading) {
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
      _ => AppButton.outlined(
          text: label,
          
          style: ElevatedButton.styleFrom(
            fixedSize: const Size.fromHeight(50),
            
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
          onPressed: onPressed,
        ),
    };
    return child;
  }
}
