// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'group_registration_store.g.dart';

class GroupRegistrationStore = _GroupRegistrationStoreBase
    with _$GroupRegistrationStore;

abstract class _GroupRegistrationStoreBase extends BaseWidgetStore with Store {
  // Text controllers
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController groupHandleController = TextEditingController();

  @observable
  int submissionCount = 0;

  @action
  void setGroupName(String name) {
    groupNameController.text = name;
  }

  @action
  void setGroupHandle(String handle) {
    groupHandleController.text = handle;
  }

  @action
  void reset() {
    groupNameController.clear();
    groupHandleController.clear();
  }

  @action
  void onSubmit() {
    final groupName = groupNameController.text;
    final groupHandle = groupHandleController.text;

    params = CreateNewGroupParams(
      groupName: groupName,
      groupHandle: groupHandle,
    );

    if (groupName.isEmpty || groupHandle.isEmpty) return;

    submissionCount++;
    // reset(); // Clear controllers
    setWidgetVisibility(false);
  }

  @observable
  CreateNewGroupParams params = const CreateNewGroupParams(
    groupName: '',
    groupHandle: '',
  );

  void dispose() {
    groupNameController.dispose();
    groupHandleController.dispose();
  }
}
