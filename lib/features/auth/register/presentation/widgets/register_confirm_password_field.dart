import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/auth/register/register.dart';

class RegisterConfirmPasswordField extends StatefulWidget {
  const RegisterConfirmPasswordField({super.key});

  @override
  State<RegisterConfirmPasswordField> createState() =>
      _RegisterConfirmPasswordFieldState();
}

class _RegisterConfirmPasswordFieldState
    extends State<RegisterConfirmPasswordField> {
  final _debouncer = Debouncer();
  final _focusNode = FocusNode();
  late final RegisterCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<RegisterCubit>();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _cubit.onConfirmPasswordUnfocused();
      }
    });
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (RegisterCubit cubit) => cubit.state.status.isLoading,
    );
    final showPassword = context.select(
      (RegisterCubit cubit) => cubit.state.showConfirmPassword,
    );
    final passwordError = context.select(
      (RegisterCubit cubit) => cubit.state.confirmPassword.errorMessage,
    );
    final confirmPasswordError = context.select(
      (RegisterCubit cubit) => cubit.state.confirmPasswordError??'',
    );

    return AppTextField.underlineBorder(
      hintText: 'Confirm password',
      prefixIcon: Icon(Icons.lock_outline_rounded),
      focusNode: _focusNode,
      errorText: confirmPasswordError.isNotEmpty
          ? confirmPasswordError
          : passwordError,
      enabled: !isLoading,
      textInputAction: TextInputAction.done,
      obscureText: !showPassword,
      onChanged: (v) =>
          _debouncer.run(() => _cubit.onConfirmPasswordChanged(v)),
      suffixIcon: Tappable.faded(
        backgroundColor: AppColors.transparent,
        onTap: () => isLoading
            ? null
            : _cubit.changePasswordVisibility(confirmPass: true),
        child: Icon(
          !showPassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          size: 20,
          color: context
              .customAdaptiveColor(dark: AppColors.grey)
              .withValues(alpha: isLoading ? .4 : 1),
        ),
      ),
    );
  }
}
