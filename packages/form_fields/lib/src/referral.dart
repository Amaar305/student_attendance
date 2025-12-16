import 'package:equatable/equatable.dart' show EquatableMixin;
import 'package:flutter/foundation.dart' show immutable;
import 'package:form_fields/src/formz_validation_mixin.dart';
import 'package:formz/formz.dart';

/// {@template Referral}
/// Formz input for Referral. It can be empty or invalid.
/// {@endtemplate}
@immutable
class Referral extends FormzInput<String, ReferralValidationError>
    with EquatableMixin, FormzValidationMixin {
  /// Deserializes [Referral] from JSON.
  factory Referral.fromJson(Map<String, dynamic> json) {
    final value = json['value'] as String? ?? '';
    final isPure = json['pure'] as bool? ?? true;
    return isPure ? Referral.pure(value) : Referral.dirty(value);
  }

  /// {@macro Referral.pure}
  const Referral.pure([super.value = '']) : super.pure();

  /// {@macro Referral.dirty}
  const Referral.dirty(super.value) : super.dirty();

  static final _referralRegex = RegExp(r'^0\d{10}$');

  @override
  ReferralValidationError? validator(String value) {
    if (value.isEmpty) return null;
    if (!_referralRegex.hasMatch(value)) return ReferralValidationError.invalid;
    return null;
  }

  /// Referral validation errors message
  @override
  Map<ReferralValidationError?, String?> get validationErrorMessage => {
        ReferralValidationError.empty: 'This field is required',
        ReferralValidationError.invalid: 'Invalid Referral number',
        null: null,
      };

  @override
  List<Object> get props => [pure, value];

  /// Serializes this [Referral] instance to JSON.
  Map<String, dynamic> toJson() => {
        'value': value,
        'pure': pure,
      };
}

/// Validation errors for [Referral]. It can be empty, invalid or already
/// registered.
enum ReferralValidationError {
  /// Empty Referral.
  empty,

  /// Invalid Referral.
  invalid,
}
