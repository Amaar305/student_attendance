// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class PurchaseContainerInfo extends StatelessWidget {
  const PurchaseContainerInfo({
    super.key,
    this.child,
    this.color,
    this.useWidth = true,
    this.radius = 12,
  });

  final Widget? child;
  final bool useWidth;
  final Color? color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: useWidth ? double.infinity : null,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(
        AppSpacing.sm + 2,
      ),
      decoration: BoxDecoration(
        color: color ?? const Color(0xFFEBF8FF),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}
