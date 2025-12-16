// ignore_for_file: public_member_api_docs

import 'package:shared/shared.dart';

String convertAmount(String amount, double dollarRate) {
  if (amount.isEmpty) return '0';

  try {
    final am = double.parse(amount);
    final result = (am * dollarRate).toStringAsFixed(2);
    return 'N$result';
  } catch (e, stackTrace) {
    logE('Fail to convert amount to naira $e', stackTrace: stackTrace);
    return '';
  }
}

String calculateAmount(String amount, double fee) {
  if (amount.isEmpty) return '0';

  try {
    final am = double.parse(amount);
    final result = am + fee;
    return 'N$result';
  } catch (e, stackTrace) {
    logE('Fail to calculate amount to naira $e', stackTrace: stackTrace);
    return '';
  }
}

String calculateTotalFee({
  required String amount,
  required double dollarRate,
  required double fee,
}) {
  try {
    if (amount.isEmpty) return '0';
    // Convert  to naira
    final nairaAmount = double.parse(amount) * dollarRate;
    // Calcutae the sum
    final sum = nairaAmount + fee;

    return 'N$sum';
  } catch (e, stackTrace) {
    logE('Fail to convert total fee $e', stackTrace: stackTrace);
    return '0';
  }
}
