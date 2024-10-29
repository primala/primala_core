// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/session_starters/session_starters.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
part 'session_starters_logic_coordinator.g.dart';

class SessionStartersLogicCoordinator = _SessionStartersLogicCoordinatorBase
    with _$SessionStartersLogicCoordinator;

abstract class _SessionStartersLogicCoordinatorBase with Store, BaseMobxLogic {
  final SessionStartersContract contract;

  _SessionStartersLogicCoordinatorBase({
    required this.contract,
  }) {
    initBaseLogicActions();
  }

  @override
  String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (NetworkConnectionFailure):
        return FailureConstants.internetConnectionFailureMsg;
      case const (UserInputFailure):
        return FailureConstants.invalidDeepLinkMsg;
      default:
        return FailureConstants.genericFailureMsg;
    }
  }

  @action
  resetErrorMessage() {
    setErrorMessage("");
  }

  @observable
  bool nokhteSessionSearchStatusIsListening = false;

  @observable
  bool hasJoined = false;

  @observable
  bool hasNuked = false;

  @observable
  bool hasInitialized = false;

  @observable
  bool hasUpdatedSessionType = false;

  @observable
  ObservableStream<bool> collaboratorSearchStatus =
      ObservableStream(const Stream.empty());

  @observable
  ObservableStream<bool> nokhteSearchStatus =
      ObservableStream(const Stream.empty());

  @observable
  bool hasFoundCollaborator = false;

  @observable
  bool hasFoundNokhteSession = false;

  StreamSubscription searchSubscription =
      Stream.value(false).listen((event) {});
  StreamSubscription nokhteSubscription =
      Stream.value(false).listen((event) {});

  @action
  dispose({
    bool shouldNuke = false,
  }) async {
    if (shouldNuke) {
      await nuke();
    }
    nokhteSessionSearchStatusIsListening =
        contract.cancelSessionActivationStream(const NoParams());
    await collaboratorSearchStatus.close();
    await searchSubscription.cancel();
  }

  @action
  listenToSessionActivation() async {
    nokhteSessionSearchStatusIsListening = true;
    final result =
        await contract.listenToSessionActivationStatus(const NoParams());
    result.fold((failure) => errorUpdater(failure), (stream) {
      nokhteSearchStatus = ObservableStream(stream);
      nokhteSubscription = nokhteSearchStatus.listen((value) {
        hasFoundNokhteSession = value;
      });
    });
  }

  @action
  initialize(
    Either<NoParams, PresetTypes> params,
  ) async {
    final result = await contract.initializeSession(const Left(NoParams()));
    result.fold((failure) => errorUpdater(failure),
        (entryStatus) => hasInitialized = entryStatus);
  }

  @action
  updateSessionType(String newPresetUID) async {
    hasUpdatedSessionType = false;
    final result = await contract.updateSessionType(newPresetUID);
    result.fold((failure) => errorUpdater(failure),
        (entryStatus) => hasUpdatedSessionType = entryStatus);
  }

  @action
  join(String collaboratorUID) async {
    final result = await contract.joinSession(collaboratorUID);
    result.fold((failure) => errorUpdater(failure),
        (entryStatus) => hasJoined = entryStatus);
  }

  @action
  nuke() async {
    hasJoined = false;
    final result = await contract.nukeSession(const NoParams());
    result.fold((failure) => errorUpdater(failure),
        (nukeStatus) => hasNuked = nukeStatus);
  }
}
