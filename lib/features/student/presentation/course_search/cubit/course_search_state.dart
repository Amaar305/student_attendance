part of 'course_search_cubit.dart';

enum CourseSearchStatus {
  loading,
  ready,
  enrolling,
  success,
  failure;

  bool get isError => this == CourseSearchStatus.failure;
  bool get isReady => this == CourseSearchStatus.ready;
  bool get isEnrolling => this == CourseSearchStatus.enrolling;
  bool get isSuccess => this == CourseSearchStatus.success;
  bool get isLoading => this == CourseSearchStatus.loading;
}

class CourseSearchState extends Equatable {
  const CourseSearchState({
    required this.status,
    required this.query,
    required this.courses,
    required this.enrolledCourseIds,
    required this.errorMessage,
  });

  final CourseSearchStatus status;
  final String query;
  final List<CourseSearchItem> courses;

  /// used to label "Enrolled" instantly
  final Set<String> enrolledCourseIds;

  final String? errorMessage;

  const CourseSearchState.initial()
    : this(
        status: CourseSearchStatus.loading,
        query: '',
        courses: const [],
        enrolledCourseIds: const {},
        errorMessage: null,
      );

  CourseSearchState copyWith({
    CourseSearchStatus? status,
    String? query,
    List<CourseSearchItem>? courses,
    Set<String>? enrolledCourseIds,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CourseSearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      courses: courses ?? this.courses,
      enrolledCourseIds: enrolledCourseIds ?? this.enrolledCourseIds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    query,
    courses,
    enrolledCourseIds,
    errorMessage,
  ];
}
