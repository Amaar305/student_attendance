import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/auth/register/register.dart';

class RegisterPasswordField extends StatefulWidget {
  const RegisterPasswordField({
    super.key,
  });

  @override
  State<RegisterPasswordField> createState() => _RegisterPasswordFieldState();
}

class _RegisterPasswordFieldState extends State<RegisterPasswordField> {
  final _debouncer = Debouncer();
  final _focusNode = FocusNode();
  late final RegisterCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<RegisterCubit>();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _cubit.onPasswordUnfocused();
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
      (RegisterCubit cubit) => cubit.state.showPassword,
    );
    final passwordError = context.select(
      (RegisterCubit cubit) => cubit.state.password.errorMessage,
    );

    return AppTextField.underlineBorder(
      hintText: 'Password',
      prefixIcon: Icon(Icons.lock_outline_rounded),
      focusNode: _focusNode,
      errorText: passwordError,
      enabled: !isLoading,
      obscureText: !showPassword,
      textInputAction: TextInputAction.next,
      onChanged: (v) => _debouncer.run(() => _cubit.onPasswordChanged(v)),
      suffixIcon: Tappable.faded(
        backgroundColor: AppColors.transparent,
        onTap: isLoading ? null : _cubit.changePasswordVisibility,
        child: Icon(
          !showPassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          size: AppSize.iconSizeSmall + 2,
          color: context
              .customAdaptiveColor(dark: AppColors.grey)
              .withValues(alpha: isLoading ? .4 : 1),
        ),
      ),
    );
  }
}
