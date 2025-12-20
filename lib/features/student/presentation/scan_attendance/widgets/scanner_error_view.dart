import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ScannerErrorView extends StatelessWidget {
  const ScannerErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    required this.onBack,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDarkBlue, AppColors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withValues(alpha: 0.04),
                  border: Border.all(color: AppColors.borderOutline),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepBlue.withValues(alpha: 0.35),
                      blurRadius: 28,
                      spreadRadius: 2,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: AppColors.lightBlue,
                  size: 46,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Camera unavailable',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.emphasizeGrey,
                ),
              ),
              const SizedBox(height: 28),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deepBlue,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  ),
                  OutlinedButton(
                    onPressed: onBack,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.white,
                      side: const BorderSide(color: AppColors.borderOutline),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Go back'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
