import 'package:equatable/equatable.dart' show EquatableMixin;
import 'package:flutter/foundation.dart' show immutable;
import 'package:form_fields/src/formz_validation_mixin.dart';
import 'package:formz/formz.dart' show FormzInput;

/// {@template full_name}
/// Form input for a house number. It extends [FormzInput] and uses
/// [HouseNumberValidationError] for its validation errors.
/// {@endtemplate}
@immutable
class HouseNumber extends FormzInput<String, HouseNumberValidationError>
    with EquatableMixin, FormzValidationMixin {
  /// {@macro full_name.pure}
  const HouseNumber.pure([super.value = '']) : super.pure();

  /// {@macro full_name.dirty}
  const HouseNumber.dirty(super.value) : super.dirty();

  static final _houseNumberRegex = RegExp(r'^(0*[1-9][0-9]*)$');

  @override
  HouseNumberValidationError? validator(String value) {
    if (value.isEmpty) return HouseNumberValidationError.empty;

    if (!_houseNumberRegex.hasMatch(value)) {
      return HouseNumberValidationError.invalid;
    }

    return null;
  }

  @override
  Map<HouseNumberValidationError?, String?> get validationErrorMessage => {
        HouseNumberValidationError.empty: 'This field is required',
        HouseNumberValidationError.invalid: 'House number is invalid',
        null: null,
      };

  @override
  List<Object?> get props => [value, pure];
}

/// Validation errors for [HouseNumber]. It can be empty or invalid.
enum HouseNumberValidationError {
  /// Empty full name.
  empty,

  /// Invalid full name.
  invalid,
}
