import 'package:flutter/material.dart';

class CourseStat {
  const CourseStat({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.subtitleColor,
    this.accentColor,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color? subtitleColor;
  final Color? accentColor;
}
