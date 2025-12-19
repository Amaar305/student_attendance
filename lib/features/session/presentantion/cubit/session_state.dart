part of 'session_cubit.dart';

enum SessionStatus {
  initial,
  loading,
  success,
  failure;

  bool get isError => this == SessionStatus.failure;
  bool get isLoading => this == SessionStatus.loading;
  bool get isSuccess => this == SessionStatus.success;
}

class SessionState extends Equatable {
  final SessionStatus status;
  final String message;
  final List<Course> courses;
  final Course? selectedCourse;
  final DateTime? startDate;
  final TimeOfDay? startTime;
  final String topic;
  final int lateAfterMinutes;
  final Session? session;
  final String? qrPayload;

  const SessionState._({
    required this.status,
    required this.message,
    required this.courses,
    required this.selectedCourse,
    required this.startDate,
    required this.startTime,
    required this.topic,
    required this.lateAfterMinutes,
    required this.session,
    required this.qrPayload,
  });

  const SessionState.initial()
    : this._(
        status: SessionStatus.initial,
        message: '',
        courses: const [],
        selectedCourse: null,
        startDate: null,
        startTime: null,
        topic: '',
        lateAfterMinutes: 10,
        session: null,
        qrPayload: null,
      );

  SessionState copyWith({
    SessionStatus? status,
    String? message,
    List<Course>? courses,
    Course? selectedCourse,
    DateTime? startDate,
    TimeOfDay? startTime,
    String? topic,
    int? lateAfterMinutes,
    Session? session,
    String? qrPayload,
  }) => SessionState._(
    status: status ?? this.status,
    message: message ?? this.message,
    courses: courses ?? this.courses,
    selectedCourse: selectedCourse ?? this.selectedCourse,
    startDate: startDate ?? this.startDate,
    startTime: startTime ?? this.startTime,
    topic: topic ?? this.topic,
    lateAfterMinutes: lateAfterMinutes ?? this.lateAfterMinutes,
    session: session ?? this.session,
    qrPayload: qrPayload ?? this.qrPayload,
  );

  DateTime? get startAt {
    if (startDate == null || startTime == null) return null;
    return DateTime(
      startDate!.year,
      startDate!.month,
      startDate!.day,
      startTime!.hour,
      startTime!.minute,
    );
  }

  bool get canSubmit => selectedCourse != null && startAt != null;

  @override
  List<Object?> get props => [
    status,
    message,
    courses,
    selectedCourse,
    startDate,
    startTime,
    topic,
    lateAfterMinutes,
    session,
    qrPayload,
  ];
}
