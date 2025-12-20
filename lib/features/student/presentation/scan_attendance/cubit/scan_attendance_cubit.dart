import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/student/student.dart';

part 'scan_attendance_state.dart';

class ScanAttendanceCubit extends Cubit<ScanAttendanceState> {
  final AppUser _user;

  final GetScanPreviewUseCase _getScanPreviewUseCase;
  final ConfirmAttendanceUseCase _confirmAttendanceUseCase;
  ScanAttendanceCubit({
    required AppUser user,
    required GetScanPreviewUseCase getScanPreviewUseCase,
    required ConfirmAttendanceUseCase confirmAttendanceUseCase,
  }) : _user = user,
       _getScanPreviewUseCase = getScanPreviewUseCase,
       _confirmAttendanceUseCase = confirmAttendanceUseCase,
       super(ScanAttendanceState.idle());

  /// Call when user cancels bottom sheet or wants to scan again.
  void reset() {
    emit(const ScanAttendanceState.idle());
  }

  Future<void> onQrScanned(String qrPayload) async {
    // Prevent double scans while busy
    if (state.status.isLoading || state.status.isConfirming) {
      return;
    }
    emit(
      state.copyWith(
        status: ScanAttendanceStatus.loadingPreview,
        qrPayload: qrPayload,
        clearError: true,
        clearRecord: true,
        clearPreview: true,
      ),
    );

    final previewResult = await _getScanPreviewUseCase(
      GetScanPreviewParams(qrPayload: qrPayload),
    );

    if (isClosed) return;

    previewResult.fold(
      (failure) => emit(
        state.copyWith(
          status: ScanAttendanceStatus.failure,
          errorMessage: _mapError(failure.message),
        ),
      ),
      (preview) {
        // Session closed? you can decide to block preview or still show it.
        if (!preview.isOpen) {
          emit(
            state.copyWith(
              status: ScanAttendanceStatus.failure,
              errorMessage: 'This session is closed.',
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            status: ScanAttendanceStatus.previewReady,
            preview: preview,
            clearError: true,
          ),
        );
      },
    );
  }

  /// Call when user taps "Confirm Attendance".
  Future<void> confirmAttendance() async {
    final qrPayload = state.qrPayload;
    if (qrPayload == null || qrPayload.isEmpty) {
      emit(
        state.copyWith(
          status: ScanAttendanceStatus.failure,
          errorMessage: 'No QR data found. Please scan again.',
        ),
      );
      return;
    }

    // Must have preview ready (ensures we scanned successfully)
    if (!state.status.isPreviewReady) {
      emit(
        state.copyWith(
          status: ScanAttendanceStatus.failure,
          errorMessage: 'Please scan a valid QR code first.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: ScanAttendanceStatus.confirming,
        clearError: true,
        clearRecord: true,
      ),
    );

    try {
      final res = await _confirmAttendanceUseCase(
        ConfirmAttendanceParams(studentId: _user.id, qrPayload: qrPayload),
      );

      if (isClosed) return;

      res.fold(
        (failure) => emit(
          state.copyWith(
            status: ScanAttendanceStatus.failure,
            errorMessage: _mapError(failure.message),
          ),
        ),
        (record) => emit(
          state.copyWith(
            status: ScanAttendanceStatus.success,
            record: record,
            clearError: true,
          ),
        ),
      );
    } catch (error) {
      if (isClosed) return;

      emit(
        state.copyWith(
          status: ScanAttendanceStatus.failure,
          errorMessage: _mapError(error),
        ),
      );
    }
  }

  String _mapError(Object e) {
    final msg = e.toString();

    // You can refine this mapping later; keep it simple now.
    if (msg.contains('Session not found')) return 'Session not found.';
    if (msg.contains('Session is closed') || msg.contains('closed')) {
      return 'This session is closed.';
    }
    if (msg.contains('Invalid QR token') || msg.contains('token')) {
      return 'Invalid QR code. Please rescan.';
    }
    if (msg.contains('not enrolled')) {
      return 'You are not enrolled in this course.';
    }
    if (msg.contains('permission') || msg.contains('PERMISSION')) {
      return 'Permission denied.';
    }
    return 'Something went wrong. Please try again.';
  }
}
