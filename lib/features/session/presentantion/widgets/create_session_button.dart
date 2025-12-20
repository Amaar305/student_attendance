import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_attendance/features/session/session.dart';

class CreateSessionButton extends StatelessWidget {
  const CreateSessionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SessionCubit>();
    final isLoading = context.select(
      (SessionCubit c) => c.state.status.isLoading,
    );

    return AppButton(
      text: isLoading ? 'Creating...' : 'Create Session',
      width: double.infinity,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.deepBlue,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.lg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
      ),
      onPressed: isLoading
          ? null
          : () => cubit.createSession(
              onSuccess: (sessionResult) => context.pushNamed(
                'session-result',
                extra: sessionResult,
              ),
            ),
    );
  }
}
