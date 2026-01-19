import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

const _allCoursesValue = '__all__';

class MyStudentsFilters extends StatelessWidget {
  const MyStudentsFilters({
    super.key,
    required this.courses,
    required this.selectedCourseId,
    required this.onCourseChanged,
    required this.onQueryChanged,
  });

  final List<Course> courses;
  final String? selectedCourseId;
  final ValueChanged<String?> onCourseChanged;
  final ValueChanged<String> onQueryChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = <DropdownMenuItem<String>>[
      const DropdownMenuItem(
        value: _allCoursesValue,
        child: Text('All courses'),
      ),
      ...courses.map(
        (course) =>
            DropdownMenuItem(value: course.id, child: Text(course.title)),
      ),
    ];

    return Column(
      children: [
        TextField(
          onChanged: onQueryChanged,
          decoration: InputDecoration(
            hintText: 'Search by name or student ID',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        Gap.v(AppSpacing.sm),
        DropdownButtonFormField<String>(
          initialValue: selectedCourseId ?? _allCoursesValue,
          items: items,
          isExpanded: true,
          onChanged: (value) {
            final nextCourseId = value == _allCoursesValue ? null : value;
            onCourseChanged(nextCourseId);
          },
          decoration: InputDecoration(
            hintText: 'Filter by course',
            prefixIcon: const Icon(Icons.school_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          dropdownColor: theme.cardColor,
        ),
      ],
    );
  }
}
