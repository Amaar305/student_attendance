import 'package:equatable/equatable.dart' show EquatableMixin;
import 'package:flutter/foundation.dart' show immutable;
import 'package:form_fields/src/formz_validation_mixin.dart';
import 'package:formz/formz.dart';

/// {@template Decoder}
/// Formz input for Card Decoder. It can be empty or invalid.
/// {@endtemplate}
@immutable
class Decoder extends FormzInput<String, DecoderValidationError>
    with EquatableMixin, FormzValidationMixin {
  /// {@macro Decoder.pure}
  const Decoder.pure([super.value = '']) : super.pure();

  /// {@macro Decoder.dirty}
  const Decoder.dirty(super.value) : super.dirty();

  @override
  DecoderValidationError? validator(String value) {
    if (value.isEmpty) {
      return DecoderValidationError.empty;
    } else if (value.isEmpty || value.length > 20) {
      return DecoderValidationError.incomplete;
    } else {
      return null;
    }
  }

  @override
  Map<DecoderValidationError?, String?> get validationErrorMessage => {
        DecoderValidationError.empty: 'Please enter decoder number',
        DecoderValidationError.incomplete:
            // ignore: lines_longer_than_80_chars
            'Invalid Decoder Number. Decoder must be greater than 1 and less than 20.',
        null: null,
      };

  @override
  List<Object> get props => [pure, value];
}

/// Validation errors for [Decoder]. It can be empty or invalid.
enum DecoderValidationError {
  /// Empty Decoder.
  empty,

  /// Invalid Decoder.
  invalid,

  ///Incomplete
  incomplete,
}
