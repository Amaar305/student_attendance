import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';

part 'my_students_state.dart';

class MyStudentsCubit extends Cubit<MyStudentsState> {
  final AppUser _user;
  final WatchLecturerCoursesUseCase _watchLecturerCoursesUseCase;
  final WatchLecturerStudentsUseCase _watchLecturerStudentsUseCase;

  MyStudentsCubit({
    required AppUser user,
    required WatchLecturerCoursesUseCase watchLecturerCoursesUseCase,
    required WatchLecturerStudentsUseCase watchLecturerStudentsUseCase,
  }) : _user = user,
       _watchLecturerCoursesUseCase = watchLecturerCoursesUseCase,
       _watchLecturerStudentsUseCase = watchLecturerStudentsUseCase,
       super(MyStudentsState.initial());

  StreamSubscription<Either<Failure, List<Course>>>? _coursesSub;
  StreamSubscription<Either<Failure, List<CourseStudent>>>? _studentsSub;
  late final Debouncer _debouncer;

  void init() {
    _debouncer = Debouncer(milliseconds: 200);
    _subscribeCourses();
    _subscribeStudents();
  }

  void onQueryChanged(String query) {
    if (isClosed) return;
    _debouncer.run(() {
      if (isClosed) return;
      emit(state.copyWith(query: query, clearError: true));
    });
  }

  void setCourseFilter(String? courseId) {
    emit(state.copyWith(selectedCourseId: courseId, clearError: true));
  }

  void _subscribeCourses() {
    _coursesSub?.cancel();
    final res = _watchLecturerCoursesUseCase(
      WatchLecturerCoursesParams(lecturerId: _user.id),
    );

    _coursesSub = res.listen((event) {
      if (isClosed) return;
      event.fold(
        (failure) => emit(
          state.copyWith(loading: false, errorMessage: failure.message),
        ),
        (courses) {
          final selected = state.selectedCourseId;
          final validSelected =
              selected != null && courses.any((c) => c.id == selected)
                  ? selected
                  : null;
          emit(
            state.copyWith(
              courses: courses,
              selectedCourseId: validSelected,
              loading: false,
              clearError: true,
            ),
          );
        },
      );
    });
  }

  void _subscribeStudents() {
    _studentsSub?.cancel();
    final res = _watchLecturerStudentsUseCase(
      WatchLecturerStudentsParams(lecturerId: _user.id),
    );

    _studentsSub = res.listen((event) {
      if (isClosed) return;
      event.fold(
        (failure) => emit(
          state.copyWith(loading: false, errorMessage: failure.message),
        ),
        (students) => emit(
          state.copyWith(
            students: students,
            loading: false,
            clearError: true,
          ),
        ),
      );
    });
  }

  @override
  Future<void> close() async {
    _debouncer.dispose();
    await _coursesSub?.cancel();
    await _studentsSub?.cancel();
    return super.close();
  }
}
