// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/constants/text_field_validators.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/types/types.dart';
part 'invitation_body_store.g.dart';

class InvitationBodyStore = _InvitationBodyStoreBase with _$InvitationBodyStore;

abstract class _InvitationBodyStoreBase with Store, TextFieldValidators {
  @observable
  TextEditingController controller = TextEditingController();

  @observable
  GroupEntity group = GroupEntity.initial();

  @observable
  String selectAreaTitleText = 'Keep typing to search email.';

  @observable
  String selectAreaBodyText = '';

  @observable
  String emailSearchText = '';

  @observable
  int searchEmailCount = 0;

  @observable
  UserInformationEntity userInformationEntity = UserInformationEntity.initial();

  @observable
  GroupRole currentGroupRole = GroupRole.collaborator;

  @observable
  bool isSelectable = false;

  @observable
  ObservableList<SendRequestParams> requests =
      ObservableList<SendRequestParams>();

  @observable
  ObservableSet<String> selectedEmails = ObservableSet<String>();

  @action
  setGroup(GroupEntity group) => this.group = group;

  @action
  addRequest(SendRequestParams request) => requests.add(request);

  @action
  onChange(String value) {
    if (value.isEmpty) {
      emailSearchText = '';
      selectAreaBodyText = '';
      isSelectable = false;
      selectedEmails.clear();
      selectAreaTitleText = 'Keep typing to search email.';
      return;
    }

    selectedEmails.removeWhere((email) => !value.contains(email));
    requests.removeWhere((request) => !value.contains(request.recipientEmail));

    final List<String> inputParts = value.split(' ');

    String currentInput = inputParts.last;

    if (selectedEmails.contains(currentInput)) {
      currentInput = '';
    }

    emailSearchText = currentInput;
    selectAreaBodyText = currentInput;

    if (currentInput.isNotEmpty) {
      final errorText = validateEmail(currentInput);
      if (errorText.isEmpty) {
        searchEmailCount++;
      } else {
        isSelectable = false;
        selectAreaTitleText = errorText;
      }
    } else {
      isSelectable = false;
      selectAreaTitleText = 'Keep typing to search email.';
    }
    print('requests $requests');
  }

  @action
  onSelected() {
    if (isSelectable) {
      selectedEmails.add(userInformationEntity.email);
      requests.add(
        SendRequestParams(
          groupId: group.id,
          recipientEmail: userInformationEntity.email,
          role: currentGroupRole,
          recipientUid: userInformationEntity.uid,
          recipientProfileGradient: userInformationEntity.profileGradient,
          recipientFullName: userInformationEntity.fullName,
        ),
      );
      print('userInformationEntity $userInformationEntity');
      controller.text += ' ';
      selectAreaBodyText = '';
      userInformationEntity = UserInformationEntity.initial();
      selectAreaTitleText = 'Keep typing to search email.';
      isSelectable = false;
    }
  }

  @action
  onDeleteEmail(String email) {
    selectedEmails.remove(email);
    controller.text = controller.text.replaceAll(email, '');
    emailSearchText = emailSearchText.replaceAll(email, '');
  }

  @action
  removeRequestsParameters(String email) {
    for (var request in requests) {
      if (request.recipientEmail == email) {
        requests.remove(request);
      }
    }
  }

  @action
  void addSelectedEmail(String email) {
    selectedEmails.add(email);
  }

  @action
  onEmailNotFound() {
    isSelectable = false;
    selectAreaTitleText = 'Collaborator not found, needs to have account';
  }

  @action
  onError(String error) {
    isSelectable = false;
    selectAreaTitleText = error;
  }

  @action
  onEmailFound(UserInformationEntity entity) {
    userInformationEntity = entity;
    isSelectable = true;
    selectAreaTitleText = 'Select a person';
    selectAreaBodyText = entity.fullName;
  }

  onPermissionLevelTap() {
    Modular.to.push(
      MaterialPageRoute(builder: (BuildContext context) {
        return SelectRoleScreen(
          showRemoveItem: false,
          onRoleSelected: (role) {
            setCurrentGroupRole(role);
            Modular.to.pop();
          },
        );
      }),
    );
  }

  @action
  setCurrentGroupRole(GroupRole role) => currentGroupRole = role;

  @action
  dispose() {
    controller.dispose();
  }

  @computed
  String get currentRole =>
      '${currentGroupRole.name[0].toUpperCase()}${currentGroupRole.name.substring(1)}';
}
