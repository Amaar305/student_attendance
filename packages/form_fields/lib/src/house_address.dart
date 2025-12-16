import 'package:equatable/equatable.dart' show EquatableMixin;
import 'package:flutter/foundation.dart' show immutable;
import 'package:form_fields/src/formz_validation_mixin.dart';
import 'package:formz/formz.dart' show FormzInput;

/// {@template full_name}
/// Form input for a house address. It extends [FormzInput] and uses
/// [HouseAddressValidationError] for its validation errors.
/// {@endtemplate}
@immutable
class HouseAddress extends FormzInput<String, HouseAddressValidationError>
    with EquatableMixin, FormzValidationMixin {
  /// {@macro full_name.pure}
  const HouseAddress.pure([super.value = '']) : super.pure();

  /// {@macro full_name.dirty}
  const HouseAddress.dirty(super.value) : super.dirty();

  ///
  bool _isValidAddress(String input) {
    // Trim whitespace from both ends
    final trimmed = input.trim();

    // Enforce max length
    if (trimmed.length > 150) return false;

    // Check for only allowed characters
    final allowedRegex = RegExp(r'^[\p{L}\d\s.,\-/#]+$', unicode: true);
    if (!allowedRegex.hasMatch(trimmed)) return false;

    // Reject if it has multiple consecutive spaces
    if (trimmed.contains(RegExp(r'\s{2,}'))) return false;

    // Count only letters
    final letterCount =
        RegExp(r'\p{L}', unicode: true).allMatches(trimmed).length;
    if (letterCount < 4) return false;

    return true;
  }

  @override
  HouseAddressValidationError? validator(String value) {
    if (value.isEmpty) return HouseAddressValidationError.empty;
    if (!_isValidAddress(value)) {
      return HouseAddressValidationError.invalid;
    }
    return null;
  }

  @override
  Map<HouseAddressValidationError?, String?> get validationErrorMessage => {
        HouseAddressValidationError.empty: 'This field is required',
        HouseAddressValidationError.invalid:
            'House address is not a valid address',
        null: null,
      };

  @override
  List<Object?> get props => [value, pure];
}

/// Validation errors for [HouseAddress]. It can be empty or invalid.
enum HouseAddressValidationError {
  /// Empty full name.
  empty,

  /// Invalid full name.
  invalid,
}
