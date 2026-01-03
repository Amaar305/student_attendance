part of 'add_course_cubit.dart';

enum AddCourseStatus {
  initial,
  loading,
  success,
  failure;

  bool get isError => this == AddCourseStatus.failure;
  bool get isSuccess => this == AddCourseStatus.success;
  bool get isLoading => this == AddCourseStatus.loading;
  bool get isInitial => this == AddCourseStatus.initial;
}

class AddCourseState extends Equatable {
  final AddCourseStatus status;
  final String? errorMessage;
  final String code;
  final String name;
  final String level;

  const AddCourseState._({
    required this.status,
    required this.errorMessage,
    required this.code,
    required this.name,
    required this.level,
  });

  const AddCourseState.initial()
    : this._(
        status: AddCourseStatus.initial,
        errorMessage: null,
        code: '',
        name: '',
        level: '',
      );

  AddCourseState copyWith({
    AddCourseStatus? status,
    String? errorMessage,
    String? code,
    String? name,
    String? level,
    bool clearError = false,
  }) {
    return AddCourseState._(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      code: code ?? this.code,
      name: name ?? this.name,
      level: level ?? this.level,
    );
  }

  bool get canSubmit =>
      code.trim().isNotEmpty && name.trim().isNotEmpty && level.trim().isNotEmpty;

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    code,
    name,
    level,
  ];
}
