part of 'login_cubit.dart';

enum LoginStatus {
  initial,
  loading,
  success,
  failure;

  bool get isError => this == LoginStatus.failure;
  bool get isSuccess => this == LoginStatus.success;
  bool get isLoading => this == LoginStatus.loading;
}

class LoginState extends Equatable {
  final LoginStatus status;
  final String message;
  final Email email;
  final Password password;
  final bool showPassword;
  final bool rememberMe;

  const LoginState._({
    required this.status,
    required this.message,
    required this.email,
    required this.password,
    this.rememberMe = false,
    this.showPassword = false,
  });

  const LoginState.initial()
    : this._(
        status: LoginStatus.initial,
        message: '',
        password: const Password.pure(),
        email: const Email.pure(),
      );

  LoginState copyWith({
    LoginStatus? status,
    String? message,
    Email? email,
    Password? password,
    bool? showPassword,
    bool? rememberMe,
  }) => LoginState._(
    status: status ?? this.status,
    message: message ?? this.message,
    email: email ?? this.email,
    password: password ?? this.password,
    rememberMe: rememberMe ?? this.rememberMe,
    showPassword: showPassword ?? this.showPassword,
  );

  @override
  List<Object?> get props => [
    status,
    message,
    rememberMe,
    showPassword,
    
    password,
    email,
  ];
}
