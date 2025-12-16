import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/auth/register/register.dart';

class RegisterStudentStaffIdField extends StatefulWidget {
  const RegisterStudentStaffIdField({super.key});

  @override
  State<RegisterStudentStaffIdField> createState() =>
      _RegisterStudentStaffIdFieldState();
}

class _RegisterStudentStaffIdFieldState
    extends State<RegisterStudentStaffIdField> {
  final _debouncer = Debouncer();
  final _focusNode = FocusNode();
  late final RegisterCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<RegisterCubit>();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _cubit.onStudentStaffIdUnfocused();
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
    final idError = context.select(
      (RegisterCubit cubit) => cubit.state.studentStaffId.errorMessage,
    );

    return AppTextField.underlineBorder(
      hintText: 'Student/Staff ID',
      prefixIcon: const Icon(Icons.badge_outlined),
      focusNode: _focusNode,
      enabled: !isLoading,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.username],
      onChanged: (v) =>
          _debouncer.run(() => _cubit.onStudentStaffIdChanged(v)),
      errorText: idError,
    );
  }
}
