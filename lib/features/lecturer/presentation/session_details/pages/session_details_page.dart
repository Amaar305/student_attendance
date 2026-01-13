import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/lecturer/domain/entities/session_student_attendance.dart';
import 'package:student_attendance/features/lecturer/presentation/session_details/widgets/widgets.dart';

class SessionDetailsArgs {
  const SessionDetailsArgs({
    required this.session,
    required this.course,
    required this.students,
  });

  final Session session;
  final Course course;
  final List<SessionStudentAttendance> students;
}

class SessionDetailsPage extends StatelessWidget {
  const SessionDetailsPage({
    super.key,
    required this.session,
    required this.course,
    required this.students,
  });

  final Session session;
  final Course course;
  final List<SessionStudentAttendance> students;

  @override
  Widget build(BuildContext context) {
    return SessionDetailsView(
      session: session,
      course: course,
      students: students,
    );
  }
}

class SessionDetailsView extends StatefulWidget {
  const SessionDetailsView({
    super.key,
    required this.session,
    required this.course,
    required this.students,
  });

  final Session session;
  final Course course;
  final List<SessionStudentAttendance> students;

  @override
  State<SessionDetailsView> createState() => _SessionDetailsViewState();
}

class _SessionDetailsViewState extends State<SessionDetailsView> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalStudents = widget.students.length;
    final presentCount =
        widget.students.where((s) => s.status != null).length;
    final absentCount = totalStudents - presentCount;
    final filteredStudents = _filteredStudents(widget.students, _query);
    final sessionSummary = _sessionSummary(widget.session);

    return AppScaffold(
      appBar: AppBar(
        title: Text(
          widget.course.title,
          style: context.titleMedium,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sessionSummary,
              style: context.bodySmall?.copyWith(
                color: AppColors.emphasizeGrey,
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
            Gap.v(AppSpacing.sm),
            SessionStatsRow(
              totalStudents: totalStudents,
              presentCount: presentCount,
              absentCount: absentCount,
            ),
            Gap.v(AppSpacing.lg),
            TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search by name or student ID',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            Gap.v(AppSpacing.md),
            Expanded(
              child: filteredStudents.isEmpty
                  ? const Center(
                      child: Text(
                        'No students found.',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredStudents.length,
                      separatorBuilder: (context, _) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final student = filteredStudents[index];
                        return SessionStudentTile(item: student);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<SessionStudentAttendance> _filteredStudents(
    List<SessionStudentAttendance> students,
    String query,
  ) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return students;
    return students.where((item) {
      final name = (item.student.name ?? '').toLowerCase();
      final studentId =
          (item.student.studentNumber ?? item.student.id).toLowerCase();
      final id = item.student.id.toLowerCase();
      return name.contains(trimmed) ||
          studentId.contains(trimmed) ||
          id.contains(trimmed);
    }).toList();
  }
}

String _sessionSummary(Session session) {
  final date = DateFormat('MMM d, yyyy').format(session.dateTimeStart.toLocal());
  final timeRange = _formatTimeRange(
    session.dateTimeStart,
    session.dateTimeEnd,
  );
  final topic = session.topic?.trim();
  if (topic == null || topic.isEmpty) {
    return '$date • $timeRange';
  }
  return '$topic • $date • $timeRange';
}

String _formatTimeRange(DateTime start, DateTime? end) {
  final startText = DateFormat('h:mm a').format(start.toLocal());
  if (end == null) return startText;
  final endText = DateFormat('h:mm a').format(end.toLocal());
  return '$startText - $endText';
}
