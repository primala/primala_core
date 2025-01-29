// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/tables/groups.dart';
part 'invite_to_group_coordinator.g.dart';

class InviteToGroupCoordinator = _InviteToGroupCoordinatorBase
    with _$InviteToGroupCoordinator;

abstract class _InviteToGroupCoordinatorBase with Store, Reactions {
  final InviteToGroupWidgetsCoordinator widgets;
  final GroupRolesContractImpl contract;

  _InviteToGroupCoordinatorBase({
    required this.widgets,
    required this.contract,
  });

  @observable
  GroupEntity group = GroupEntity.initial();

  @action
  constructor(GroupEntity group) async {
    this.group = group;
    widgets.invitationBody.setGroup(group);
    disposers.add(emailSearchReactor());
  }

  @action
  onGoBack() {
    Modular.to.pop();
  }

  emailSearchReactor() =>
      reaction((p0) => widgets.invitationBody.searchEmailCount, (p0) async {
        final email = widgets.invitationBody.emailSearchText;
        final res = await contract.getUserByEmail(email);
        res.fold((failure) {
          widgets.invitationBody.onError(failure.message);
        }, (userRow) {
          if (userRow.fullName.isEmpty) {
            widgets.invitationBody.onEmailNotFound();
          } else {
            widgets.invitationBody.onEmailFound(userRow);
          }
        });
      });

  sendInvitations() async {
    final res = await contract.sendRequests(widgets.invitationBody.requests);
    res.fold((failure) {
      widgets.invitationBody.onError(failure.message);
    }, (value) {
      Modular.to.pop();
    });
  }
}
