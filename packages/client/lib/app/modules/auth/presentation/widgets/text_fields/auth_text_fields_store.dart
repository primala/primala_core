// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'dart:core';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/auth/auth.dart';
part 'auth_text_fields_store.g.dart';

class AuthTextFieldsStore = _AuthTextFieldsStoreBase with _$AuthTextFieldsStore;

abstract class _AuthTextFieldsStoreBase extends BaseWidgetStore with Store {
  @observable
  ObservableList<FieldsToShow> fieldsToShow = ObservableList<FieldsToShow>();

  @observable
  ObservableList<TextEditingController> controllers =
      ObservableList<TextEditingController>();

  @action
  setFieldsToShow(List<FieldsToShow> value) {
    fieldsToShow = ObservableList<FieldsToShow>.of(value);
    controllers = ObservableList<TextEditingController>.of(
        value.map((e) => TextEditingController()).toList());
  }

  // Email validation
  @observable
  String emailErrorText = '';

  @observable
  String email = '';

  @observable
  bool emailHasError = false;

  @action
  validateEmail(String email) {
    this.email = email;
    if (email.isEmpty) {
      setEmailErrorText('Email cannot be empty.');
      return;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (emailRegex.hasMatch(email.trim())) {
      clearEmailError();
    } else {
      setEmailErrorText('Invalid email address.');
    }
  }

  @action
  setEmailErrorText(String value) {
    emailErrorText = value;
    emailHasError = true;
  }

  @action
  clearEmailError() {
    emailErrorText = '';
    emailHasError = false;
  }

  @observable
  String passwordErrorText = '';

  @observable
  bool passwordHasError = false;

  @observable
  bool isObscured = true;

  @observable
  String password = '';

  @action
  toggleIsObscured() => isObscured = !isObscured;

  @action
  validatePassword(String password) {
    this.password = password;
    if (password.isEmpty) {
      setPasswordErrorText('Password cannot be empty.');
      return;
    }

    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasMinLength = password.length >= 8;
    final commonPasswords = RegExp(
      r'^(password|123456|test|qwerty)$',
      caseSensitive: false,
    );

    if (hasUpperCase &&
        hasLowerCase &&
        hasNumber &&
        hasMinLength &&
        !commonPasswords.hasMatch(password)) {
      clearPasswordError();
    } else {
      List<String> errors = [];
      if (!hasMinLength) errors.add('at least 8 characters');
      if (!hasUpperCase) errors.add('an uppercase letter');
      if (!hasLowerCase) errors.add('a lowercase letter');
      if (!hasNumber) errors.add('a number');
      if (commonPasswords.hasMatch(password))
        errors.add('not be a common password');

      setPasswordErrorText(
        'Password must ${errors.join(', ')}.',
      );
    }
  }

  @action
  setPasswordErrorText(String value) {
    passwordErrorText = value;
    passwordHasError = true;
  }

  @action
  clearPasswordError() {
    passwordErrorText = '';
    passwordHasError = false;
  }

  // Full name validation
  @observable
  String fullNameErrorText = '';

  @observable
  bool fullNameHasError = false;

  @observable
  String fullName = '';

  @action
  validateFullName(String fullName) {
    this.fullName = fullName;
    if (fullName.isEmpty) {
      setFullNameErrorText('Full name cannot be empty.');
      return;
    }

    if (RegExp(r'^\w+\s+\w+').hasMatch(fullName.trim())) {
      clearFullNameError();
    } else {
      setFullNameErrorText('Please enter your full name (e.g., John Doe).');
    }
  }

  @action
  setFullNameErrorText(String value) {
    fullNameErrorText = value;
    fullNameHasError = true;
  }

  @action
  clearFullNameError() {
    fullNameErrorText = '';
    fullNameHasError = false;
  }

  @computed
  bool get allInputsAreValid {
    return !emailHasError &&
        !passwordHasError &&
        !fullNameHasError &&
        controllers.every((element) => element.text.isNotEmpty);
  }
}
