part of 'lecturer_home_bloc.dart';

enum LecturerHomeStatus { initial, populated, error }

class LecturerHomeState extends Equatable {
  final LecturerHomeStatus status;
  final String message;
  final List<Course> courses;

  const LecturerHomeState({
    required this.status,
    required this.courses,
    required this.message,
  });

  const LecturerHomeState.initial()
    : this(courses: const [], status: LecturerHomeStatus.initial, message: '');

  @override
  List<Object> get props => [status, courses, message];

  LecturerHomeState copyWith({
    LecturerHomeStatus? status,
    String? message,
    List<Course>? courses,
  }) => LecturerHomeState(
    status: status ?? this.status,
    courses: courses ?? this.courses,
    message: message ?? this.message,
  );
}
