part of 'app_cubit.dart';

enum AppStatus { initializing, authenticated, unauthenticated, failure }

class AppState extends Equatable {
  const AppState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  factory AppState.initial() => const AppState(status: AppStatus.initializing);

  final AppStatus status;
  final AppUser? user;
  final String? errorMessage;

  AppState copyWith({
    AppStatus? status,
    AppUser? user,
    bool clearUser = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AppState(
      status: status ?? this.status,
      user: clearUser ? null : user ?? this.user,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
