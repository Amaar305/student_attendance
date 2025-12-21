part of 'student_home_cubit.dart';

class StudentHomeState extends Equatable {
  const StudentHomeState({
    required this.loading,
    required this.studentName,
    required this.todayItems,
    required this.errorMessage,
  });

  final bool loading;
  final String studentName;
  final List<TodayClassItem> todayItems;
  final String? errorMessage;

  const StudentHomeState.initial()
    : this(
        loading: true,
        studentName: 'Student',
        todayItems: const [],
        errorMessage: null,
      );

  StudentHomeState copyWith({
    bool? loading,
    String? studentName,
    List<TodayClassItem>? todayItems,
    String? errorMessage,
    bool clearError = false,
  }) {
    return StudentHomeState(
      loading: loading ?? this.loading,
      studentName: studentName ?? this.studentName,
      todayItems: todayItems ?? this.todayItems,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [loading, studentName, todayItems, errorMessage];
}
