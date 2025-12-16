import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_attendance/features/auth/register/register.dart';

class RegisterRoleField extends StatelessWidget {
  const RegisterRoleField({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    final selectedRole = context.select(
      (RegisterCubit cubit) => cubit.state.role,
    );
    final isLoading = context.select(
      (RegisterCubit cubit) => cubit.state.status.isLoading,
    );

    return AppDropdownField.underlineBorder(
      hintText: 'Select role',
      prefixIcon: const Icon(Icons.person_outline),
      items: const ['Student', 'Lecturer'],
      initialValue: selectedRole,
      enabled: !isLoading,
      onChanged: cubit.onRoleSelected,
    );
  }
}
