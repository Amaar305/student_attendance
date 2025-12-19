import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/session/session.dart';

class CreateSessionCourseField extends StatelessWidget {
  const CreateSessionCourseField({super.key});

  String _courseLabel(Course course) => '${course.code} - ${course.name}';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SessionCubit>();
    final courses = context.select((SessionCubit c) => c.state.courses);
    final selectedCourse = context.select(
      (SessionCubit c) => c.state.selectedCourse,
    );
    final isLoading = context.select(
      (SessionCubit c) => c.state.status.isLoading,
    );

    final courseLabels = {
      for (final course in courses) _courseLabel(course): course,
    };

    return AppDropdownField.underlineBorder(
      items: courseLabels.keys.toList(),
      hintText: courses.isEmpty ? 'No course found' : 'Select course',
      initialValue:
          selectedCourse != null ? _courseLabel(selectedCourse) : null,
      enabled: !isLoading && courses.isNotEmpty,
      prefixIcon: const Icon(Icons.menu_book_outlined),
      onChanged: (value) {
        final course = value == null ? null : courseLabels[value];
        cubit.onCourseSelected(course);
      },
    );
  }
}
