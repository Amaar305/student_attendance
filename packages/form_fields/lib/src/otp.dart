import 'package:equatable/equatable.dart' show EquatableMixin;
import 'package:flutter/foundation.dart' show immutable;
import 'package:form_fields/src/formz_validation_mixin.dart';
import 'package:formz/formz.dart';

/// {@template otp}
/// Formz input for OTP. It can be empty or invalid.
/// {@endtemplate}
@immutable
class Otp extends FormzInput<String, OtpValidationError>
    with EquatableMixin, FormzValidationMixin {
  /// Deserializes [Otp] from JSON.
  factory Otp.fromJson(Map<String, dynamic> json) {
    final value = json['value'] as String? ?? '';
    final isPure = json['pure'] as bool? ?? true;
    return isPure ? Otp.pure(value) : Otp.dirty(value);
  }

  /// {@macro otp.pure}
  const Otp.pure([super.value = '']) : super.pure();

  /// {@macro otp.dirty}
  const Otp.dirty(super.value) : super.dirty();

  static final _otpRegex = RegExp(r'^[0-9]+$');

  @override
  OtpValidationError? validator(String value) {
    if (value.isEmpty) {
      return OtpValidationError.empty;
    } else if (!_otpRegex.hasMatch(value)) {
      return OtpValidationError.invalid;
    } else if (value.length < 4 || value.length > 4) {
      return OtpValidationError.incomplete;
    } else {
      return null;
    }
  }

  @override
  Map<OtpValidationError?, String?> get validationErrorMessage => {
        OtpValidationError.empty:
            'PIN cannot be empty. Please enter your code.',
        OtpValidationError.invalid:
            'Invalid PIN. Please check and re-enter the code.',
        OtpValidationError.incomplete: 'Invalid OTP. PIN must be 4 digits.',
        null: null,
      };

  @override
  List<Object> get props => [pure, value];

  /// Serializes this [Otp] instance to JSON.
  Map<String, dynamic> toJson() => {
        'value': value,
        'pure': pure,
      };
}

/// Validation errors for [Otp]. It can be empty or invalid.
enum OtpValidationError {
  /// Empty OTP.
  empty,

  /// Invalid OTP.
  invalid,

  ///Incomplete
  incomplete,
}
