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
    final surfaceTint = colorScheme.surface.withValues(alpha: 0.9);

    return Stack(
      children: [
        ModalBarrier(
          dismissible: false,
          color: Colors.black.withValues(alpha: 0.35),
        ),
        Center(
          child: Container(
            constraints: const BoxConstraints(minWidth: 200, maxWidth: 260),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: surfaceTint,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryColor.withValues(alpha: 0.12),
                        secondaryColor.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 180),
                        style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.4,
                            ) ??
                            const TextStyle(),
                        child: Text(
                          message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
