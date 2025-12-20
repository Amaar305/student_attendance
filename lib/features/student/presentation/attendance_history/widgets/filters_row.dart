import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_attendance/features/student/domain/entities/history_range.dart';
import 'package:student_attendance/features/student/presentation/attendance_history/cubit/attendance_history_cubit.dart';

import 'attendance_dropdown_card.dart';

class FiltersRow extends StatelessWidget {
  const FiltersRow({super.key, required this.state});
  final AttendanceHistoryState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AttendanceHistoryCubit>();

    return Row(
      children: [
        Expanded(
          child: AttendanceDropdownCard(
            title: 'Courses',
            value: state.selectedCourseId ?? '__all__',
            items: [
              const DropdownMenuItem(
                value: '__all__',
                child: Text('All Courses'),
              ),
              ...state.courseOptions.map(
                (c) => DropdownMenuItem(
                  value: c.courseId,
                  child: Text(c.courseTitle, overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
            onChanged: (v) {
              if (v == null || v == '__all__') {
                cubit.setCourseFilter(null);
              } else {
                cubit.setCourseFilter(v);
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AttendanceDropdownCard(
            title: 'Range',
            value: state.selectedRange.name,
            items: HistoryRange.values
                .map(
                  (r) => DropdownMenuItem(value: r.name, child: Text(r.label)),
                )
                .toList(),
            onChanged: (v) {
              if (v == null) return;
              final range = HistoryRange.values.firstWhere((e) => e.name == v);
              cubit.setRange(range);
            },
          ),
        ),
      ],
    );
  }
}
