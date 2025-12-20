import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/student/student.dart';

part 'attendance_history_state.dart';

class AttendanceHistoryCubit extends Cubit<AttendanceHistoryState> {
  final AppUser _user;
  final WatchStudentCourseOptionsUseCase _watchStudentCourseOptionsUseCase;
  final WatchAttendanceHistoryUseCase _watchAttendanceHistoryUseCase;

  AttendanceHistoryCubit({
    required AppUser user,
    required WatchStudentCourseOptionsUseCase watchStudentCourseOptionsUseCase,
    required WatchAttendanceHistoryUseCase watchAttendanceHistoryUseCase,
  }) : _user = user,
       _watchStudentCourseOptionsUseCase = watchStudentCourseOptionsUseCase,
       _watchAttendanceHistoryUseCase = watchAttendanceHistoryUseCase,
       super(AttendanceHistoryState.initial());

  StreamSubscription<Either<Failure, List<EnrollmentCourseOption>>>?
  _coursesSub;
  StreamSubscription<Either<Failure, List<StudentAttendanceItem>>>? _historySub;

  void init() async {
    // Load dropdown options
    final res = _watchStudentCourseOptionsUseCase(
      WatchStudentCourseOptionsParams(studentId: _user.id),
    );

    _coursesSub = res.listen(
      (event) => event.fold(
        (failure) =>
            emit(state.copyWith(loading: false, errorMessage: failure.message)),
        (courses) {
          emit(
            state.copyWith(
              courseOptions: courses,
              loading: false,
              clearError: true,
            ),
          );
        },
      ),
    );

    // Start history stream
    _resubscribeHistory();
  }

  void setCourseFilter(String? courseId) {
    emit(state.copyWith(selectedCourseId: courseId, clearError: true));
    _resubscribeHistory();
  }

  void setRange(HistoryRange range) {
    emit(state.copyWith(selectedRange: range, clearError: true));
    _resubscribeHistory();
  }

  void _resubscribeHistory() {
    unawaited(_historySub?.cancel());

    final now = DateTime.now();
    final (from, to) = _computeRange(now, state.selectedRange);

    final res = _watchAttendanceHistoryUseCase(
      WatchAttendanceHistoryParams(
        studentId: _user.id,
        from: from,
        to: to,
        courseId: state.selectedCourseId,
      ),
    );

    _historySub = res.listen((event) {
      if (isClosed) return;

      return event.fold(
        (failure) =>
            emit(state.copyWith(loading: false, errorMessage: failure.message)),
        (items) => emit(
          state.copyWith(items: items, loading: false, clearError: true),
        ),
      );
    });
  }

  (DateTime from, DateTime to) _computeRange(DateTime now, HistoryRange range) {
    switch (range) {
      case HistoryRange.last7Days:
        return (now.subtract(const Duration(days: 7)), now);
      case HistoryRange.last30Days:
        return (now.subtract(const Duration(days: 30)), now);
      case HistoryRange.last90Days:
        return (now.subtract(const Duration(days: 90)), now);
      case HistoryRange.allTime:
        // Firestore cannot query with a truly infinite past; pick a safe early date.
        return (DateTime(2000, 1, 1), now);
    }
  }

  @override
  Future<void> close() async {
    unawaited(_coursesSub?.cancel());
    unawaited(_historySub?.cancel());
    return super.close();
  }
}
