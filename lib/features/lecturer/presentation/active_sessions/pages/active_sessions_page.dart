import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/app/app.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';

class ActiveSessionsPage extends StatelessWidget {
  const ActiveSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActiveSessionsCubit(
        user: context.read<AppCubit>().state.user!,
        watchLecturerCoursesUseCase: getIt(),
        watchCourseSessionsUseCase: getIt(),
        closeSessionUseCase: getIt(),
      )..init(),
      child: const ActiveSessionsView(),
    );
  }
}

class ActiveSessionsView extends StatelessWidget {
  const ActiveSessionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('Active Sessions'), centerTitle: true),
      body: BlocConsumer<ActiveSessionsCubit, ActiveSessionsState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          final message = state.errorMessage;
          if (message != null && message.isNotEmpty) {
            openSnackbar(SnackbarMessage.error(title: message));
          }
        },
        builder: (context, state) {
          if (state.status.isLoading && state.sessions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.sessions.isEmpty) {
            return const Center(child: Text('No active sessions'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: state.sessions.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final session = state.sessions[index];
              final course = _courseFor(state.courses, session.courseId);
              final isClosing = state.closingSessionIds.contains(session.id);

              return ActiveSessionTile(
                session: session,
                course: course,
                isClosing: isClosing,
                onCancel: () =>
                    context.read<ActiveSessionsCubit>().cancelSession(session),
              );
            },
          );
        },
      ),
    );
  }
}

Course? _courseFor(List<Course> courses, String courseId) {
  for (final course in courses) {
    if (course.id == courseId) return course;
  }
  return null;
}
