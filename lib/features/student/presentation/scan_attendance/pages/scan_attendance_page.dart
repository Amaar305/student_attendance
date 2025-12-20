import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/app/app.dart';
import 'package:student_attendance/features/student/student.dart';

class ScanAttendancePage extends StatelessWidget {
  const ScanAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScanAttendanceCubit(
        user: context.read<AppCubit>().state.user!,
        getScanPreviewUseCase: getIt<GetScanPreviewUseCase>(),
        confirmAttendanceUseCase: getIt<ConfirmAttendanceUseCase>(),
      ),
      child: const ScanAttendanceView(),
    );
  }
}

class ScanAttendanceView extends StatefulWidget {
  const ScanAttendanceView({super.key});

  @override
  State<ScanAttendanceView> createState() => _ScanAttendanceViewState();
}

class _ScanAttendanceViewState extends State<ScanAttendanceView>
    with WidgetsBindingObserver {
  late final MobileScannerController _scannerController;
  bool _sheetOpen = false;
  late final ScanAttendanceCubit _cubit;
  late Debouncer _debouncer;
  bool _paused = false;

  // A simple guard to prevent double triggers
  String? _lastPayload;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cubit = context.read<ScanAttendanceCubit>();
    _debouncer = Debouncer(milliseconds: 700);

    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debouncer.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  // Pause camera when app goes background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _pauseScanner();
    } else if (state == AppLifecycleState.resumed) {
      _resumeScanner();
    }
  }

  void _pauseScanner() {
    if (_paused) return;
    _paused = true;
    _scannerController.stop();
  }

  void _resumeScanner() {
    if (!_paused) return;
    _paused = false;
    if (!_sheetOpen) {
      _scannerController.start();
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (_sheetOpen) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final raw = barcodes.first.rawValue;
    if (raw == null || raw.isEmpty) return;

    // Debounce repeated detections of the same QR
    if (raw == _lastPayload) return;
    _lastPayload = raw;

    _debouncer.run(() {
      // allow scanning the same code again after some time
      _lastPayload = null;
    });

    // Stop camera while processing & showing bottom sheet
    _scannerController.stop();

    _cubit.onQrScanned(raw);
  }

  Future<void> _openConfirmSheet(ScanPreview preview) async {
    if (_sheetOpen) return;
    _sheetOpen = true;

    // Show sheet and await until closed, then resume scanning
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ConfirmAttendanceSheet(
        preview: preview,
        onConfirm: () => _cubit.confirmAttendance(),
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );

    _sheetOpen = false;

    if (!context.mounted) return;

    // Reset cubit back to idle so next scan works cleanly
    _cubit.reset();

    // Resume camera
    _scannerController.start();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        title: const Text('Scan QR Code'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Flash',
            onPressed: () => _scannerController.toggleTorch(),
            icon: const Icon(Icons.flash_on),
          ),
          IconButton(
            tooltip: 'Switch camera',
            onPressed: () => _scannerController.switchCamera(),
            icon: const Icon(Icons.cameraswitch),
          ),
        ],
      ),
      body: BlocListener<ScanAttendanceCubit, ScanAttendanceState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) async {
          //Loading
          final busy = state.status.isLoading || state.status.isConfirming;
          if (busy) {
            showLoadingOverlay(context);
          } else {
            hideLoadingOverlay();
          }

          // If preview failed -> show error and resume scanner
          if (state.status.isError &&
              (state.errorMessage?.isNotEmpty ?? false)) {
            openSnackbar(
              SnackbarMessage.error(title: state.errorMessage ?? ''),
            );

            // Return to idle and resume scanning
            _cubit.reset();
            _scannerController.start();
          }

          // On success -> show success, close sheet (sheet handles pop)
          if (state.status.isSuccess && state.record != null) {
            final statusText = state.record!.status == AttendanceStatus.late
                ? 'Late'
                : 'Present';

            openSnackbar(
              SnackbarMessage.success(title: 'Attendance marked: $statusText'),
            );

            // Close sheet if open
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }

          // When preview is ready -> open bottom sheet
          if (state.status.isPreviewReady && state.preview != null) {
            await _openConfirmSheet(state.preview!);
          }
        },
        child: Stack(
          children: [
            MobileScanner(
              controller: _scannerController,
              onDetect: _onDetect,
              errorBuilder: (context, error) {
                final message = switch (error.errorCode) {
                  MobileScannerErrorCode.permissionDenied =>
                    'Camera access was denied. Please enable permissions and try again.',
                  MobileScannerErrorCode.unsupported =>
                    'This device does not support the required camera features.',
                  MobileScannerErrorCode.genericError =>
                    'Something went wrong starting the camera.',
                  _ => 'We could not start the camera. Please try again.',
                };

                return ScannerErrorView(
                  message: message,
                  onRetry: () => _scannerController.start(),
                  onBack: () => Navigator.of(context).pop(),
                );
              },
            ),

            // Dark overlay with cut-out scanning window
            Positioned.fill(child: _ScanOverlay()),

            // Bottom hint card (friendly + intuitive)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: BottomHintCard(
                  onManualEntry: () async {
                    final payload = await _showManualEntryDialog(context);
                    if (payload != null && payload.trim().isNotEmpty) {
                      _scannerController.stop();
                      _cubit.onQrScanned(payload.trim());
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showManualEntryDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String?>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Enter QR Payload'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Paste the QR payload here',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }
}

class _ScanOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _ScanOverlayPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _ScanOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.55);

    final cutOutSize = size.width * 0.72;
    final left = (size.width - cutOutSize) / 2;
    final top = size.height * 0.20;

    final rect = Rect.fromLTWH(left, top, cutOutSize, cutOutSize);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(20));

    final fullPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutPath = Path()..addRRect(rrect);

    final overlayPath = Path.combine(
      PathOperation.difference,
      fullPath,
      cutPath,
    );
    canvas.drawPath(overlayPath, paint);

    // Corner accents
    final cornerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    const cornerLen = 26.0;

    void corner(Offset o, bool right, bool bottom) {
      final dx = right ? 1 : -1;
      final dy = bottom ? 1 : -1;
      // horizontal
      canvas.drawLine(o, o.translate(cornerLen * dx, 0), cornerPaint);
      // vertical
      canvas.drawLine(o, o.translate(0, cornerLen * dy), cornerPaint);
    }

    corner(Offset(rect.left, rect.top), false, false);
    corner(Offset(rect.right, rect.top), true, false);
    corner(Offset(rect.left, rect.bottom), false, true);
    corner(Offset(rect.right, rect.bottom), true, true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
