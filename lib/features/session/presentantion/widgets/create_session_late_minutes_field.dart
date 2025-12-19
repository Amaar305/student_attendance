import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_attendance/features/session/session.dart';

class CreateSessionLateMinutesField extends StatefulWidget {
  const CreateSessionLateMinutesField({super.key});

  @override
  State<CreateSessionLateMinutesField> createState() =>
      _CreateSessionLateMinutesFieldState();
}

class _CreateSessionLateMinutesFieldState
    extends State<CreateSessionLateMinutesField> {
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

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SessionCubit>();
    final minutes = context.select(
      (SessionCubit c) => c.state.lateAfterMinutes,
    );
    final isLoading = context.select(
      (SessionCubit c) => c.state.status.isLoading,
    );

    final text = '$minutes';
    if (_controller.text != text) {
      _controller.text = text;
    }

    return AppTextField.underlineBorder(
      hintText: 'Late after (mins)',
      prefixIcon: const Icon(Icons.timer_off_outlined),
      suffixText: 'mins',
      textInputType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textController: _controller,
      enabled: !isLoading,
      onChanged: cubit.onLateAfterMinutesChanged,
    );
  }
}
