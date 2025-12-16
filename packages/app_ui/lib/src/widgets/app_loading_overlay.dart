import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// A controller that manages a loading overlay entry.
class AppLoadingOverlayController {
  AppLoadingOverlayController._(this._entry);

  OverlayEntry? _entry;

  /// Whether the overlay is still mounted.
  bool get isShowing => _entry != null;

  /// Removes the overlay from the tree if it is mounted.
  void close() {
    final entry = _entry;
    if (entry == null) return;

    entry.remove();
    _entry = null;
  }
}

/// Shows a styled loading overlay and returns a controller that can be used to
/// dismiss it later.
AppLoadingOverlayController showAppLoadingOverlay(
  BuildContext context, {
  String title = 'Hang tight...',
  String message = 'We are syncing your experience.',
  Color? primary,
  Color? secondary,
}) {
  final overlay = Overlay.of(context, rootOverlay: true);

  final entry = OverlayEntry(
    builder: (_) => _AppLoadingOverlay(
      title: title,
      message: message,
      primary: primary,
      secondary: secondary,
    ),
  );

  overlay.insert(entry);

  return AppLoadingOverlayController._(entry);
}

class _AppLoadingOverlay extends StatelessWidget {
  const _AppLoadingOverlay({
    required this.title,
    required this.message,
    this.primary,
    this.secondary,
  });

  final String title;
  final String message;
  final Color? primary;
  final Color? secondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = primary ?? colorScheme.primary;
    final secondaryColor = secondary ?? colorScheme.secondary;

    return Stack(
      children: [
        ModalBarrier(
          dismissible: false,
          color: Colors.black.withValues(alpha: 0.35),
        ),
        Center(
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 220,
              maxWidth: 280,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xlg,
              vertical: AppSpacing.xxlg,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor.withValues(alpha: 0.95),
                  secondaryColor.withValues(alpha: 0.9),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.35),
                  blurRadius: 42,
                  offset: const Offset(0, 24),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.35),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(
                      strokeWidth: 5.5,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
