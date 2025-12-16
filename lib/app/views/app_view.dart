import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_attendance/app/app.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: getIt<AppCubit>(),
    child: const _AppRouterView(),
  );
}

class _AppRouterView extends StatefulWidget {
  const _AppRouterView();

  @override
  State<_AppRouterView> createState() => _AppRouterViewState();
}

class _AppRouterViewState extends State<_AppRouterView> {
  late final AppCubit _appCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _appCubit = context.read<AppCubit>();

    _router = AppRouter(_appCubit).router;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: const AppTheme().theme,
      darkTheme: const AppDarkTheme().theme,
      themeMode: ThemeMode.light,
      routerConfig: _router,
      builder: (context, child) {
        return Stack(
          children: [
            child ?? const SizedBox.shrink(),
            AppSnackbar(key: snackbarKey),
          ],
        );
      },
    );
  }
}
