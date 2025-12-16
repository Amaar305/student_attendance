import 'package:equatable/equatable.dart' show EquatableMixin;
import 'package:flutter/foundation.dart' show immutable;
import 'package:form_fields/src/formz_validation_mixin.dart';
import 'package:formz/formz.dart' show FormzInput;

/// {@template full_name}
/// Form input for a full name. It extends [FormzInput] and uses
/// [AmountValidationError] for its validation errors.
/// {@endtemplate}
@immutable
class Amount extends FormzInput<String, AmountValidationError>
    with EquatableMixin, FormzValidationMixin {
  /// {@macro full_name.pure}
  const Amount.pure([super.value = '']) : super.pure();

  /// {@macro full_name.dirty}
  const Amount.dirty(super.value) : super.dirty();

  static final _amountRegex = RegExp(r'^[0-9]+$');

  @override
  AmountValidationError? validator(String value) {
    if (value.isEmpty) return AmountValidationError.empty;
    if (!_amountRegex.hasMatch(value)) return AmountValidationError.invalid;
    return null;
  }

  @override
  Map<AmountValidationError?, String?> get validationErrorMessage => {
        AmountValidationError.empty: 'This field is required',
        AmountValidationError.invalid: 'Amount is incorrect',
        null: null,
      };

  @override
  List<Object?> get props => [value, pure];
}

/// Validation errors for [Amount]. It can be empty or invalid.
enum AmountValidationError {
  /// Empty full name.
  empty,

  /// Invalid full name.
  invalid,
}
