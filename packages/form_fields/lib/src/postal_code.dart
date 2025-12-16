import 'package:equatable/equatable.dart' show EquatableMixin;
import 'package:flutter/foundation.dart' show immutable;
import 'package:form_fields/src/formz_validation_mixin.dart';
import 'package:formz/formz.dart' show FormzInput;

/// {@template full_name}
/// Form input for a postal code. It extends [FormzInput] and uses
/// [PostalCodeValidationError] for its validation errors.
/// {@endtemplate}
@immutable
class PostalCode extends FormzInput<String, PostalCodeValidationError>
    with EquatableMixin, FormzValidationMixin {
  /// {@macro full_name.pure}
  const PostalCode.pure([super.value = '']) : super.pure();

  /// {@macro full_name.dirty}
  const PostalCode.dirty(super.value) : super.dirty();

  static final _postalCodeRegex = RegExp(r'^(0*[1-9][0-9]*)$');

  @override
  PostalCodeValidationError? validator(String value) {
    if (value.isEmpty) return PostalCodeValidationError.empty;

    if (!_postalCodeRegex.hasMatch(value) || value.length < 3) {
      return PostalCodeValidationError.invalid;
    }
    return null;
  }

  @override
  Map<PostalCodeValidationError?, String?> get validationErrorMessage => {
        PostalCodeValidationError.empty: 'This field is required',
        PostalCodeValidationError.invalid: 'Postal code is not a valid code.',
        null: null,
      };

  @override
  List<Object?> get props => [value, pure];
}

/// Validation errors for [PostalCode]. It can be empty or invalid.
enum PostalCodeValidationError {
  /// Empty full name.
  empty,

  /// Invalid full name.
  invalid,
}
