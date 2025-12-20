part of 'attendance_history_cubit.dart';

class AttendanceHistoryState extends Equatable {
  final bool loading;
  final List<EnrollmentCourseOption> courseOptions;
  final String? selectedCourseId;
  final HistoryRange selectedRange;
  final List<StudentAttendanceItem> items;
  final String? errorMessage;

  const AttendanceHistoryState({
    required this.loading,
    required this.courseOptions,
    required this.selectedCourseId,
    required this.selectedRange,
    required this.items,
    required this.errorMessage,
  });

  const AttendanceHistoryState.initial()
    : this(
        loading: true,
        courseOptions: const [],
        selectedCourseId: null,
        selectedRange: HistoryRange.last30Days,
        items: const [],
        errorMessage: null,
      );

  AttendanceHistoryState copyWith({
    bool? loading,
    List<EnrollmentCourseOption>? courseOptions,
    String? selectedCourseId,
    bool clearSelectedCourseId = false,
    HistoryRange? selectedRange,
    List<StudentAttendanceItem>? items,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AttendanceHistoryState(
      loading: loading ?? this.loading,
      courseOptions: courseOptions ?? this.courseOptions,
      selectedCourseId: clearSelectedCourseId
          ? null
          : (selectedCourseId ?? this.selectedCourseId),
      selectedRange: selectedRange ?? this.selectedRange,
      items: items ?? this.items,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    loading,
    courseOptions,
    selectedCourseId,
    selectedRange,
    items,
    errorMessage,
  ];
}
