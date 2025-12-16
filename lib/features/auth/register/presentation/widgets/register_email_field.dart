import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/auth/register/register.dart';

class RegisterEmailField extends StatefulWidget {
  const RegisterEmailField({super.key});

  @override
  State<RegisterEmailField> createState() => _RegisterEmailFieldState();
}

class _RegisterEmailFieldState extends State<RegisterEmailField> {
  final _debouncer = Debouncer();
  final _focusNode = FocusNode();
  late final RegisterCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<RegisterCubit>();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _cubit.onEmailUnfocused();
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
    final emailError = context.select(
      (RegisterCubit cubit) => cubit.state.email.errorMessage,
    );
    return AppTextField.underlineBorder(
      focusNode: _focusNode,
      hintText: 'Email address',
      prefixIcon: Icon(Icons.alternate_email_rounded),
      enabled: !isLoading,
      textInputType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      onChanged: (v) => _debouncer.run(() => _cubit.onEmailChanged(v)),
      errorText: emailError,
    );
  }
}
