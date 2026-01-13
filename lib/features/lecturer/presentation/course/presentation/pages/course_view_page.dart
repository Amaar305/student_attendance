import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/app/app.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';

class CourseViewPage extends StatelessWidget {
  const CourseViewPage({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseViewBloc(
        course: course,
        watchCourseSessionsUseCase: getIt<WatchCourseSessionsUseCase>(),
        getCourseStudentCountUseCase: getIt<GetCourseStudentCountUseCase>(),
        watchCourseStudentCountUseCase: getIt<WatchCourseStudentCountUseCase>(),
        watchSessionAttendanceCountUseCase:
            getIt<WatchSessionAttendanceCountUseCase>(),
      )..add(CourseSessionsSubscriptionRequested()),
      child: CourseView(course: course),
    );
  }
}

class CourseView extends StatelessWidget {
  const CourseView({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: Text(course.title, style: context.titleMedium)),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: BlocListener<CourseViewBloc, CourseViewState>(
          listenWhen: (previous, current) =>
              previous.status != current.status ||
              previous.message != current.message,
          listener: (context, state) {
            if (state.status.isError && state.message.isNotEmpty) {
              openSnackbar(SnackbarMessage.error(title: state.message));
            }
          },
          child: Column(
            spacing: AppSpacing.xlg,
            children: [
              CourseStatSection(),
              CourseSegmentedToggle(),
              Expanded(child: CourseAttendenceSection(course: course)),
            ],
          ),
        ),
      ),
    );
  }
}
