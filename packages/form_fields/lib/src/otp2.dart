import 'package:equatable/equatable.dart' show EquatableMixin;
import 'package:flutter/foundation.dart' show immutable;
import 'package:form_fields/src/formz_validation_mixin.dart';
import 'package:formz/formz.dart';

/// {@template otp2}
/// Formz input for OTP2. It can be empty or invalid.
/// {@endtemplate}
@immutable
class Otp2 extends FormzInput<String, Otp2ValidationError>
    with EquatableMixin, FormzValidationMixin {
  /// {@macro otp2.pure}
  const Otp2.pure([super.value = '']) : super.pure();

  /// {@macro otp2.dirty}
  const Otp2.dirty(super.value) : super.dirty();

  static final _otp2Regex = RegExp(r'^[0-9]+$');

  @override
  Otp2ValidationError? validator(String value) {
    if (value.isEmpty) {
      return Otp2ValidationError.empty;
    } else if (!_otp2Regex.hasMatch(value)) {
      return Otp2ValidationError.invalid;
    } else if (value.length < 6 || value.length > 6) {
      return Otp2ValidationError.incomplete;
    } else {
      return null;
    }
  }

  @override
  Map<Otp2ValidationError?, String?> get validationErrorMessage => {
        Otp2ValidationError.empty:
            'OTP cannot be empty. Please enter your code.',
        Otp2ValidationError.invalid:
            'Incorrect OTP. Please check and re-enter the code.',
        Otp2ValidationError.incomplete: 'Incorrect OTP. Otp must be 6 digits.',
        null: null,
      };

  @override
  List<Object> get props => [pure, value];
}

/// Validation errors for [Otp2]. It can be empty or invalid.
enum Otp2ValidationError {
  /// Empty OTP2.
  empty,

  /// Invalid OTP2.
  invalid,

  ///Incomplete
  incomplete,
}
