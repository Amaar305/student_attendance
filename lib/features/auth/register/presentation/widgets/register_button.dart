import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/auth/register/register.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (RegisterCubit element) => element.state.status.isLoading,
    );

    return PrimaryButton(
      isLoading: isLoading,
      label: 'Create account',
      onPressed: () =>
          context.read<RegisterCubit>().submit((user) => logD(user.toJson())),
    );
  }
}
