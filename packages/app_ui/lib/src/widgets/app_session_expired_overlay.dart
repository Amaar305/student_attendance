// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

/// A simple, reusable overlay widget to show when a user's session has expired.
///
/// Use [AppSessionExpiredOverlay.show] to present it as a //full-screen modal dialog,
/// or instantiate the widget directly to place it in your own layout.
///
/// ```dart
/// await AppSessionExpiredOverlay.show(
///   context,
///   onPrimaryPressed: () => authRepository.signOut(),
/// );
/// ```
class AppSessionExpiredOverlay extends StatelessWidget {

  const AppSessionExpiredOverlay({
    required this.onPrimaryPressed,
    super.key,
    this.title = 'Session Expired',
    this.message =
        'Your session has expired. Please sign in again to continue.',
    this.primaryButtonLabel = 'Sign in',
    this.secondaryButtonLabel,
    this.onSecondaryPressed,
    this.barrierDismissible = false,
  });
  final String title;
  final String message;
  final String primaryButtonLabel;
  final VoidCallback onPrimaryPressed;
  final String? secondaryButtonLabel;
  final VoidCallback? onSecondaryPressed;
  final bool barrierDismissible;

  /// Shows the session-expired overlay as a full-screen modal.
  ///
  /// Returns a Future that completes when the dialog is dismissed. The returned
  /// value will be whatever is passed to Navigator.pop from inside the dialog.
  static Future<T?> show<T>(
    BuildContext context, {
    required VoidCallback onPrimaryPressed,
    String title = 'Session Expired',
    String message =
        'Your session has expired. Please sign in again to continue.',
    String primaryButtonLabel = 'Sign in',
    String? secondaryButtonLabel,
    VoidCallback? onSecondaryPressed,
    bool barrierDismissible = false,
    Color barrierColor = Colors.black54,
    Duration transitionDuration = const Duration(milliseconds: 200),
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Session expired',
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        // ignore: deprecated_member_use
        return WillPopScope(
          onWillPop: () async => barrierDismissible,
          child: SafeArea(
            child: Builder(
              builder: (innerCtx) {
                return Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: AppSessionExpiredOverlay(
                      title: title,
                      message: message,
                      primaryButtonLabel: primaryButtonLabel,
                      onPrimaryPressed: () {
                        Navigator.of(innerCtx, rootNavigator: true).pop();
                        onPrimaryPressed();
                      },
                      secondaryButtonLabel: secondaryButtonLabel,
                      onSecondaryPressed: secondaryButtonLabel == null
                          ? null
                          : () {
                              Navigator.of(innerCtx, rootNavigator: true).pop();
                              if (onSecondaryPressed != null) {
                                onSecondaryPressed();
                              }
                            },
                      barrierDismissible: barrierDismissible,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeOut);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Card(
          elevation: 12,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 56,
                  color: theme.colorScheme.primary,
                  semanticLabel: 'Session expired icon',
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: secondaryButtonLabel != null
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  children: [
                    if (secondaryButtonLabel != null)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onSecondaryPressed,
                          child: Text(secondaryButtonLabel!),
                        ),
                      ),
                    if (secondaryButtonLabel != null) const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onPrimaryPressed,
                        child: Text(primaryButtonLabel),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
