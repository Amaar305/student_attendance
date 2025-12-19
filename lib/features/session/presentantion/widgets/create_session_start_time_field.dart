import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_attendance/features/session/session.dart';

class CreateSessionStartTimeField extends StatefulWidget {
  const CreateSessionStartTimeField({super.key});

  @override
  State<CreateSessionStartTimeField> createState() =>
      _CreateSessionStartTimeFieldState();
}

class _CreateSessionStartTimeFieldState
    extends State<CreateSessionStartTimeField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final cubit = context.read<SessionCubit>();
    final picked = await showTimePicker(
      context: context,
      initialTime: cubit.state.startTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      cubit.onStartTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final startTime = context.select(
      (SessionCubit c) => c.state.startTime,
    );
    final isLoading = context.select(
      (SessionCubit c) => c.state.status.isLoading,
    );

    final text = startTime == null ? '' : startTime.format(context);
    if (_controller.text != text) {
      _controller.text = text;
    }

    return AppTextField.underlineBorder(
      hintText: 'Start time',
      prefixIcon: const Icon(Icons.access_time_rounded),
      readOnly: true,
      enabled: !isLoading,
      textController: _controller,
      onTap: isLoading ? null : _pickTime,
    );
  }
}
