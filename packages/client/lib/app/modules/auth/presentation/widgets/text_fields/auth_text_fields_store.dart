// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'dart:core';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/constants/text_field_validators.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/auth/auth.dart';
part 'auth_text_fields_store.g.dart';

class AuthTextFieldsStore = _AuthTextFieldsStoreBase with _$AuthTextFieldsStore;

abstract class _AuthTextFieldsStoreBase extends BaseWidgetStore
    with Store, TextFieldValidators {
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
  onEmailChanged(String email) {
    this.email = email;
    setEmailErrorText(
      validateEmail(email),
    );
  }

  @action
  setEmailErrorText(String value) {
    emailErrorText = value;
    emailHasError = true;
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
  onPasswordChanged(String password) {
    this.password = password;
    setPasswordErrorText(
      validatePassword(password),
    );
  }

  @action
  setPasswordErrorText(String value) {
    passwordErrorText = value;
    passwordHasError = true;
  }

  // Full name validation
  @observable
  String fullNameErrorText = '';

  @observable
  bool fullNameHasError = false;

  @observable
  String fullName = '';

  @action
  onFullNameChanged(String fullName) {
    this.fullName = fullName;
    setFullNameErrorText(
      validateFullName(fullName),
    );
  }

  @action
  setFullNameErrorText(String value) {
    fullNameErrorText = value;
    fullNameHasError = true;
  }

  @computed
  bool get allInputsAreValid {
    return !emailHasError &&
        !passwordHasError &&
        !fullNameHasError &&
        controllers.every((element) => element.text.isNotEmpty);
  }
}
