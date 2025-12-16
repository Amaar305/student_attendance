// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

class AppAppBarTitle extends StatelessWidget {
  const AppAppBarTitle(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }
}
