import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_attendance/core/common/common.dart';
import 'package:student_attendance/features/lecturer/presentation/course/course.dart';

class CourseSegmentedToggle extends StatelessWidget {
  const CourseSegmentedToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.select(
      (CourseViewBloc bloc) => bloc.state.selectedIndex,
    );
    return SegmentedToggle(
      options: const [
        SegmentedToggleOption(label: 'Newest'),
        SegmentedToggleOption(label: 'Oldest'),
      ],
      selectedIndex: selectedIndex,
      onChanged: (val) => context.read<CourseViewBloc>().add(
        CourseViewToggleNewest(selectedIndex: val),
      ),
    );
  }
}
