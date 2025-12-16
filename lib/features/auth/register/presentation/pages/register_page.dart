import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_attendance/app/app.dart';
import 'package:student_attendance/features/auth/auth.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(registerWithDetailsUseCase: getIt()),
      child: RegisterView(),
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isError &&
            state.message != null &&
            state.message!.isNotEmpty) {
          openSnackbar(SnackbarMessage.error(title: state.message!));
        }
      },
      child: AuthShell(
        title: 'Create account',
        subtitle: 'Join the platform and simplify attendance tracking.',
        formFields: const [
          RegisterFullNameField(),
          RegisterStudentStaffIdField(),
          RegisterEmailField(),
          RegisterPasswordField(),
          RegisterConfirmPasswordField(),
          RegisterRoleField(),
        ],
        meta: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have an account?'),
            TextButton(
              onPressed: () =>
                  context.read<AuthCubit>().changeAuth(showLogin: true),
              child: const Text('Sign in'),
            ),
          ],
        ),
        primaryAction: RegisterButton(),
        footer: Text(
          'By creating an account you agree to our terms and privacy policy.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.emphasizeGrey),
        ),
      ),
    );
  }
}
