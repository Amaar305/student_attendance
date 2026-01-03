part of 'active_sessions_cubit.dart';

enum ActiveSessionsStatus {
  initial,
  loading,
  success,
  failure;

  bool get isLoading => this == ActiveSessionsStatus.loading;
  bool get isError => this == ActiveSessionsStatus.failure;
  bool get isSuccess => this == ActiveSessionsStatus.success;
}

class ActiveSessionsState extends Equatable {
  final ActiveSessionsStatus status;
  final String? errorMessage;
  final List<Session> sessions;
  final List<Course> courses;
  final Set<String> closingSessionIds;

  const ActiveSessionsState._({
    required this.status,
    required this.errorMessage,
    required this.sessions,
    required this.courses,
    required this.closingSessionIds,
  });

  const ActiveSessionsState.initial()
    : this._(
        status: ActiveSessionsStatus.initial,
        errorMessage: null,
        sessions: const [],
        courses: const [],
        closingSessionIds: const <String>{},
      );

  ActiveSessionsState copyWith({
    ActiveSessionsStatus? status,
    String? errorMessage,
    List<Session>? sessions,
    List<Course>? courses,
    Set<String>? closingSessionIds,
    bool clearError = false,
  }) {
    return ActiveSessionsState._(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      sessions: sessions ?? this.sessions,
      courses: courses ?? this.courses,
      closingSessionIds: closingSessionIds ?? this.closingSessionIds,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    sessions,
    courses,
    closingSessionIds,
  ];
}
