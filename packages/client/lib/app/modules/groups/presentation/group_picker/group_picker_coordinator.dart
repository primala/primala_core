// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/tables/groups.dart';
part 'group_picker_coordinator.g.dart';

class GroupPickerCoordinator = _GroupPickerCoordinatorBase
    with _$GroupPickerCoordinator;

abstract class _GroupPickerCoordinatorBase
    with Store, BaseMobxLogic, Reactions {
  final GroupPickerWidgetsCoordinator widgets;
  final GroupsContract groupsContract;
  final UserContract userContract;

  _GroupPickerCoordinatorBase({
    required this.widgets,
    required this.groupsContract,
    required this.userContract,
  }) {
    initBaseLogicActions();
  }

  @action
  constructor() async {
    widgets.constructor();
    initReactors();
    await listenToGroups();
    await listenToRequests();
  }

  initReactors() {
    disposers.add(groupsReactor());
    disposers.add(widgets.createGroupReactor());
    disposers.add(widgets.editGroupReactor());
    disposers.add(widgets.activeGroupReactor(updateActiveGroup));
  }

  @observable
  ObservableList<GroupEntity> groups = ObservableList<GroupEntity>();

  @observable
  ObservableList<GroupRequestEntity> requests =
      ObservableList<GroupRequestEntity>();

  @observable
  ObservableStream<GroupRequests> requestsStream =
      ObservableStream(const Stream.empty());

  StreamSubscription requestsStreamSubscription =
      const Stream.empty().listen((event) {});

  @observable
  ObservableStream<GroupEntities> groupsStream =
      ObservableStream(const Stream.empty());

  StreamSubscription groupsStreamSubscription =
      const Stream.empty().listen((event) {});

  @action
  listenToGroups() async {
    final res = await groupsContract.listenToGroups();
    res.fold(
      (failure) => errorUpdater(failure),
      (incomingGroups) {
        groupsStream = ObservableStream(incomingGroups);
        groupsStreamSubscription = groupsStream.listen((value) {
          groups = ObservableList.of(value);
        });
      },
    );
  }

  @action
  listenToRequests() async {
    final res = await userContract.listenToRequests();
    res.fold(
      (failure) => errorUpdater(failure),
      (incomingRequests) {
        requestsStream = ObservableStream(incomingRequests);
        requestsStreamSubscription = requestsStream.listen((value) {
          requests = ObservableList.of(value);
        });
      },
    );
  }

  @action
  onSettingsTapped() {
    widgets.setShowWidgets(false);
    Timer(Seconds.get(0, milli: 500), () {
      Modular.to.navigate(GroupsConstants.accountSettings);
    });
  }

  @action
  onInboxTapped() {
    Modular.to.push(
      MaterialPageRoute(builder: (BuildContext context) {
        return Observer(builder: (context) {
          return InboxScreen(
            requests: requests,
            handleRequest: handleRequest,
          );
        });
      }),
    );
  }

  @action
  handleRequest(HandleRequestParams params) async {
    await userContract.handleRequest(params);
    // if (params.accept) {
    //   await getGroups();
    // }
    Modular.to.pop();
  }

  @action
  updateActiveGroup(int groupId) async {
    await userContract.updateActiveGroup(groupId);
  }

  groupsReactor() => reaction((p0) => groups, (p0) {
        widgets.groupDisplay.setGroups(p0);
        widgets.groupDisplay.setWidgetVisibility(true);
      });

  @override
  @action
  dispose() async {
    super.dispose();
    await groupsContract.cancelGroupsStream();
    await userContract.cancelRequestsStream();
    groupsStreamSubscription.cancel();
    requestsStreamSubscription.cancel();
  }

  @computed
  int get inboxBadgeCount => requests.length;
}
