// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/active_group/active_group.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/groups.dart';
import 'package:nokhte_backend/tables/sessions.dart';
part 'home_screen_coordinator.g.dart';

class HomeScreenCoordinator = _HomeScreenCoordinatorBase
    with _$HomeScreenCoordinator;

abstract class _HomeScreenCoordinatorBase
    with Store, BaseWidgetsCoordinator, BaseMobxLogic, BaseCoordinator {
  final HomeContract contract;
  final ActiveGroup activeGroup;
  @override
  final CaptureScreen captureScreen;

  _HomeScreenCoordinatorBase({
    required this.contract,
    required this.captureScreen,
    required this.activeGroup,
  }) {
    initBaseLogicActions();
    initBaseWidgetsCoordinatorActions();
  }

  @observable
  bool showCarousel = false;

  @observable
  GroupEntity selectedGroup = GroupEntity.initial();

  @observable
  ActiveSession activeSession = ActiveSession.initial();

  @observable
  ObservableStream<ActiveSession> activeSessionStream =
      ObservableStream(const Stream.empty());

  @observable
  StreamSubscription activeSessionStreamSubscription =
      const Stream.empty().listen((event) {});

  @action
  setShowCarousel(bool value) => showCarousel = value;

  @action
  constructor() async {
    Modular.dispose<SessionPresenceCoordinator>();
    final activeGroupId = activeGroup.groupId;
    if (activeGroup.groupEntity.name.isEmpty) {
      await contract.deleteStaleSessions();
      await getGroup(activeGroupId);
    } else {
      selectedGroup = activeGroup.groupEntity;
      fadeInWidgets();
      setShowCarousel(true);
      await listenToActiveSessions();
      await contract.deleteStaleSessions();
    }
    await captureScreen(HomeConstants.homeScreen);
  }

  @action
  goToSessionStarter() {
    Modular.to.push(
      MaterialPageRoute(builder: (BuildContext context) {
        return SessionStarterScreen(
          coordinator: Modular.get<SessionStarterCoordinator>(),
        );
      }),
    );
  }

  @action
  listenToActiveSessions() async {
    final res = await contract.listenToActiveSessions(selectedGroup.id);
    res.fold((failure) => errorUpdater(failure), (stream) {
      activeSessionStreamSubscription = stream.listen((event) {
        activeSession = event;
      });
    });
  }

  @action
  joinSession() {
    if (activeSession.id == -1 || !activeSession.canJoin) return;
    setShowWidgets(false);
    setShowCarousel(false);
    Timer(Seconds.get(0, milli: 500), () {
      Modular.to.navigate(SessionConstants.lobby);
    });
  }

  @action
  clearActiveGroup() async {
    final res = await contract.clearActiveGroup();
    res.fold((failure) => errorUpdater(failure), (success) {
      setShowWidgets(false);
      setShowCarousel(false);
      activeGroup.reset();
      Timer(Seconds.get(0, milli: 500), () {
        Modular.to.navigate(GroupsConstants.groupPicker);
      });
    });
  }

  @action
  getGroup(int groupId) async {
    final res = await contract.getGroup(groupId);
    res.fold((failure) => errorUpdater(failure), (group) async {
      selectedGroup = group;
      activeGroup.setGroupEntity(group);
      await listenToActiveSessions();
      fadeInWidgets(onFadein: () {
        setShowCarousel(true);
      });
    });
  }

  @action
  dispose() async {
    await contract.cancelSessionRequestsStream();
    await activeSessionStreamSubscription.cancel();
  }
}
