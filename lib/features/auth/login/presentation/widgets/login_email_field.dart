import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/auth/login/presentation/presentation.dart';

class LoginEmailField extends StatefulWidget {
  const LoginEmailField({super.key});

  @override
  State<LoginEmailField> createState() => _LoginEmailFieldState();
}

class _LoginEmailFieldState extends State<LoginEmailField> {
  late final LoginCubit _cubit;
  final _debouncer = Debouncer();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _cubit = context.read<LoginCubit>();
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
      (LoginCubit cubit) => cubit.state.status.isLoading,
    );
    final emailErrorMessage = context.select(
      (LoginCubit cubit) => cubit.state.email.errorMessage,
    );
    return AppTextField.underlineBorder(
      enabled: !isLoading,
      focusNode: _focusNode,
      hintText: 'Email address',
      textInputType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      prefixIcon: Icon(Icons.alternate_email_rounded),
      errorText: emailErrorMessage,

      onChanged: (val) => _debouncer.run(() => _cubit.onEmailChanged(val)),
    );
  }
}
