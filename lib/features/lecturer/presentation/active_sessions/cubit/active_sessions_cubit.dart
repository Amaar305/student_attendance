import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';
import 'package:student_attendance/features/session/session.dart';

part 'active_sessions_state.dart';

class ActiveSessionsCubit extends Cubit<ActiveSessionsState> {
  ActiveSessionsCubit({
    required AppUser user,
    required WatchLecturerCoursesUseCase watchLecturerCoursesUseCase,
    required WatchCourseSessionsUseCase watchCourseSessionsUseCase,
    required CloseSessionUseCase closeSessionUseCase,
  }) : _user = user,
       _watchLecturerCoursesUseCase = watchLecturerCoursesUseCase,
       _watchCourseSessionsUseCase = watchCourseSessionsUseCase,
       _closeSessionUseCase = closeSessionUseCase,
       super(const ActiveSessionsState.initial());

  final AppUser _user;
  final WatchLecturerCoursesUseCase _watchLecturerCoursesUseCase;
  final WatchCourseSessionsUseCase _watchCourseSessionsUseCase;
  final CloseSessionUseCase _closeSessionUseCase;

  StreamSubscription<Either<Failure, List<Course>>>? _coursesSub;
  final Map<String, StreamSubscription<Either<Failure, List<Session>>>>
  _sessionsSub = {};
  final Map<String, List<Session>> _sessionsByCourse = {};
  List<Course> _courses = const [];

  void init() {
    emit(state.copyWith(status: ActiveSessionsStatus.loading, clearError: true));
    _subscribeCourses();
  }

  void _subscribeCourses() {
    final res = _watchLecturerCoursesUseCase(
      WatchLecturerCoursesParams(lecturerId: _user.id),
    );

    _coursesSub = res.listen((event) {
      if (isClosed) return;
      event.fold(
        (failure) => emit(
          state.copyWith(
            status: ActiveSessionsStatus.failure,
            errorMessage: failure.message,
          ),
        ),
        (courses) {
          _courses = courses;
          _syncCourseSubscriptions(courses);
          _rebuild();
        },
      );
    });
  }

  void _syncCourseSubscriptions(List<Course> courses) {
    final courseIds = courses.map((course) => course.id).toSet();

    for (final entry in _sessionsSub.entries.toList()) {
      if (courseIds.contains(entry.key)) continue;
      unawaited(entry.value.cancel());
      _sessionsSub.remove(entry.key);
      _sessionsByCourse.remove(entry.key);
    }

    for (final course in courses) {
      if (_sessionsSub.containsKey(course.id)) continue;

      final res = _watchCourseSessionsUseCase(
        WatchCourseSessionsParams(courseId: course.id),
      );

      _sessionsSub[course.id] = res.listen((event) {
        if (isClosed) return;

        event.fold(
          (failure) => emit(
            state.copyWith(
              status: ActiveSessionsStatus.failure,
              errorMessage: failure.message,
            ),
          ),
          (sessions) {
            _sessionsByCourse[course.id] = sessions;
            _rebuild();
          },
        );
      });
    }
  }

  void _rebuild() {
    if (isClosed) return;

    final sessions = _sessionsByCourse.values
        .expand((items) => items)
        .where((session) => session.isOpen)
        .toList()
      ..sort((a, b) => b.dateTimeStart.compareTo(a.dateTimeStart));

    emit(
      state.copyWith(
        status: ActiveSessionsStatus.success,
        sessions: sessions,
        courses: _courses,
        clearError: true,
      ),
    );
  }

  Future<void> cancelSession(Session session) async {
    if (state.closingSessionIds.contains(session.id)) return;

    emit(
      state.copyWith(
        closingSessionIds: {...state.closingSessionIds, session.id},
        clearError: true,
      ),
    );

    final res = await _closeSessionUseCase(
      CloseSessionParams(sessionId: session.id),
    );

    if (isClosed) return;

    res.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ActiveSessionsStatus.failure,
            errorMessage: failure.message,
            closingSessionIds: {...state.closingSessionIds}..remove(session.id),
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            closingSessionIds: {...state.closingSessionIds}..remove(session.id),
            clearError: true,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    unawaited(_coursesSub?.cancel());
    for (final sub in _sessionsSub.values) {
      unawaited(sub.cancel());
    }
    return super.close();
  }
}
