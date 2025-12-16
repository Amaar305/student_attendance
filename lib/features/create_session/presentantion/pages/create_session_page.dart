import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class CreateSessionPage extends StatelessWidget {
  const CreateSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CreateSessionView();
  }
}

class CreateSessionView extends StatefulWidget {
  const CreateSessionView({super.key});

  @override
  State<CreateSessionView> createState() => _CreateSessionViewState();
}

class _CreateSessionViewState extends State<CreateSessionView> {
  final _courses = const [
    'CSC101 - Intro to Programming',
    'MTH201 - Calculus II',
    'PHY110 - Mechanics',
  ];

  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  String? _selectedCourse;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void dispose() {
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() {
      _selectedDate = picked;
      _dateController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    });
  }

  Future<void> _selectTime({
    required TextEditingController controller,
    required bool isStartTime,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (_startTime ?? TimeOfDay.now())
          : (_endTime ?? TimeOfDay.now()),
    );
    if (picked == null) return;
    setState(() {
      if (isStartTime) {
        _startTime = picked;
      } else {
        _endTime = picked;
      }
      controller.text = picked.format(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: Text('Create Session')),
      body: AppConstrainedScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.xlg,
              children: [
                AppDropdownField.underlineBorder(
                  items: _courses,
                  hintText: 'Select course',
                  initialValue: _selectedCourse,
                  prefixIcon: const Icon(Icons.menu_book_outlined),
                  onChanged: (value) =>
                      setState(() => _selectedCourse = value),
                ),
                AppTextField.underlineBorder(
                  hintText: 'Select date',
                  prefixIcon: const Icon(Icons.event_outlined),
                  readOnly: true,
                  textController: _dateController,
                  onTap: _selectDate,
                ),
                Row(
                  spacing: AppSpacing.lg,
                  children: [
                    Expanded(
                      child: AppTextField.underlineBorder(
                        hintText: 'Start time',
                        prefixIcon: const Icon(Icons.access_time_rounded),
                        readOnly: true,
                        textController: _startTimeController,
                        onTap: () => _selectTime(
                          controller: _startTimeController,
                          isStartTime: true,
                        ),
                      ),
                    ),
                    Expanded(
                      child: AppTextField.underlineBorder(
                        hintText: 'End time',
                        prefixIcon:
                            const Icon(Icons.access_time_filled_outlined),
                        readOnly: true,
                        textController: _endTimeController,
                        onTap: () => _selectTime(
                          controller: _endTimeController,
                          isStartTime: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            AppButton(
              text: 'Create Session',
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
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
