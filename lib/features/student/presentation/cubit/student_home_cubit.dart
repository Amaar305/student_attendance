import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/student/student.dart';

part 'student_home_state.dart';

class StudentHomeCubit extends Cubit<StudentHomeState> {
  StudentHomeCubit({
    required AppUser user,
    required WatchMyAttendanceForSessionsUseCase
    watchMyAttendanceForSessionsUseCase,
    required WatchStudentCourseOptionsUseCase watchStudentCourseOptionsUseCase,
    required WatchTodaySessionsForStudentUseCase
    watchTodaySessionsForStudentUseCase,
  }) : _user = user,
       _watchMyAttendanceForSessionsUseCase =
           watchMyAttendanceForSessionsUseCase,
       _watchStudentCourseOptionsUseCase = watchStudentCourseOptionsUseCase,
       _watchTodaySessionsForStudentUseCase =
           watchTodaySessionsForStudentUseCase,
       super(StudentHomeState.initial());

  final AppUser _user;
  final WatchMyAttendanceForSessionsUseCase
  _watchMyAttendanceForSessionsUseCase;
  final WatchStudentCourseOptionsUseCase _watchStudentCourseOptionsUseCase;
  final WatchTodaySessionsForStudentUseCase
  _watchTodaySessionsForStudentUseCase;

  StreamSubscription<Either<Failure, List<EnrollmentCourseOption>>>?
  _coursesSub;
  StreamSubscription<Either<Failure, List<Session>>>? _todaySessionsSub;
  StreamSubscription<Either<Failure, Map<String, AttendanceStatus>>>?
  _attendanceSub;

  List<EnrollmentCourseOption> _courseOptions = const [];
  List<Session> _todaySessions = const [];
  Map<String, AttendanceStatus> _attMap = const {};

  void init() {
    emit(
      state.copyWith(
        studentName: _user.name ?? state.studentName,
        clearError: true,
      ),
    );

    _subscribeCourses();
    _subscribeTodaySessions();
  }

  void _subscribeCourses() {
    final res = _watchStudentCourseOptionsUseCase(
      WatchStudentCourseOptionsParams(studentId: _user.id),
    );

    _coursesSub = res.listen((event) {
      if (isClosed) return;

      event.fold(
        (failure) =>
            emit(state.copyWith(loading: false, errorMessage: failure.message)),
        (courses) {
          _courseOptions = courses;
          _rebuildItems();
        },
      );
    });
  }

  void _subscribeTodaySessions() {
    final now = DateTime.now();
    final dayStart = DateTime(now.year, now.month, now.day, 0, 0);
    final dayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final res = _watchTodaySessionsForStudentUseCase(
      WatchTodaySessionsForStudentParams(
        studentId: _user.id,
        dayStart: dayStart,
        dayEnd: dayEnd,
      ),
    );

    _todaySessionsSub = res.listen((event) {
      if (isClosed) return;

      event.fold(
        (failure) =>
            emit(state.copyWith(loading: false, errorMessage: failure.message)),
        (sessions) {
          _todaySessions = sessions;
          _rebuildItems();
          _resubscribeAttendance();
        },
      );
    });
  }

  void _resubscribeAttendance() {
    unawaited(_attendanceSub?.cancel());

    final sessionIds = _todaySessions.map((s) => s.id).toList();
    if (sessionIds.isEmpty) {
      _attMap = const {};
      _rebuildItems();
      return;
    }

    final res = _watchMyAttendanceForSessionsUseCase(
      WatchMyAttendanceForSessionsParams(
        studentId: _user.id,
        sessionIds: sessionIds,
      ),
    );

    _attendanceSub = res.listen((event) {
      if (isClosed) return;

      event.fold(
        (failure) =>
            emit(state.copyWith(loading: false, errorMessage: failure.message)),
        (attendance) {
          _attMap = attendance;
          _rebuildItems();
        },
      );
    });
  }

  void _rebuildItems() {
    if (isClosed) return;

    final now = DateTime.now();

    String titleForCourse(String courseId) {
      final opt = _courseOptions.where((e) => e.courseId == courseId).toList();
      if (opt.isNotEmpty) return opt.first.courseTitle;
      return 'Course';
    }

    ClassStatus statusFor(Session s) {
      final att = _attMap[s.id];
      if (att != null) {
        return att == AttendanceStatus.late
            ? ClassStatus.late
            : ClassStatus.present;
      }
      if (now.isBefore(s.dateTimeStart)) return ClassStatus.upcoming;
      if (s.isOpen) return ClassStatus.ongoing;
      return ClassStatus.ongoing;
    }

    final items = _todaySessions.map((s) {
      return TodayClassItem(
        sessionId: s.id,
        courseId: s.courseId,
        title: titleForCourse(s.courseId),
        startAt: s.dateTimeStart,
        endAt: s.dateTimeEnd,
        isOpen: s.isOpen,
        status: statusFor(s),
      );
    }).toList();

    emit(state.copyWith(loading: false, todayItems: items, clearError: true));
  }

  @override
  Future<void> close() async {
    await _coursesSub?.cancel();
    await _todaySessionsSub?.cancel();
    await _attendanceSub?.cancel();
    return super.close();
  }
}
