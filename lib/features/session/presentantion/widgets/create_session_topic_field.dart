import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_attendance/features/session/session.dart';

class CreateSessionTopicField extends StatelessWidget {
  const CreateSessionTopicField({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SessionCubit>();
    final isLoading = context.select(
      (SessionCubit c) => c.state.status.isLoading,
    );
    return AppTextField.underlineBorder(
      hintText: 'Topic (optional)',
      prefixIcon: const Icon(Icons.topic_outlined),
      textInputAction: TextInputAction.next,
      enabled: !isLoading,
      onChanged: cubit.onTopicChanged,
    );
  }
}
