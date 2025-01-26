// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
part 'invitation_body_store.g.dart';

class InvitationBodyStore = _InvitationBodyStoreBase with _$InvitationBodyStore;

abstract class _InvitationBodyStoreBase with Store {
  @observable
  TextEditingController controller = TextEditingController();

  @observable
  String selectAreaText = '';

  @observable
  String emailSearchText = '';

  @action
  onChange(String value) {}

  @action
  dispose() {
    controller.dispose();
  }
}
