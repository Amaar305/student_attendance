import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_attendance/app/app.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';

class MyStudentsPage extends StatelessWidget {
  const MyStudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyStudentsCubit(
        user: context.read<AppCubit>().state.user!,
        watchLecturerCoursesUseCase: getIt(),
        watchLecturerStudentsUseCase: getIt(),
      )..init(),
      child: const MyStudentsView(),
    );
  }
}

class MyStudentsView extends StatelessWidget {
  const MyStudentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('My Students'),
        centerTitle: true,
      ),
      body: BlocConsumer<MyStudentsCubit, MyStudentsState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          final message = state.errorMessage;
          if (message != null) {
            openSnackbar(SnackbarMessage.error(title: message));
          }
        },
        builder: (context, state) {
          final cubit = context.read<MyStudentsCubit>();
          final filtered = _filteredStudents(
            state.students,
            state.selectedCourseId,
            state.query,
          );

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                MyStudentsFilters(
                  courses: state.courses,
                  selectedCourseId: state.selectedCourseId,
                  onCourseChanged: cubit.setCourseFilter,
                  onQueryChanged: cubit.onQueryChanged,
                ),
                Gap.v(AppSpacing.md),
                if (state.loading && state.students.isEmpty)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (filtered.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No students found.',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (context, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final student = filtered[index];
                        return MyStudentTile(item: student);
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<CourseStudent> _filteredStudents(
    List<CourseStudent> students,
    String? selectedCourseId,
    String query,
  ) {
    final trimmed = query.trim().toLowerCase();
    return students.where((item) {
      if (selectedCourseId != null && item.courseId != selectedCourseId) {
        return false;
      }
      if (trimmed.isEmpty) return true;

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
