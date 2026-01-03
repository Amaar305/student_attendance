import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_attendance/app/app.dart';
import 'package:student_attendance/features/student/student.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentHomeCubit(
        user: context.read<AppCubit>().state.user!,
        watchMyAttendanceForSessionsUseCase:
            getIt<WatchMyAttendanceForSessionsUseCase>(),
        watchStudentCourseOptionsUseCase: getIt(),
        watchTodaySessionsForStudentUseCase: getIt(),
      )..init(),
      child: StudentHomeView(),
    );
  }
}

class StudentHomeView extends StatelessWidget {
  const StudentHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: StudentAppBarTitle(),
        centerTitle: false,
        actions: [
          // TODO: Customize this button to make it for "Add Course"
          IconButton(
            onPressed: () {
              // context.push(AppRoutes.addCourse);
              context.read<AppCubit>().signOut();
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: AppConstrainedScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: BlocListener<StudentHomeCubit, StudentHomeState>(
          listenWhen: (p, c) => p.errorMessage != c.errorMessage,
          listener: (context, state) {
            if (state.errorMessage != null) {
              openSnackbar(
                SnackbarMessage.error(title: state.errorMessage ?? ''),
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xlg,
            children: [
              ScanQrcodeContainer(),
              StudentQuickAction(),
              StudentTodaysClasses(),
            ],
          ),
        ),
      ),
    );
  }
}
