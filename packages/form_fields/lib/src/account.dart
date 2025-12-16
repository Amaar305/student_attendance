import 'package:equatable/equatable.dart' show EquatableMixin;
import 'package:flutter/foundation.dart' show immutable;
import 'package:form_fields/src/formz_validation_mixin.dart';
import 'package:formz/formz.dart' show FormzInput;

/// {@template full_name}
/// Form input for a full name. It extends [FormzInput] and uses
/// [AccountValidationError] for its validation errors.
/// {@endtemplate}
@immutable
class Account extends FormzInput<String, AccountValidationError>
    with EquatableMixin, FormzValidationMixin {
  /// {@macro full_name.pure}
  const Account.pure([super.value = '']) : super.pure();

  /// {@macro full_name.dirty}
  const Account.dirty(super.value) : super.dirty();

  // static final _AccountRegex = RegExp('[, ]');
  static final _accountRegex = RegExp(r'^[0-9]+$');

  @override
  AccountValidationError? validator(String value) {
    if (value.isEmpty) {
      return AccountValidationError.empty;
    } else if (value.length < 10 || value.length > 10) {
      return AccountValidationError.incomplete;
    } else if (!_accountRegex.hasMatch(value)) {
      return AccountValidationError.invalid;
    }
    return null;
  }

  @override
  Map<AccountValidationError?, String?> get validationErrorMessage => {
        AccountValidationError.empty: 'This field is required',
        AccountValidationError.invalid: 'Account Number is incorrect',
        AccountValidationError.incomplete:
            'Incomplete. Account Number must be 10 digits.',
        null: null,
      };

  @override
  List<Object?> get props => [value, pure];
}

/// Validation errors for [Account]. It can be empty or invalid.
enum AccountValidationError {
  /// Empty full name.
  empty,

  /// Invalid full name.
  invalid,

  /// Invalid full name.
  incomplete,
}
