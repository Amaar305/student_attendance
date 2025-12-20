import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_attendance/app/app.dart';
import 'package:student_attendance/features/student/student.dart';

class AttendanceHistoryPage extends StatelessWidget {
  const AttendanceHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AttendanceHistoryCubit(
        user: context.read<AppCubit>().state.user!,
        watchStudentCourseOptionsUseCase: getIt(),
        watchAttendanceHistoryUseCase: getIt(),
      )..init(),
      child: AttendanceHistoryView(),
    );
  }
}

class AttendanceHistoryView extends StatelessWidget {
  const AttendanceHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
        centerTitle: true,
      ),
      body: BlocConsumer<AttendanceHistoryCubit, AttendanceHistoryState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.errorMessage != null) {
            openSnackbar(SnackbarMessage.error(title: state.errorMessage!));
          }
        },
        builder: (context, state) {
          if (state.loading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final groups = groupByMonth(state.items);

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                FiltersRow(state: state),
                if (state.errorMessage != null) ...[
                  const Gap.v(10),
                  AttendanceErrorBanner(message: state.errorMessage!),
                ],
                const Gap.v(12),
                Expanded(
                  child: groups.isEmpty
                      ? EmptyHistory(
                          onClearFilters: () {
                            final cubit = context
                                .read<AttendanceHistoryCubit>();
                            cubit.setCourseFilter(null);
                            cubit.setRange(HistoryRange.last30Days);
                          },
                        )
                      : ListView.builder(
                          itemCount: groups.length,
                          itemBuilder: (context, i) {
                            final g = groups[i];
                            return MonthSection(group: g);
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
