import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';

part 'lecturer_home_event.dart';
part 'lecturer_home_state.dart';

class LecturerHomeBloc extends Bloc<LecturerHomeEvent, LecturerHomeState> {
  LecturerHomeBloc({
    required AppUser user,
    required WatchLecturerCoursesUseCase watchLecturerCoursesUseCase,
  }) : _user = user,
       _watchLecturerCoursesUseCase = watchLecturerCoursesUseCase,
       super(LecturerHomeState.initial()) {
    on<LecturerCoursesSubscriptionRequested>(
      _onLecturerCoursesSubscriptionRequested,
      // transformer: throttleDroppable(),
    );
  }

  final AppUser _user;
  final WatchLecturerCoursesUseCase _watchLecturerCoursesUseCase;

  Future<void> _onLecturerCoursesSubscriptionRequested(
    LecturerCoursesSubscriptionRequested event,
    Emitter<LecturerHomeState> emit,
  ) async {
    final res = _watchLecturerCoursesUseCase(
      WatchLecturerCoursesParams(lecturerId: _user.id),
    );
    await emit.forEach<Either<Failure, List<Course>>>(
      res,
      onData: (result) => result.fold(
        (failure) => state.copyWith(
          status: LecturerHomeStatus.error,
          message: failure.message,
        ),
        (courses) => state.copyWith(
          status: LecturerHomeStatus.populated,
          courses: courses,
          message: '',
        ),
      ),
    );
  }
}
