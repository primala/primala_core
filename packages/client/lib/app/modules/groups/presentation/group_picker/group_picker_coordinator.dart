// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/active_group/active_group.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/tables/groups.dart';
import 'package:nokhte_backend/types/types.dart';
part 'group_picker_coordinator.g.dart';

class GroupPickerCoordinator = _GroupPickerCoordinatorBase
    with _$GroupPickerCoordinator;

abstract class _GroupPickerCoordinatorBase
    with
        Store,
        BaseMobxLogic,
        Reactions,
        BaseCoordinator,
        BaseWidgetsCoordinator {
  final GroupsContract groupsContract;
  final UserContract userContract;
  final GroupDisplayStore groupDisplay;
  final ActiveGroup activeGroup;
  @override
  final CaptureScreen captureScreen;

  _GroupPickerCoordinatorBase({
    required this.groupsContract,
    required this.userContract,
    required this.captureScreen,
    required this.groupDisplay,
    required this.activeGroup,
  }) {
    initBaseLogicActions();
    initBaseCoordinatorActions();
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() async {
    await getUserInformation();
  }

  initReactors() {
    disposers.add(createGroupReactor());
    disposers.add(editGroupReactor());
    disposers.add(activeGroupReactor());
  }

  @observable
  UserEntity user = UserEntity.initial();

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
    // print('did you even ghet called ');
    final res = await groupsContract.listenToGroups();
    res.fold(
      (failure) => errorUpdater(failure),
      (incomingGroups) {
        print('are you going to be running in here ');
        groupsStream = ObservableStream(incomingGroups);
        groupsStreamSubscription = groupsStream.listen((value) async {
          groupDisplay.setGroups(value);
        });
      },
    );
  }

  @action
  getUserInformation() async {
    final res = await userContract.getUserInformation();
    res.fold(
      (failure) {
        errorUpdater(failure);
      },
      (value) async {
        user = value;
        if (user.activeGroupId != -1) {
          activeGroup.setGroupId(user.activeGroupId);
          Modular.to.navigate(HomeConstants.homeScreen, arguments: {});
        } else {
          initReactors();
          await listenToGroups();
          await listenToRequests();
          await captureScreen(GroupsConstants.groupPicker);
          fadeInWidgets();
        }
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
    setShowWidgets(false);
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
    await groupsContract.cancelGroupsStream();
    await groupsStreamSubscription.cancel();
    await listenToGroups();
    Modular.to.pop();
  }

  @action
  updateActiveGroup(int groupId) async {
    await userContract.updateActiveGroup(groupId);
  }

  editGroupReactor() => reaction((p0) => groupDisplay.groupIndexToEdit, (p0) {
        if (p0 == -1) return;
        final group = groupDisplay.groups[p0];
        Modular.to.push(MaterialPageRoute(builder: (BuildContext context) {
          return EditGroupScreen(
            group: group,
            coordinator: Modular.get<EditGroupCoordinator>(),
          );
        }));
        groupDisplay.setGroupIndexToEdit(-1);
        groupDisplay.toggleIsManagingGroups(false);
      });

  activeGroupReactor() =>
      reaction((p0) => groupDisplay.activeGroupIndex, (p0) async {
        if (!showWidgets) return;
        setShowWidgets(false);
        final group = groupDisplay.groups[p0];
        await updateActiveGroup(group.id);
        Timer(Seconds.get(0, milli: 500), () {
          Modular.to.navigate(
            HomeConstants.homeScreen,
            arguments: {
              HomeConstants.groupId: group.id,
            },
          );
        });
      });

  createGroupReactor() =>
      reaction((p0) => groupDisplay.createGroupTapCount, (p0) {
        Modular.to.push(MaterialPageRoute(builder: (BuildContext context) {
          return CreateGroupScreen(
            coordinator: Modular.get<CreateGroupCoordinator>(),
          );
        }));
      });

  @override
  @action
  dispose() async {
    super.dispose();

    await userContract.cancelRequestsStream();
    await groupsContract.cancelGroupsStream();
    await groupsStreamSubscription.cancel();
    await requestsStreamSubscription.cancel();
  }

  @computed
  int get inboxBadgeCount => requests.length;
}
