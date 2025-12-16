part of 'register_cubit.dart';

enum RegisterStatus {
  initial,
  loading,
  success,
  failure;

  bool get isError => this == RegisterStatus.failure;
  bool get isSuccess => this == RegisterStatus.success;
  bool get isLoading => this == RegisterStatus.loading;
}

class RegisterState extends Equatable {
  final RegisterStatus status;
  final String? message;
  final FullName fullName;
  final Email email;
  final Password password;
  final Password confirmPassword;
  final StaffStudentId studentStaffId;
  final String? role;
  final bool showPassword;
  final bool showConfirmPassword;
  final String? confirmPasswordError;

  const RegisterState._({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.role,
    required this.status,
    required this.message,
    this.showConfirmPassword = false,
    this.showPassword = false,
    this.confirmPasswordError,
    required this.studentStaffId,
  });

  const RegisterState.initial()
    : this._(
        status: RegisterStatus.initial,
        fullName: const FullName.pure(),
        email: const Email.pure(),
        password: const Password.pure(),
        confirmPassword: const Password.pure(),
        studentStaffId: const StaffStudentId.pure(),
        role: null,
        message: null,
      );

  RegisterState copyWith({
    RegisterStatus? status,
    FullName? fullName,
    Email? email,
    Password? password,
    Password? confirmPassword,
    StaffStudentId? studentStaffId,
    String? role,
    bool? showPassword,
    bool? showConfirmPassword,
    String? confirmPasswordError,
    String? message,
  }) => RegisterState._(
    status: status ?? this.status,
    message: message ?? this.message,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    password: password ?? this.password,
    confirmPassword: confirmPassword ?? this.confirmPassword,
    studentStaffId: studentStaffId ?? this.studentStaffId,
    role: role ?? this.role,
    showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
    showPassword: showPassword ?? this.showPassword,
    confirmPasswordError: confirmPasswordError ?? this.confirmPasswordError,
  );

  @override
  List<Object?> get props => [
    fullName,
    email,
    password,
    confirmPassword,
    studentStaffId,
    role,
    showPassword,
    showConfirmPassword,
    message,
    status,
    confirmPasswordError,
  ];
}
