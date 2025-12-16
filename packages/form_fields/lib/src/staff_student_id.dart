// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart' show EquatableMixin;
import 'package:formz/formz.dart';


class StaffStudentId extends FormzInput<String, StaffStudentIdValidationError>
    with EquatableMixin {
  const StaffStudentId.pure([super.value = '']) : super.pure();

  const StaffStudentId.dirty(super.value) : super.dirty();

  @override
  StaffStudentIdValidationError? validator(String value) {
    if (value.trim().isEmpty) return StaffStudentIdValidationError.empty;
    return null;
  }

  String? get errorMessage => validationErrorMessage[invalid ? error : null];

  Map<StaffStudentIdValidationError?, String?> get validationErrorMessage => {
        StaffStudentIdValidationError.empty: 'Student/Staff ID is required',
        null: null,
      };

  @override
  List<Object?> get props => [value, pure];
}

enum StaffStudentIdValidationError { empty }
