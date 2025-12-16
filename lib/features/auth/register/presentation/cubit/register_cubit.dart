import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/auth/register/register.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterWithDetailsUseCase _registerWithDetailsUseCase;
  RegisterCubit({
    required RegisterWithDetailsUseCase registerWithDetailsUseCase,
  }) : _registerWithDetailsUseCase = registerWithDetailsUseCase,
       super(RegisterState.initial());

  /// Changes password visibility, making it visible or not.
  void changePasswordVisibility({bool confirmPass = false}) {
    if (confirmPass) {
      emit(state.copyWith(showConfirmPassword: !state.showConfirmPassword));
    } else {
      emit(state.copyWith(showPassword: !state.showPassword));
    }
  }

  /// Emits initial state of login screen.
  void resetState() => emit(const RegisterState.initial());

  /// Email value was changed, triggering new changes in state.
  void onEmailChanged(String newValue) {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.email;
    final shouldValidate = previousEmailState.invalid;
    final newEmailState = shouldValidate
        ? Email.dirty(newValue)
        : Email.pure(newValue);

    final newScreenState = state.copyWith(email: newEmailState);

    emit(newScreenState);
  }

  /// Email field was unfocused, here is checking if previous state with email
  /// was valid, in order to indicate it in state after unfocus.
  void onEmailUnfocused() {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.email;
    final previousEmailValue = previousEmailState.value;

    final newEmailState = Email.dirty(previousEmailValue);
    final newScreenState = previousScreenState.copyWith(email: newEmailState);
    emit(newScreenState);
  }

  /// Password value was changed, triggering new changes in state.
  /// Checking whether or not value is valid in [Password] and emmiting new
  /// [Password] validation state.
  void onPasswordChanged(String newValue) {
    final previousScreenState = state;
    final previousPasswordState = previousScreenState.password;
    final shouldValidate = previousPasswordState.invalid;
    final newPasswordState = shouldValidate
        ? Password.dirty(newValue)
        : Password.pure(newValue);

    final confirmPasswordError = _confirmPasswordError(
      password: newPasswordState.value,
      confirmPassword: previousScreenState.confirmPassword.value,
    );

    final newScreenState = state.copyWith(
      password: newPasswordState,
      confirmPasswordError: confirmPasswordError,
    );

    emit(newScreenState);
  }

  void onPasswordUnfocused() {
    final previousScreenState = state;
    final previousPasswordState = previousScreenState.password;
    final previousPasswordValue = previousPasswordState.value;

    final newPasswordState = Password.dirty(previousPasswordValue);
    final newScreenState = previousScreenState.copyWith(
      password: newPasswordState,
    );
    emit(newScreenState);
  }

  /// Password value was changed, triggering new changes in state.
  /// Checking whether or not value is valid in [Password] and emmiting new
  /// [Password] validation state.
  void onConfirmPasswordChanged(String newValue) {
    final previousScreenState = state;
    final previousConfirmPasswordState = previousScreenState.confirmPassword;
    final shouldValidate = previousConfirmPasswordState.invalid;
    final newPasswordState = shouldValidate
        ? Password.dirty(newValue)
        : Password.pure(newValue);

    final confirmPasswordError = _confirmPasswordError(
      password: previousScreenState.password.value,
      confirmPassword: newPasswordState.value,
    );

    final newScreenState = state.copyWith(
      confirmPassword: newPasswordState,
      confirmPasswordError: confirmPasswordError,
    );

    emit(newScreenState);
  }

  void onConfirmPasswordUnfocused() {
    final previousScreenState = state;
    final previousConfirmPasswordState = previousScreenState.confirmPassword;
    final previousPasswordValue = previousConfirmPasswordState.value;

    final newPasswordState = Password.dirty(previousPasswordValue);
    final newScreenState = previousScreenState.copyWith(
      confirmPassword: newPasswordState,
    );
    emit(newScreenState);
  }

  /// [FullName] value was changed, triggering new changes in state. Checking
  /// whether or not value is valid in [FullName] and emmiting new [FullName]
  /// validation state.
  void onFullNameChanged(String newValue) {
    final previousScreenState = state;
    final previousFirstNameState = previousScreenState.fullName;
    final shouldValidate = previousFirstNameState.invalid;
    final newFullNameState = shouldValidate
        ? FullName.dirty(newValue)
        : FullName.pure(newValue);

    final newScreenState = state.copyWith(fullName: newFullNameState);

    emit(newScreenState);
  }

  /// [FullName] field was unfocused, here is checking if previous state with
  /// [FullName] was valid, in order to indicate it in state after unfocus.
  void onFullNameUnfocused() {
    final previousScreenState = state;
    final previousFirstNameState = previousScreenState.fullName;
    final previousFullNameValue = previousFirstNameState.value;

    final newFullNameState = FullName.dirty(previousFullNameValue);
    final newScreenState = previousScreenState.copyWith(
      fullName: newFullNameState,
    );
    emit(newScreenState);
  }

  void onStudentStaffIdChanged(String newValue) {
    final previousScreenState = state;
    final previousIdState = previousScreenState.studentStaffId;
    final shouldValidate = previousIdState.invalid;
    final newIdState = shouldValidate
        ? StaffStudentId.dirty(newValue)
        : StaffStudentId.pure(newValue);

    emit(state.copyWith(studentStaffId: newIdState));
  }

  void onStudentStaffIdUnfocused() {
    final previousScreenState = state;
    final previousIdState = previousScreenState.studentStaffId;
    final previousIdValue = previousIdState.value;

    final newIdState = StaffStudentId.dirty(previousIdValue);
    final newScreenState = previousScreenState.copyWith(
      studentStaffId: newIdState,
    );
    emit(newScreenState);
  }

  void onRoleSelected(String? role) {
    if (role == state.role) return;

    emit(state.copyWith(role: role));
  }

  Future<void> submit([void Function(AppUser user)? onSuccess]) async {
    final fullName = FullName.dirty(state.fullName.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final confirmPassword = Password.dirty(state.confirmPassword.value);
    final studentStaffId = StaffStudentId.dirty(state.studentStaffId.value);

    final confirmPasswordError = _confirmPasswordError(
      password: password.value,
      confirmPassword: confirmPassword.value,
    );

    final isFormValid =
        FormzValid([
          fullName,
          email,
          password,
          confirmPassword,
          studentStaffId,
        ]).isFormValid &&
        confirmPasswordError.isEmpty;

    final newState = state.copyWith(
      fullName: fullName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      studentStaffId: studentStaffId,
      confirmPasswordError: confirmPasswordError,
      status: isFormValid ? RegisterStatus.loading : null,
    );

    emit(newState);

    if (!isFormValid) return;

    if (state.role == null) {
      emit(
        state.copyWith(
          message: 'Please select your role',
          status: RegisterStatus.failure,
        ),
      );
      return;
    }

    final isStudent = state.role!.toLowerCase() == 'student';
    final isLecturer = state.role!.toLowerCase() == 'lecturer';

    final res = await _registerWithDetailsUseCase(
      RegisterWithDetailsParams(
        fullName: fullName.value,
        email: email.value,
        password: password.value,
        role: state.role!,
        staffID: isStudent ? null : studentStaffId.value,
        studentID: isLecturer ? null : studentStaffId.value,
      ),
    );

    if (isClosed) return;

    res.fold(
      (l) => emit(
        state.copyWith(message: l.message, status: RegisterStatus.failure),
      ),
      (r) {
        emit(state.copyWith(status: RegisterStatus.success, message: ''));

        onSuccess?.call(r);
      },
    );
  }

  String _confirmPasswordError({
    required String password,
    required String confirmPassword,
  }) {
    if (confirmPassword.isEmpty) return '';
    return password == confirmPassword ? '' : 'Password does not match';
  }
}
