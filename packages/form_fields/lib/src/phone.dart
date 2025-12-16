import 'package:equatable/equatable.dart' show EquatableMixin;
import 'package:flutter/foundation.dart' show immutable;
import 'package:form_fields/src/formz_validation_mixin.dart';
import 'package:formz/formz.dart';

/// {@template Phone}
/// Formz input for Phone. It can be empty or invalid.
/// {@endtemplate}
@immutable
class Phone extends FormzInput<String, PhoneValidationError>
    with EquatableMixin, FormzValidationMixin {
  /// Deserializes [Phone] from JSON.
  factory Phone.fromJson(Map<String, dynamic> json) {
    final value = json['value'] as String? ?? '';
    final isPure = json['pure'] as bool? ?? true;
    return isPure ? Phone.pure(value) : Phone.dirty(value);
  }

  /// {@macro Phone.pure}
  const Phone.pure([super.value = '']) : super.pure();

  /// {@macro Phone.dirty}
  const Phone.dirty(super.value) : super.dirty();

  static final _phoneRegex = RegExp(r'^0\d{10}$');

  @override
  PhoneValidationError? validator(String value) {
    if (value.isEmpty) return PhoneValidationError.empty;
    if (!_phoneRegex.hasMatch(value)) return PhoneValidationError.invalid;
    return null;
  }

  /// Phone validation errors message
  @override
  Map<PhoneValidationError?, String?> get validationErrorMessage => {
        PhoneValidationError.empty: 'This field is required',
        PhoneValidationError.invalid: 'Invalid phone number',
        null: null,
      };

  @override
  List<Object> get props => [pure, value];

  /// Serializes this [Phone] instance to JSON.
  Map<String, dynamic> toJson() => {
        'value': value,
        'pure': pure,
      };
}

/// Validation errors for [Phone]. It can be empty, invalid or already
/// registered.
enum PhoneValidationError {
  /// Empty Phone.
  empty,

  /// Invalid Phone.
  invalid,
}
