import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth.dart';

/// {@template auth_page}
/// Auth page. Shows login or signup page depending on the state of `AuthCubit`.
/// {@endtemplate}
class AuthPage extends StatelessWidget {
  /// {@macro auth_page}
  final bool islogin;
  const AuthPage({super.key, required this.islogin});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: AuthView(islogin: islogin),
    );
  }
}

/// {@template auth_view}
/// Auth view. Shows login or signup page depending on the state of [AuthCubit].
/// {@endtemplate}
class AuthView extends StatelessWidget {
  final bool islogin;

  /// {@macro auth_view}
  const AuthView({super.key, required this.islogin});

  @override
  Widget build(BuildContext context) {
    final showLogin = context.select((AuthCubit b) => b.state) && islogin;

    return PageTransitionSwitcher(
      reverse: showLogin,
      transitionBuilder: (child, animation, secondaryAnimation) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
      child: showLogin ? const LoginPage() : const RegisterPage(),
    );
  }
}
