import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_attendance/app/cubit/app_cubit.dart';
import 'package:student_attendance/app/dI/init.dart';
import 'package:student_attendance/app/routes/app_routes.dart';
import 'package:student_attendance/app/views/app.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';

class LecturerHomePage extends StatelessWidget {
  const LecturerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LecturerHomeBloc(
        user: context.read<AppCubit>().state.user!,
        watchLecturerCoursesUseCase: getIt(),
      )..add(LecturerCoursesSubscriptionRequested()),
      child: LecturerHomeView(),
    );
  }
}

class LecturerHomeView extends StatelessWidget {
  const LecturerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: BlocListener<LecturerHomeBloc, LecturerHomeState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.message != current.message,
        listener: (context, state) {
          if (state.status == LecturerHomeStatus.error &&
              state.message.isNotEmpty) {
            openSnackbar(SnackbarMessage.error(title: state.message));
          }
        },
        child: AppConstrainedScrollView(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xlg,
            children: [
              // Appbar
              LecturerAppBar(),

              // Lecturer Quick Actions
              LecturerQuickActions(),

              // Lecturer's courses
              LecturerHomeCourses(),
            ],
          ),
        ),
      ),
    );
  }
}

class LecturerHomeCourses extends StatelessWidget {
  const LecturerHomeCourses({super.key});

  @override
  Widget build(BuildContext context) {
    final course = context.select(
      (LecturerHomeBloc bloc) => bloc.state.courses,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.lg,
      children: [
        Text(
          'My Courses',
          style: context.titleMedium?.copyWith(
            fontWeight: AppFontWeight.semiBold,
            color: AppColors.primaryDarkBlue,
          ),
        ),

        ...course.map((course) {
          return LecturerCourseTile(
            title: '${course.code} - ${course.name}',
            studentCount: course.studentCount,
            onTap: () =>
                context.push(AppRoutes.lecturerCourseView, extra: course),
          );
        }),
      ],
    );
  }
}
