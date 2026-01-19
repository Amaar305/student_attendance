import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_attendance/app/app.dart';
import 'package:student_attendance/features/session/session.dart';

class CreateSessionPage extends StatelessWidget {
  const CreateSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SessionCubit(
        user: context.read<AppCubit>().state.user!,
        buildSessionQrPayloadUseCase: getIt(),
        closeSessionUseCase: getIt(),
        createOrGetOpenSessionUseCase: getIt(),
        fetchLecturerCoursesUseCase: getIt(),
      ),
      child: const CreateSessionView(),
    );
  }
}

class CreateSessionView extends StatefulWidget {
  const CreateSessionView({super.key});

  @override
  State<CreateSessionView> createState() => _CreateSessionViewState();
}

class _CreateSessionViewState extends State<CreateSessionView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SessionCubit>().fetchLecturerCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionCubit, SessionState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.message != current.message,
      listener: (context, state) {
        if (state.status.isLoading) {
          showLoadingOverlay(context);
        } else {
          hideLoadingOverlay();
        }

        if (state.status.isError && state.message.isNotEmpty) {
          openSnackbar(SnackbarMessage.error(title: state.message));
        }
      },
      child: AppScaffold(
        appBar: AppBar(title: Text('Create Class')),
        body: AppConstrainedScrollView(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppSpacing.xlg,
                children: const [
                  CreateSessionCourseField(),
                  CreateSessionTopicField(),
                  CreateSessionDateField(),
                  _CreateSessionTimeAndLateRow(),
                ],
              ),
              const CreateSessionButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateSessionTimeAndLateRow extends StatelessWidget {
  const _CreateSessionTimeAndLateRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.lg,
      children: const [
        Expanded(child: CreateSessionStartTimeField()),
        Expanded(child: CreateSessionLateMinutesField()),
      ],
    );
  }
}
