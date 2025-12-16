import 'package:equatable/equatable.dart' show EquatableMixin;
import 'package:flutter/foundation.dart' show immutable;
import 'package:form_fields/src/formz_validation_mixin.dart';
import 'package:formz/formz.dart' show FormzInput;

/// {@template full_name}
/// Form input for a full name. It extends [FormzInput] and uses
/// [FirstNameValidationError] for its validation errors.
/// {@endtemplate}
@immutable
class FirstName extends FormzInput<String, FirstNameValidationError>
    with EquatableMixin, FormzValidationMixin {
  /// {@macro full_name.pure}
  const FirstName.pure([super.value = '']) : super.pure();

  /// {@macro full_name.dirty}
  const FirstName.dirty(super.value) : super.dirty();

  static final _nameRegex = RegExp(r'^([a-zA-Z])+$');

  @override
  FirstNameValidationError? validator(String value) {
    if (value.isEmpty) return FirstNameValidationError.empty;
    if (!_nameRegex.hasMatch(value)) return FirstNameValidationError.invalid;
    return null;
  }

  @override
  Map<FirstNameValidationError?, String?> get validationErrorMessage => {
        FirstNameValidationError.empty: 'This field is required',
        FirstNameValidationError.invalid: 'First name is not a valid name',
        null: null,
      };

  @override
  List<Object?> get props => [value, pure];
}

/// Validation errors for [FirstName]. It can be empty or invalid.
enum FirstNameValidationError {
  /// Empty full name.
  empty,

  /// Invalid full name.
  invalid,
}
