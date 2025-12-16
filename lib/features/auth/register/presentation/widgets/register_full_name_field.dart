import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/auth/auth.dart';

class RegisterFullNameField extends StatefulWidget {
  const RegisterFullNameField({super.key});

  @override
  State<RegisterFullNameField> createState() => _RegisterFullNameFieldState();
}

class _RegisterFullNameFieldState extends State<RegisterFullNameField> {
  final _debouncer = Debouncer();
  final _focusNode = FocusNode();
  late final RegisterCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<RegisterCubit>();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _cubit.onFullNameUnfocused();
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

    final fullNameError = context.select(
      (RegisterCubit cubit) => cubit.state.fullName.errorMessage,
    );
    return AppTextField.underlineBorder(
      hintText: 'Full name',
      prefixIcon: Icon(Icons.person_outline_rounded),
      focusNode: _focusNode,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      autofillHints: const [AutofillHints.givenName],
      enabled: !isLoading,
      onChanged: (v) => _debouncer.run(() => _cubit.onFullNameChanged(v)),
      errorText: fullNameError,
      errorMaxLines: 3,
    );
  }
}
