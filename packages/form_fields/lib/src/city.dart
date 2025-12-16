import 'package:equatable/equatable.dart' show EquatableMixin;
import 'package:flutter/foundation.dart' show immutable;
import 'package:form_fields/src/formz_validation_mixin.dart';
import 'package:formz/formz.dart' show FormzInput;

/// {@template full_name}
/// Form input for a city. It extends [FormzInput] and uses
/// [CityValidationError] for its validation errors.
/// {@endtemplate}
@immutable
class City extends FormzInput<String, CityValidationError>
    with EquatableMixin, FormzValidationMixin {
  /// {@macro full_name.pure}
  const City.pure([super.value = '']) : super.pure();

  /// {@macro full_name.dirty}
  const City.dirty(super.value) : super.dirty();

  @override
  CityValidationError? validator(String value) {
    if (value.isEmpty) return CityValidationError.empty;

    return null;
  }

  @override
  Map<CityValidationError?, String?> get validationErrorMessage => {
        CityValidationError.empty: 'This field is required',
        CityValidationError.invalid: 'City is not a valid name',
        null: null,
      };

  @override
  List<Object?> get props => [value, pure];
}

/// Validation errors for [City]. It can be empty or invalid.
enum CityValidationError {
  /// Empty full name.
  empty,

  /// Invalid full name.
  invalid,
}
