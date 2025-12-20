part of 'course_view_bloc.dart';

enum CourseViewStatus {
  initial,
  loading,
  success,
  failure;

  bool get isError => this == CourseViewStatus.failure;
  bool get isLoading => this == CourseViewStatus.loading;
}

class CourseViewState extends Equatable {
  final CourseViewStatus status;
  final String message;
  final List<Session> sessions;
  final int selectedIndex;
  final int totalStudents;
  final int totalSessions;
  final double overallAttendancePercent;

  const CourseViewState({
    required this.status,
    required this.message,
    required this.sessions,
    required this.selectedIndex,
    required this.totalStudents,
    required this.totalSessions,
    required this.overallAttendancePercent,
  });

  const CourseViewState.initial()
    : this(
        message: '',
        sessions: const [],
        status: CourseViewStatus.initial,
        selectedIndex: 0,
        totalStudents: 0,
        totalSessions: 0,
        overallAttendancePercent: 0.0,
      );

  @override
  List<Object> get props => [message, selectedIndex, status, sessions, totalStudents, totalSessions, overallAttendancePercent];

  CourseViewState copyWith({
    CourseViewStatus? status,
    String? message,
    List<Session>? sessions,
    int? selectedIndex,
    int? totalStudents,
    int? totalSessions,
    double? overallAttendancePercent,
  }) {
    return CourseViewState(
      status: status ?? this.status,
      message: message ?? this.message,
      sessions: sessions ?? this.sessions,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      totalStudents: totalStudents ?? this.totalStudents,
      totalSessions: totalSessions ?? this.totalSessions,
      overallAttendancePercent: overallAttendancePercent ?? this.overallAttendancePercent,
    );
  }
}
