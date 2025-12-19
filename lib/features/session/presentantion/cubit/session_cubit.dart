import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/session/session.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final BuildSessionQrPayloadUseCase _buildSessionQrPayloadUseCase;
  final CloseSessionUseCase _closeSessionUseCase;
  final CreateOrGetOpenSessionUseCase _createOrGetOpenSessionUseCase;
  final FetchLecturerCoursesUseCase _fetchLecturerCoursesUseCase;
  final AppUser _user;

  SessionCubit({
    required AppUser user,
    required BuildSessionQrPayloadUseCase buildSessionQrPayloadUseCase,
    required CloseSessionUseCase closeSessionUseCase,
    required CreateOrGetOpenSessionUseCase createOrGetOpenSessionUseCase,
    required FetchLecturerCoursesUseCase fetchLecturerCoursesUseCase,
  }) : _user = user,
       _buildSessionQrPayloadUseCase = buildSessionQrPayloadUseCase,
       _closeSessionUseCase = closeSessionUseCase,
       _createOrGetOpenSessionUseCase = createOrGetOpenSessionUseCase,
       _fetchLecturerCoursesUseCase = fetchLecturerCoursesUseCase,
       super(SessionState.initial());

  Future<void> fetchLecturerCourses() async {
    emit(state.copyWith(status: SessionStatus.loading, message: ''));

    final res = await _fetchLecturerCoursesUseCase(
      FetchLecturerCoursesParams(lecturerId: _user.id),
    );

    if (isClosed) return;

    res.fold(
      (failure) => emit(
        state.copyWith(status: SessionStatus.failure, message: failure.message),
      ),
      (courses) => emit(
        state.copyWith(
          status: SessionStatus.success,
          message: '',
          courses: courses,
          selectedCourse: courses.isNotEmpty ? courses.first : null,
        ),
      ),
    );
  }

  void onCourseSelected(Course? course) {
    if (course == null || course == state.selectedCourse) return;

    emit(state.copyWith(selectedCourse: course, message: ''));
  }

  void onTopicChanged(String value) {
    emit(state.copyWith(topic: value, message: ''));
  }

  void onDateSelected(DateTime date) {
    emit(state.copyWith(startDate: date, message: ''));
  }

  void onStartTimeSelected(TimeOfDay time) {
    emit(state.copyWith(startTime: time, message: ''));
  }

  void onLateAfterMinutesChanged(String value) {
    final minutes = int.tryParse(value);
    if (minutes == null) return;

    emit(state.copyWith(lateAfterMinutes: minutes, message: ''));
  }

  Future<void> createSession({
    void Function(Session session, String qrPayload)? onSuccess,
  }) async {
    final startAt = state.startAt;
    final course = state.selectedCourse;

    if (course == null || startAt == null) {
      emit(
        state.copyWith(
          status: SessionStatus.failure,
          message: 'Select a course, date, and start time.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: SessionStatus.loading,
        message: '',
        session: state.session,
        qrPayload: state.qrPayload,
      ),
    );

    final res = await _createOrGetOpenSessionUseCase(
      CreateOrGetOpenSessionParams(
        courseId: course.id,
        lecturerId: _user.id,
        startAt: startAt,
        topic: state.topic.isEmpty ? null : state.topic,
        lateAfterMinutes: state.lateAfterMinutes,
      ),
    );

    if (isClosed) return;

    await res.fold(
      (failure) async => emit(
        state.copyWith(status: SessionStatus.failure, message: failure.message),
      ),
      (session) async {
        final payloadResult = await _buildSessionQrPayloadUseCase(
          BuildSessionQrPayloadParams(
            sessionId: session.id,
            qrToken: session.qrToken,
          ),
        );

        if (isClosed) return;

        payloadResult.fold(
          (failure) => emit(
            state.copyWith(
              status: SessionStatus.failure,
              message: failure.message,
            ),
          ),
          (qrPayload) {
            emit(
              state.copyWith(
                status: SessionStatus.success,
                message: '',
                session: session,
                qrPayload: qrPayload,
              ),
            );
            onSuccess?.call(session, qrPayload);
          },
        );
      },
    );
  }
}
