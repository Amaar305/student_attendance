import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';

part 'add_course_state.dart';

class AddCourseCubit extends Cubit<AddCourseState> {
  final AppUser _user;
  final AddCourseUseCase _addCourseUseCase;
  AddCourseCubit({
    required AppUser user,
    required AddCourseUseCase addCourseUseCase,
  }) : _user = user,
       _addCourseUseCase = addCourseUseCase,

       super(const AddCourseState.initial());

  void onCodeChanged(String value) {
    if (value == state.code) return;
    emit(
      state.copyWith(
        code: value,
        status: AddCourseStatus.initial,
        clearError: true,
      ),
    );
  }

  void onNameChanged(String value) {
    if (value == state.name) return;
    emit(
      state.copyWith(
        name: value,
        status: AddCourseStatus.initial,
        clearError: true,
      ),
    );
  }

  void onLevelChanged(String value) {
    if (value == state.level) return;
    emit(
      state.copyWith(
        level: value,
        status: AddCourseStatus.initial,
        clearError: true,
      ),
    );
  }

  Future<void> submit({void Function()? onSuccess}) async {
    if (!state.canSubmit) {
      emit(
        state.copyWith(
          status: AddCourseStatus.failure,
          errorMessage: 'Fill in course code, name, and level.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: AddCourseStatus.loading,
        clearError: true,
      ),
    );

    final res = await _addCourseUseCase(
      AddCourseParams(
        lecturerId: _user.id,
        code: state.code.trim(),
        name: state.name.trim(),
        level: state.level.trim(),
      ),
    );

    if (isClosed) return;

    res.fold(
      (failure) => emit(
        state.copyWith(
          status: AddCourseStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        emit(
          state.copyWith(
            status: AddCourseStatus.success,
            clearError: true,
          ),
        );
        onSuccess?.call();
      },
    );
  }
}
