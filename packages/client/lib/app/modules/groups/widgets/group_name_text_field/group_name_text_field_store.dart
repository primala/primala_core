// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte_backend/types/types.dart';
part 'group_name_text_field_store.g.dart';

class GroupNameTextFieldStore = _GroupNameTextFieldStoreBase
    with _$GroupNameTextFieldStore;

abstract class _GroupNameTextFieldStoreBase with Store, NokhteGradients {
  @observable
  TextEditingController controller = TextEditingController();

  @action
  dispose() {
    controller.dispose();
  }

  @observable
  String errorMessage = '';

  @observable
  String groupName = '';

  @observable
  bool isEnabled = true;

  @observable
  ProfileGradient profileGradient = NokhteGradients.getRandomGradient();

  @action
  setProfileGradient(ProfileGradient value) => profileGradient = value;

  @action
  setIsEnabled(bool value) => isEnabled = value;

  @action
  validateGroupName(String groupName) {
    this.groupName = groupName;

    if (groupName.isEmpty) {
      errorMessage = 'Group name cannot be empty';
    } else {
      final trimmedGroupName = groupName.trim();
      if (trimmedGroupName.length < 3) {
        errorMessage = 'Must be more than 3 characters';
      } else {
        errorMessage = '';
      }
    }
  }

  @computed
  bool get hasError => errorMessage.isNotEmpty;

  @computed
  bool get isValidInput => !hasError && groupName.isNotEmpty;
}
