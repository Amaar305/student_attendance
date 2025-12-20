part of 'scan_attendance_cubit.dart';

enum ScanAttendanceStatus {
  idle, // nothing scanned yet
  loadingPreview,
  previewReady, // bottom sheet can render details
  confirming,
  success,
  failure;

  bool get isError => this == ScanAttendanceStatus.failure;
  bool get isSuccess => this == ScanAttendanceStatus.success;
  bool get isLoading => this == ScanAttendanceStatus.loadingPreview;
  bool get isIdle => this == ScanAttendanceStatus.idle;
  bool get isConfirming => this == ScanAttendanceStatus.confirming;
  bool get isPreviewReady => this == ScanAttendanceStatus.previewReady;
}

class ScanAttendanceState extends Equatable {
  const ScanAttendanceState({
    required this.status,
    this.qrPayload,
    this.preview,
    this.record,
    this.errorMessage,
  });

  final ScanAttendanceStatus status;

  /// Raw payload from QR scan
  final String? qrPayload;

  /// Data for bottom sheet
  final ScanPreview? preview;

  /// Result after confirming
  final AttendanceRecord? record;

  /// Error message for UI
  final String? errorMessage;

  const ScanAttendanceState.idle() : this(status: ScanAttendanceStatus.idle);

  ScanAttendanceState copyWith({
    ScanAttendanceStatus? status,
    String? qrPayload,
    ScanPreview? preview,
    AttendanceRecord? record,
    String? errorMessage,
    bool clearError = false,
    bool clearRecord = false,
    bool clearPreview = false,
  }) {
    return ScanAttendanceState(
      status: status ?? this.status,
      qrPayload: qrPayload ?? this.qrPayload,
      preview: clearPreview ? null : (preview ?? this.preview),
      record: clearRecord ? null : (record ?? this.record),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, qrPayload, preview, record, errorMessage];
}
