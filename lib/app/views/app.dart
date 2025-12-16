import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance/app/app.dart';

/// Key to access the [AppSnackbarState] from the [BuildContext].
final snackbarKey = GlobalKey<AppSnackbarState>();

/// Key to access the [AppLoadingIndeterminateState] from the
/// [BuildContext].
final loadingIndeterminateKey = GlobalKey<AppLoadingIndeterminateState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AppView();
  }
}

/// Snack bar to show messages to the user.
void openSnackbar(
  SnackbarMessage message, {
  bool clearIfQueue = false,
  bool undismissable = false,
}) {
  snackbarKey.currentState?.post(
    message,
    clearIfQueue: clearIfQueue,
    undismissable: undismissable,
  );
}

AppLoadingOverlayController? _loadingOverlayController;

void showLoadingOverlay(
  BuildContext context, {
  String? title,
  String? message,
}) {
  if (_loadingOverlayController?.isShowing ?? false) return;

  final colorScheme = Theme.of(context).colorScheme;

  _loadingOverlayController = showAppLoadingOverlay(
    context,
    title: title ?? 'Hang tight...',
    message: message ?? 'We are syncing your experience.',
    primary: colorScheme.primary,
    secondary: colorScheme.secondary,
  );
}

void hideLoadingOverlay() {
  final controller = _loadingOverlayController;
  if (controller == null) return;

  controller.close();
  _loadingOverlayController = null;
}

void toggleLoadingIndeterminate({bool enable = true, bool autoHide = false}) =>
    loadingIndeterminateKey.currentState?.setVisibility(
      visible: enable,
      autoHide: autoHide,
    );

/// Closes all snack bars.
void closeSnackbars() => snackbarKey.currentState?.closeAll();

void showCurrentlyUnavailableFeature({bool clearIfQueue = true}) =>
    openSnackbar(
      const SnackbarMessage.error(
        title: 'Feature is not available!',
        description:
            'We are trying our best to implement it as fast as possible.',
        icon: Icons.error_outline,
      ),
      clearIfQueue: clearIfQueue,
    );
