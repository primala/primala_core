// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/constants/text_field_validators.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
part 'invitation_body_store.g.dart';

class InvitationBodyStore = _InvitationBodyStoreBase with _$InvitationBodyStore;

abstract class _InvitationBodyStoreBase with Store, TextFieldValidators {
  @observable
  TextEditingController controller = TextEditingController();

  @observable
  String selectAreaTitleText = 'Keep typing to search email.';

  @observable
  String emailSearchText = '';

  @observable
  GroupRole currentGroupRole = GroupRole.collaborator;

  @observable
  bool isSelectable = true;

  @action
  onChange(String value) {
    emailSearchText = value;
    if (value.isNotEmpty) {
      final errorText = validateEmail(value);
      if (errorText.isEmpty) {
        // Simulating account check - you'll replace with actual logic
        isSelectable = true;
        selectAreaTitleText = 'Tap to add email';
      } else {
        // isSelectable = false;
        isSelectable = true;
        selectAreaTitleText = errorText;
      }
    } else {
      // isSelectable = false;
      isSelectable = true;
      selectAreaTitleText = 'Keep typing to search email.';
    }
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
