import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/auth/login/login.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginWithEmailAndPasswordUseCase _loginWithEmailAndPasswordUseCase;
  LoginCubit({
    required LoginWithEmailAndPasswordUseCase loginWithEmailAndPasswordUseCase,
  }) : _loginWithEmailAndPasswordUseCase = loginWithEmailAndPasswordUseCase,
       super(LoginState.initial());

  void changePasswordVisibility() =>
      emit(state.copyWith(showPassword: !state.showPassword));

  /// Emits initial state of login screen.
  void resetState({required bool hasBiometric}) => emit(LoginState.initial());

  void onRememberMeChecked(bool rememberMe) {
    if (state.rememberMe == rememberMe) return;

    emit(state.copyWith(rememberMe: rememberMe));
  }

  void onEmailChanged(String value) {
    final previouScreenState = state;

    final previousEmailState = previouScreenState.email;
    final shouldValidate = previousEmailState.invalid;

    final newEmailState = shouldValidate
        ? Email.dirty(value)
        : Email.pure(value);

    final newScreenState = state.copyWith(email: newEmailState);

    emit(newScreenState);
  }

  void onEmailUnfocused() {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.email;
    final previousEmailValue = previousEmailState.value;

    final newEmailState = Email.dirty(previousEmailValue);

    final newScreenState = previousScreenState.copyWith(email: newEmailState);

    emit(newScreenState);
  }

  void onPasswordChanged(String value) {
    final previousScreenState = state;
    final previousPasswordState = previousScreenState.password;
    final shouldValidate = previousPasswordState.invalid;

    final newPasswordValue = shouldValidate
        ? Password.dirty(value)
        : Password.pure(value);

    final newScreenState = previousScreenState.copyWith(
      password: newPasswordValue,
    );
    emit(newScreenState);
  }

  void onPasswordUnfocused() {
    final previousScreenState = state;
    final previousPasswordState = previousScreenState.password;
    final previousPasswordValue = previousPasswordState.value;

    final newPasswordState = Password.dirty(previousPasswordValue);

    final newPasswordScreen = previousScreenState.copyWith(
      password: newPasswordState,
    );

    emit(newPasswordScreen);
  }

  void submit([void Function(AppUser user)? onSuccess]) async {
    // Validate the raw form values before hitting the network.
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    final isFormValid = FormzValid([email, password]).isFormValid;

    final newState = state.copyWith(
      email: email,
      password: password,
      status: isFormValid ? LoginStatus.loading : null,
    );

    emit(newState);

    if (!isFormValid) return;

    final res = await _loginWithEmailAndPasswordUseCase(
      LoginWithEmailAndPasswordParams(
        email: email.value,
        password: password.value,
      ),
    );

    if (isClosed) return;

    res.fold(
      (l) =>
          emit(state.copyWith(message: l.message, status: LoginStatus.failure)),
      (r) {
        emit(state.copyWith(status: LoginStatus.success));

        onSuccess?.call(r);
      },
    );
  }
}
