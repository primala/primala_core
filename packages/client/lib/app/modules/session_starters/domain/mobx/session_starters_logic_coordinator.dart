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
  final CancelSessionActivationStream cancelStreamLogic;
  final InitializeSession initializeSessionLogic;
  final JoinSession joinSessionLogic;
  final NukeSession nukeSessionLogic;
  final ListenToSessionActivationStatus listenToSessionActivationLogic;

  _SessionStartersLogicCoordinatorBase({
    required this.cancelStreamLogic,
    required this.initializeSessionLogic,
    required this.joinSessionLogic,
    required this.nukeSessionLogic,
    required this.listenToSessionActivationLogic,
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
    nokhteSessionSearchStatusIsListening = cancelStreamLogic(const NoParams());
    await collaboratorSearchStatus.close();
    await searchSubscription.cancel();
  }

  @action
  listenToSessionActivation() async {
    nokhteSessionSearchStatusIsListening = true;
    final result = await listenToSessionActivationLogic(const NoParams());
    result.fold((failure) => errorUpdater(failure), (stream) {
      nokhteSearchStatus = ObservableStream(stream);
      nokhteSubscription = nokhteSearchStatus.listen((value) {
        hasFoundNokhteSession = value;
      });
    });
  }

  @action
  initialize({
    Either<NoParams, PresetTypes> params = const Left(NoParams()),
  }) async {
    final result = await initializeSessionLogic(params);
    result.fold((failure) => errorUpdater(failure),
        (entryStatus) => hasJoined = entryStatus);
  }

  @action
  join(String collaboratorUID) async {
    final result = await joinSessionLogic(collaboratorUID);
    result.fold((failure) => errorUpdater(failure),
        (entryStatus) => hasJoined = entryStatus);
  }

  @action
  nuke() async {
    hasJoined = false;
    final result = await nukeSessionLogic(const NoParams());
    result.fold((failure) => errorUpdater(failure),
        (nukeStatus) => hasNuked = nukeStatus);
  }
}
