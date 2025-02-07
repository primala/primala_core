// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/sessions.dart';
part 'session_presence_coordinator.g.dart';

class SessionPresenceCoordinator = _SessionPresenceCoordinatorBase
    with _$SessionPresenceCoordinator;

abstract class _SessionPresenceCoordinatorBase with Store, BaseMobxLogic {
  final SessionMetadataStore sessionMetadataStore;
  final CollaboratorPresenceIncidentsOverlayStore incidentsOverlayStore;
  final SessionPresenceContract contract;

  _SessionPresenceCoordinatorBase({
    required this.contract,
    required this.sessionMetadataStore,
  }) : incidentsOverlayStore = CollaboratorPresenceIncidentsOverlayStore(
          sessionMetadataStore: sessionMetadataStore,
        ) {
    initBaseLogicActions();
  }

  @observable
  bool sessionIsFinished = false;

  @observable
  bool userStatusIsUpdated = false;

  @observable
  bool activeDocumentIsUpdated = false;

  @observable
  bool whoIsTalkingIsUpdated = false;

  @observable
  bool powerUpIsUsed = false;

  @observable
  bool isListening = false;

  @observable
  bool sessionStartStatusIsUpdated = false;

  @observable
  bool speakerSpotlightIsUpdated = false;

  @observable
  bool speakingTimerStartIsUpdated = false;

  @action
  ReactionDisposer initReactors({
    required Function onCollaboratorJoined,
    required Function onCollaboratorLeft,
  }) =>
      incidentsOverlayStore.collaboratorPresenceReactor(
          onCollaboratorJoined, onCollaboratorLeft);

  @action
  dispose() async {
    setState(StoreState.loading);
    final res = await contract.cancelSessionMetadataStream();
    await sessionMetadataStore.dispose();
    isListening = res;
    setState(StoreState.loaded);
  }

  @action
  listen() {
    setState(StoreState.loading);
    sessionMetadataStore.get();
    setState(StoreState.loaded);
  }

  @action
  deleteSession(int sessionId) async {
    final res = await contract.deleteSession(sessionId);
    res.fold(
      (failure) => errorUpdater(failure),
      (sessionUpdateStatus) => sessionIsFinished = sessionUpdateStatus,
    );
    setState(StoreState.loaded);
  }

  @action
  updateWhoIsTalking(UpdateWhoIsTalkingParams params) async {
    final res = await contract.updateWhoIsTalking(params);
    res.fold(
      (failure) => errorUpdater(failure),
      (gyroscopeUpdateStatus) =>
          speakerSpotlightIsUpdated = gyroscopeUpdateStatus,
    );
    setState(StoreState.loaded);
  }

  @action
  updateSpeakingTimerStart() async {
    final res = await contract.updateSpeakingTimerStart();
    res.fold(
      (failure) => errorUpdater(failure),
      (speakingTimerStatus) =>
          speakingTimerStartIsUpdated = speakingTimerStatus,
    );
    setState(StoreState.loaded);
  }

  @action
  updateUserStatus(SessionUserStatus params) async {
    userStatusIsUpdated = false;
    setState(StoreState.loading);
    final res = await contract.updateUserStatus(params);
    res.fold((failure) => errorUpdater(failure),
        (status) => userStatusIsUpdated = status);
    setState(StoreState.loaded);
  }

  @action
  startTheSession() async {
    setState(StoreState.loading);
    final res = await contract.startTheSession();
    res.fold(
      (failure) => errorUpdater(failure),
      (status) => sessionStartStatusIsUpdated = status,
    );
    setState(StoreState.loaded);
  }

  @action
  usePowerUp(Either<LetEmCookParams, RallyParams> params) async {
    setState(StoreState.loading);
    final res = await contract.usePowerUp(params);
    res.fold(
      (failure) => errorUpdater(failure),
      (status) => powerUpIsUsed = status,
    );
    setState(StoreState.loaded);
  }

  @action
  updateActiveDocument(int docId) async {
    setState(StoreState.loading);
    final res = await contract.updateActiveDocument(docId);
    res.fold(
      (failure) => errorUpdater(failure),
      (status) => activeDocumentIsUpdated = status,
    );
    setState(StoreState.loaded);
  }
}
