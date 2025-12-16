import 'package:equatable/equatable.dart' show EquatableMixin;
import 'package:flutter/foundation.dart' show immutable;
import 'package:form_fields/src/formz_validation_mixin.dart';
import 'package:formz/formz.dart' show FormzInput;

/// {@template full_name}
/// Form input for a full name. It extends [FormzInput] and uses
/// [LastNameValidationError] for its validation errors.
/// {@endtemplate}
@immutable
class LastName extends FormzInput<String, LastNameValidationError>
    with EquatableMixin, FormzValidationMixin {
  /// {@macro full_name.pure}
  const LastName.pure([super.value = '']) : super.pure();

  /// {@macro full_name.dirty}
  const LastName.dirty(super.value) : super.dirty();
  static final _namePartRegex = RegExp(r'^[A-Za-z]+$');

  @override
  LastNameValidationError? validator(String value) {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) return LastNameValidationError.empty;

    final parts = trimmedValue.split(RegExp(r'\s+'));
    if (parts.length > 2) return LastNameValidationError.invalid;
    if (!parts.every(_namePartRegex.hasMatch)) {
      return LastNameValidationError.invalid;
    }
    return null;
  }

  @override
  Map<LastNameValidationError?, String?> get validationErrorMessage => {
        LastNameValidationError.empty: 'This field is required',
        LastNameValidationError.invalid: 'Last name is not a valid name',
        null: null,
      };

  @override
  List<Object?> get props => [value, pure];
}

/// Validation errors for [LastName]. It can be empty or invalid.
enum LastNameValidationError {
  /// Empty full name.
  empty,

  /// Invalid full name.
  invalid,
}
