// ignore_for_file: public_member_api_docs

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

void copyText(BuildContext context, String text, String message) {
  FlutterClipboard.copy(text).then(
    (value) {
      // Snack hereBar or Toast can be shown to indicate success
      if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );}
    },
  );
}

void copyAccountNumber(BuildContext context, String number, [String? msg]) {
  FlutterClipboard.copy(number.isEmpty ? 'account No.' : number).then(
    (value) {},
  );
}

void copyUssdCode(BuildContext context, String number) {
  FlutterClipboard.copy(number).then(
    (value) {},
  );
}

void copyReferralCode(BuildContext context, String code) {
  FlutterClipboard.copy(code).then(
    (value) {},
  );
}
