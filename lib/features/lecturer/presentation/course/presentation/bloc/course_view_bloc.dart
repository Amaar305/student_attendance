import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';

part 'course_view_event.dart';
part 'course_view_state.dart';

class CourseViewBloc extends Bloc<CourseViewEvent, CourseViewState> {
  CourseViewBloc({
    required Course course,
    required WatchCourseSessionsUseCase watchCourseSessionsUseCase,
    required WatchSessionAttendanceCountUseCase
    watchSessionAttendanceCountUseCase,
    required GetCourseStudentCountUseCase getCourseStudentCountUseCase,
    required WatchCourseStudentCountUseCase watchCourseStudentCountUseCase,
  }) : _course = course,
       _watchCourseSessionsUseCase = watchCourseSessionsUseCase,
       _getCourseStudentCountUseCase = getCourseStudentCountUseCase,
       _watchSessionAttendanceCountUseCase = watchSessionAttendanceCountUseCase,
       _watchCourseStudentCountUseCase = watchCourseStudentCountUseCase,
       super(
         CourseViewState.initial().copyWith(
           totalStudents: course.studentCount,
         ),
       ) {
    on<CourseViewToggleNewest>(_onCourseViewToggleNewest);
    on<CourseSessionsSubscriptionRequested>(
      _onCourseSessionsSubscriptionRequested,
    );
  }

  final Course _course;
  final WatchCourseSessionsUseCase _watchCourseSessionsUseCase;
  // ignore: unused_field
  final WatchSessionAttendanceCountUseCase _watchSessionAttendanceCountUseCase;
  final GetCourseStudentCountUseCase _getCourseStudentCountUseCase;
  final WatchCourseStudentCountUseCase _watchCourseStudentCountUseCase;

  void _onCourseViewToggleNewest(
    CourseViewToggleNewest event,
    Emitter<CourseViewState> emit,
  ) {
    if (event.selectedIndex == state.selectedIndex) return;

    emit(state.copyWith(selectedIndex: event.selectedIndex));
  }

  FutureOr<void> _onCourseSessionsSubscriptionRequested(
    CourseSessionsSubscriptionRequested event,
    Emitter<CourseViewState> emit,
  ) async {
    emit(state.copyWith(status: CourseViewStatus.loading));
    final studentCountResult = await _getCourseStudentCountUseCase(
      GetCourseStudentCountParams(courseId: _course.id),
    );

    studentCountResult.fold(
      (failure) => emit(
        state.copyWith(
          status: CourseViewStatus.failure,
          message: failure.message,
        ),
      ),
      (count) => emit(_updateAggregates(totalStudents: count)),
    );

    _watchCourseStudentCount(emit);

    final res = _watchCourseSessionsUseCase(
      WatchCourseSessionsParams(courseId: _course.id),
    );
    await emit.forEach<Either<Failure, List<Session>>>(
      res,
      onData: (result) => result.fold(
        (failure) => state.copyWith(
          status: CourseViewStatus.failure,
          message: failure.message,
        ),
        (sessions) => _updateAggregates(
          sessions: sessions,
          status: CourseViewStatus.success,
          message: '',
        ),
      ),
    );
  }

  CourseViewState _updateAggregates({
    List<Session>? sessions,
    int? totalStudents,
    CourseViewStatus? status,
    String? message,
  }) {
    final updatedSessions = sessions ?? state.sessions;
    final updatedTotalStudents = totalStudents ?? state.totalStudents;
    final totalSessions = updatedSessions.length;

    final totalAttendance = updatedSessions.fold<int>(
      0,
      (sum, session) => sum + session.attendanceCount,
    );
    final totalPossible = updatedTotalStudents * totalSessions;
    final overallAttendancePercent = totalPossible == 0
        ? 0.0
        : (totalAttendance / totalPossible) * 100;

    return state.copyWith(
      status: status ?? state.status,
      message: message ?? state.message,
      sessions: updatedSessions,
      totalStudents: updatedTotalStudents,
      totalSessions: totalSessions,
      overallAttendancePercent: overallAttendancePercent,
    );
  }

  void _watchCourseStudentCount(Emitter<CourseViewState> emit) {
    final stream = _watchCourseStudentCountUseCase(
      WatchCourseStudentCountParams(courseId: _course.id),
    );
    unawaited(
      emit.forEach<Either<Failure, int>>(
        stream,
        onData: (result) => result.fold(
          (failure) => state.copyWith(
            status: CourseViewStatus.failure,
            message: failure.message,
          ),
          (count) => _updateAggregates(
            totalStudents: count,
            message: '',
          ),
        ),
      ),
    );
  }
}
