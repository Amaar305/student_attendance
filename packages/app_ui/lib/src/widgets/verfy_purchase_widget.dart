// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class VeryPurchaseWidget extends StatelessWidget {
  const VeryPurchaseWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, 
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.4),
        color: AppColors.grey.withValues(alpha: 0.5),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          Icon(
            Icons.info,
            size: AppSize.iconSizeSmall,
            color: AppColors.black,
          ),
          Expanded(
            flex: 5,
            child: Text(
              'Kindly Verify your payment before proceeding',
              style: TextStyle(
                fontSize: AppSpacing.sm + 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
