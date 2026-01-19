part of 'my_students_cubit.dart';

const _unset = Object();

class MyStudentsState extends Equatable {
  const MyStudentsState({
    required this.courses,
    required this.students,
    required this.selectedCourseId,
    required this.query,
    required this.loading,
    required this.errorMessage,
  });

  final List<Course> courses;
  final List<CourseStudent> students;
  final String? selectedCourseId;
  final String query;
  final bool loading;
  final String? errorMessage;

  const MyStudentsState.initial()
      : courses = const [],
        students = const [],
        selectedCourseId = null,
        query = '',
        loading = true,
        errorMessage = null;

  MyStudentsState copyWith({
    List<Course>? courses,
    List<CourseStudent>? students,
    Object? selectedCourseId = _unset,
    String? query,
    bool? loading,
    String? errorMessage,
    bool clearError = false,
  }) {
    final resolvedSelectedCourseId =
        identical(selectedCourseId, _unset)
            ? this.selectedCourseId
            : selectedCourseId as String?;
    return MyStudentsState(
      courses: courses ?? this.courses,
      students: students ?? this.students,
      selectedCourseId: resolvedSelectedCourseId,
      query: query ?? this.query,
      loading: loading ?? this.loading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        courses,
        students,
        selectedCourseId,
        query,
        loading,
        errorMessage,
      ];
}
