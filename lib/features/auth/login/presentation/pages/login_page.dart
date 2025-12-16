import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_attendance/app/app.dart';
import 'package:student_attendance/features/auth/auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginCubit(loginWithEmailAndPasswordUseCase: getIt()),
      child: LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isError && state.message.isNotEmpty) {
          openSnackbar(SnackbarMessage.error(title: state.message));
        }
      },
      child: AuthShell(
        title: 'Welcome back',
        subtitle: 'Sign in to keep tracking student attendance seamlessly.',
        formFields: const [LoginEmailField(), LoginPasswordField()],
        meta: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.shield_outlined,
                  size: 18,
                  color: AppColors.emphasizeGrey,
                ),
                SizedBox(width: AppSpacing.xs),
                Text(
                  'Secure login',
                  style: TextStyle(color: AppColors.emphasizeGrey),
                ),
              ],
            ),
            LoginForgotPassword(),
          ],
        ),
        primaryAction: LoginButton(),
        footer: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Don\'t have an account?'),
            TextButton(
              onPressed: () =>
                  context.read<AuthCubit>().changeAuth(showLogin: false),
              child: const Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
