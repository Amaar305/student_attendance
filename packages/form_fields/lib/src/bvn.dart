import 'package:equatable/equatable.dart' show EquatableMixin;
import 'package:flutter/foundation.dart' show immutable;
import 'package:form_fields/src/formz_validation_mixin.dart';
import 'package:formz/formz.dart' show FormzInput;

/// {@template full_name}
/// Form input for a postal code. It extends [FormzInput] and uses
/// [BvnValidationError] for its validation errors.
/// {@endtemplate}
@immutable
class Bvn extends FormzInput<String, BvnValidationError>
    with EquatableMixin, FormzValidationMixin {
  /// {@macro full_name.pure}
  const Bvn.pure([super.value = '']) : super.pure();

  /// {@macro full_name.dirty}
  const Bvn.dirty(super.value) : super.dirty();

  ///
  bool _isValidBVNStrict(String input) {
    final cleaned =
        input.replaceAll(RegExp(r'\D'), ''); // Remove all non-digits
    return cleaned.length == 11;
  }

  @override
  BvnValidationError? validator(String value) {
    if (value.isEmpty) return BvnValidationError.empty;

    if (!_isValidBVNStrict(value)) {
      return BvnValidationError.invalid;
    }
    return null;
  }

  @override
  Map<BvnValidationError?, String?> get validationErrorMessage => {
        BvnValidationError.empty: 'This field is required',
        BvnValidationError.invalid: 'BVN is invalid.',
        null: null,
      };

  @override
  List<Object?> get props => [value, pure];
}

/// Validation errors for [Bvn]. It can be empty or invalid.
enum BvnValidationError {
  /// Empty full name.
  empty,

  /// Invalid full name.
  invalid,
}
