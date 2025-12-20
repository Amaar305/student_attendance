import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:student_attendance/features/lecturer/presentation/course/course.dart';

class CourseAttendenceSection extends StatelessWidget {
  const CourseAttendenceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = context.select(
      (CourseViewBloc bloc) => bloc.state.sessions,
    );
    final totalStudents = context.select(
      (CourseViewBloc bloc) => bloc.state.totalStudents,
    );

    if (sessions.isEmpty) {
      return const Center(
        child: Text('No sessions yet'),
      );
    }

    return ListView.separated(
      separatorBuilder: (context, _) => _DividerInset(),
      padding: const EdgeInsets.only(top: 6, bottom: 18),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        final percent = _attendancePercent(
          attendanceCount: session.attendanceCount,
          totalStudents: totalStudents,
        );
        final ringColor = _ringColor(percent);
        final date = _formatDate(session.dateTimeStart);
        final time =
            _formatTimeRange(session.dateTimeStart, session.dateTimeEnd);
        final fraction = '${
          session.attendanceCount
        } / ${totalStudents == 0 ? '-' : totalStudents}';

        return AttendanceRow(
          percent: percent,
          ringColor: ringColor,
          date: date,
          time: time,
          fraction: fraction,
        );
      },
    );
  }
}

class _DividerInset extends StatelessWidget {
  const _DividerInset();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 20),
      child: Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
    );
  }
}

int _attendancePercent({
  required int attendanceCount,
  required int totalStudents,
}) {
  if (totalStudents == 0) return 0;
  final ratio = attendanceCount / totalStudents;
  return (ratio * 100).clamp(0, 100).round();
}

Color _ringColor(int percent) {
  if (percent >= 90) return AppColors.green;
  if (percent >= 70) return AppColors.blue;
  if (percent >= 50) return AppColors.orange;
  return AppColors.red;
}

String _formatDate(DateTime date) =>
    DateFormat('MMMM d, yyyy').format(date.toLocal());

String _formatTimeRange(DateTime start, DateTime? end) {
  final startText = DateFormat('h:mm a').format(start.toLocal());
  if (end == null) return startText;
  final endText = DateFormat('h:mm a').format(end.toLocal());
  return '$startText - $endText';
}
