import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_attendance/features/session/session.dart';

class CreateSessionDateField extends StatefulWidget {
  const CreateSessionDateField({super.key});

  @override
  State<CreateSessionDateField> createState() => _CreateSessionDateFieldState();
}

class _CreateSessionDateFieldState extends State<CreateSessionDateField> {
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

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate() async {
    final cubit = context.read<SessionCubit>();
    final current = cubit.state.startDate ?? DateTime.now();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      cubit.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = context.select(
      (SessionCubit c) => c.state.startDate,
    );
    final isLoading = context.select(
      (SessionCubit c) => c.state.status.isLoading,
    );

    final text = selectedDate == null ? '' : _formatDate(selectedDate);
    if (_controller.text != text) {
      _controller.text = text;
    }

    return AppTextField.underlineBorder(
      hintText: 'Select date',
      prefixIcon: const Icon(Icons.event_outlined),
      readOnly: true,
      enabled: !isLoading,
      textController: _controller,
      onTap: isLoading ? null : _pickDate,
    );
  }
}
