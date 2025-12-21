import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/student/student.dart';

part 'course_search_state.dart';

class CourseSearchCubit extends Cubit<CourseSearchState> {
  CourseSearchCubit({
    required AppUser user,
    required WatchStudentCourseOptionsUseCase watchStudentCourseOptionsUseCase,
    required WatchCoursesUseCase watchCoursesUseCase,
    required EnrollInCourseUseCase enrollInCourseUseCase,
  }) : _user = user,
       _watchCoursesUseCase = watchCoursesUseCase,
       _watchStudentCourseOptionsUseCase = watchStudentCourseOptionsUseCase,
       _enrollInCourseUseCase = enrollInCourseUseCase,
       super(CourseSearchState.initial());
  final AppUser _user;
  final WatchStudentCourseOptionsUseCase _watchStudentCourseOptionsUseCase;
  final WatchCoursesUseCase _watchCoursesUseCase;
  final EnrollInCourseUseCase _enrollInCourseUseCase;

  StreamSubscription<Either<Failure, List<CourseSearchItem>>>? _coursesSub;
  late final Debouncer _debounce;

  void init() {
    _debounce = Debouncer(milliseconds: 300);
    _subscribeCourses();
    _loadEnrolledIds();
  }

  void onQueryChanged(String v) {
    if (isClosed) return;
    emit(state.copyWith(query: v, clearError: true));
    _debounce.run(_subscribeCourses);
  }

  void _subscribeCourses() {
    _coursesSub?.cancel();
    emit(state.copyWith(status: CourseSearchStatus.loading, clearError: true));

    final res = _watchCoursesUseCase(WatchCoursesParams(search: state.query));

    _coursesSub = res.listen((event) {
      if (isClosed) return;

      event.fold(
        (failure) => emit(
          state.copyWith(
            errorMessage: failure.message,
            status: CourseSearchStatus.failure,
          ),
        ),
        (courses) => emit(
          state.copyWith(
            status: CourseSearchStatus.ready,
            courses: courses,
            clearError: true,
          ),
        ),
      );
    });
  }

  void _loadEnrolledIds() {
    final res = _watchStudentCourseOptionsUseCase(
      WatchStudentCourseOptionsParams(studentId: _user.id),
    );

    res.listen((event) {
      if (isClosed) return;

      event.fold(
        (failure) => emit(
          state.copyWith(
            errorMessage: failure.message,
            status: CourseSearchStatus.failure,
          ),
        ),
        (courses) => emit(
          state.copyWith(
            enrolledCourseIds: courses.map((e) => e.courseId).toSet(),
          ),
        ),
      );
    });
  }

  Future<void> enroll(CourseSearchItem course) async {
    if (state.enrolledCourseIds.contains(course.id)) return;
    if (isClosed) return;

    emit(
      state.copyWith(status: CourseSearchStatus.enrolling, clearError: true),
    );

    final res = await _enrollInCourseUseCase(
      EnrollInCourseParams(studentId: _user.id, course: course),
    );

    if (isClosed) return;

    res.fold(
      (failure) => emit(
        state.copyWith(
          status: CourseSearchStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        final updated = Set<String>.from(state.enrolledCourseIds)
          ..add(course.id);
        emit(
          state.copyWith(
            status: CourseSearchStatus.success,
            enrolledCourseIds: updated,
            clearError: true,
          ),
        );

        // return to ready state
        emit(state.copyWith(status: CourseSearchStatus.ready));
      },
    );
  }

  @override
  Future<void> close() async {
    _debounce.dispose();
    await _coursesSub?.cancel();
    return super.close();
  }
}
