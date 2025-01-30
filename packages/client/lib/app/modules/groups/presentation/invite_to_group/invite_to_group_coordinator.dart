// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/tables/groups.dart';
part 'invite_to_group_coordinator.g.dart';

class InviteToGroupCoordinator = _InviteToGroupCoordinatorBase
    with _$InviteToGroupCoordinator;

abstract class _InviteToGroupCoordinatorBase
    with Store, Reactions, BaseCoordinator {
  final InvitationBodyStore invitationBody;
  final GroupRolesContractImpl contract;
  @override
  final CaptureScreen captureScreen;

  _InviteToGroupCoordinatorBase({
    required this.invitationBody,
    required this.contract,
    required this.captureScreen,
  });

  @observable
  GroupEntity group = GroupEntity.initial();

  @action
  constructor(GroupEntity group) async {
    this.group = group;
    invitationBody.setGroup(group);
    disposers.add(emailSearchReactor());
    await captureScreen(GroupsConstants.inviteToGroup);
  }

  @action
  onGoBack() {
    Modular.to.pop();
  }

  emailSearchReactor() =>
      reaction((p0) => invitationBody.searchEmailCount, (p0) async {
        final email = invitationBody.emailSearchText;
        final res = await contract.getUserByEmail(email);
        res.fold((failure) {
          invitationBody.onError(failure.message);
        }, (userRow) {
          if (userRow.fullName.isEmpty) {
            invitationBody.onEmailNotFound();
          } else {
            invitationBody.onEmailFound(userRow);
          }
        });
      });

  sendInvitations() async {
    final res = await contract.sendRequests(invitationBody.requests);
    res.fold((failure) {
      invitationBody.onError(failure.message);
    }, (value) {
      Modular.to.pop();
    });
  }
}
