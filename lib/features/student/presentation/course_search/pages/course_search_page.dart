import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_attendance/app/app.dart';
import 'package:student_attendance/features/student/student.dart';

class CourseSearchPage extends StatelessWidget {
  const CourseSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseSearchCubit(
        user: context.read<AppCubit>().state.user!,
        watchCoursesUseCase: getIt(),
        watchStudentCourseOptionsUseCase: getIt(),
        enrollInCourseUseCase: getIt(),
      )..init(),
      child: CourseSearchView(),
    );
  }
}

class CourseSearchView extends StatelessWidget {
  const CourseSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('Find Courses'), centerTitle: true),
      body: BlocConsumer<CourseSearchCubit, CourseSearchState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status.isError && state.errorMessage != null) {
            openSnackbar(SnackbarMessage.error(title: state.errorMessage!));
          }
          if (state.status.isSuccess) {
            openSnackbar(
              SnackbarMessage.success(title: 'Enrolled successfully.'),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<CourseSearchCubit>();
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                TextField(
                  onChanged: cubit.onQueryChanged,
                  decoration: InputDecoration(
                    hintText: 'Search by course code or name',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                Gap.v(AppSpacing.md),

                if (state.status.isLoading && state.courses.isEmpty)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.courses.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No courses found.',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.courses.length,
                      itemBuilder: (context, i) {
                        final c = state.courses[i];
                        final enrolled = state.enrolledCourseIds.contains(c.id);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${c.studentCount} students',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                height: 42,
                                child: enrolled
                                    ? OutlinedButton(
                                        onPressed: null,
                                        child: const Text('Enrolled'),
                                      )
                                    : FilledButton(
                                        onPressed:
                                            state.status ==
                                                CourseSearchStatus.enrolling
                                            ? null
                                            : () => cubit.enroll(c),
                                        child: const Text('Enroll'),
                                      ),
                              ),
                            ],
                          ),
                        );
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
}
