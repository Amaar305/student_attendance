import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_attendance/features/lecturer/presentation/course/course.dart';

class CourseStatSection extends StatelessWidget {
  const CourseStatSection({super.key});

  @override
  Widget build(BuildContext context) {
    final totalSessions = context.select(
      (CourseViewBloc bloc) => bloc.state.totalSessions,
    );
    final overallAttendancePercent = context.select(
      (CourseViewBloc bloc) => bloc.state.overallAttendancePercent,
    );
    final cards = [
      CourseStat(
        title: 'Overall Attendance',
        value: '${overallAttendancePercent.toStringAsFixed(1)}%',
        subtitle: 'Across $totalSessions sessions',
        subtitleColor: Colors.grey,
        icon: Icons.analytics_outlined,
        accentColor: AppColors.green,
      ),
      CourseStat(
        title: 'Total Sessions',
        value: '$totalSessions',
        subtitle: 'Held so far',
        icon: Icons.event_note_outlined,
        accentColor: AppColors.blue,
      ),
    ];
    return Row(
      spacing: AppSpacing.lg,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: cards
          .map((e) => Expanded(child: CourseStatCard(stat: e)))
          .toList(),
    );
  }
}
