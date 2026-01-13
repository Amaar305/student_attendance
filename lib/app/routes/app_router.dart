// app_router.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/app/app.dart';
import 'package:student_attendance/features/auth/auth.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';
import 'package:student_attendance/features/session/session.dart';
import 'package:student_attendance/features/home/home.dart';
import 'package:student_attendance/features/splash/splash.dart';
import 'package:student_attendance/features/student/student.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  final AppCubit _appCubit;
  const AppRouter(AppCubit appCubit) : _appCubit = appCubit;

  GoRouter get router => GoRouter(
    initialLocation: AppRoutes.splash,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    refreshListenable: GoRouterAppCubitRefreshStream(_appCubit.stream),
    redirect: (context, state) {
      final st = _appCubit.state.status;
      final loc = state.matchedLocation.isEmpty
          ? AppRoutes.splash
          : state.matchedLocation;

      bool at(String path) => loc == path || loc.startsWith('$path/');
      String? go(String path) => at(path) ? null : path;

      switch (st) {
        case AppStatus.initializing:
          return go(AppRoutes.splash);
        case AppStatus.unauthenticated:
        case AppStatus.failure:
          return go(AppRoutes.auth);

        case AppStatus.authenticated:
          if (AppRoutes.authRedirectBlock.any(at)) {
            return AppRoutes.home;
          }
          return null;
      }
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthPage(islogin: true),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.lecturerCourseView,
        builder: (context, state) {
          final course = state.extra as Course;
          return CourseViewPage(course: course);
        },
      ),
      GoRoute(
        path: AppRoutes.createSession,
        builder: (context, state) => const CreateSessionPage(),
        routes: [
          GoRoute(
            path: 'session-result',
            name: 'session-result',
            builder: (context, state) {
              final result = state.extra as SessionResult;
              return SessionResultPage(sessionResult: result);
            },
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.scanAttendance,
        builder: (context, state) => const ScanAttendancePage(),
      ),
      GoRoute(
        path: AppRoutes.attendanceHistory,
        builder: (context, state) => const AttendanceHistoryPage(),
      ),
      GoRoute(
        path: AppRoutes.enrollCourse,
        builder: (context, state) => const CourseSearchPage(),
      ),
      GoRoute(
        path: AppRoutes.addCourse,
        builder: (context, state) => const AddCoursePage(),
      ),
      GoRoute(
        path: AppRoutes.activeSessions,
        builder: (context, state) => const ActiveSessionsPage(),
      ),
      GoRoute(
        path: AppRoutes.sessionDetails,
        builder: (context, state) {
          final args = state.extra as SessionDetailsArgs;
          return SessionDetailsPage(
            session: args.session,
            course: args.course,
            students: args.students,
          );
        },
      ),
    ],
  );
}

class GoRouterAppCubitRefreshStream extends ChangeNotifier {
  GoRouterAppCubitRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((event) {
      notifyListeners();
    });
  }
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
