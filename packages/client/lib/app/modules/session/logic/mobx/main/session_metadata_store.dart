// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/session_content.dart';
import 'package:nokhte_backend/tables/session_information.dart';
part 'session_metadata_store.g.dart';

class SessionMetadataStore = _SessionMetadataStoreBase
    with _$SessionMetadataStore;

abstract class _SessionMetadataStoreBase
    with Store, BaseMobxLogic<NoParams, Stream<SessionMetadata>> {
  final SessionPresenceContract contract;
  _SessionMetadataStoreBase({
    required this.contract,
  }) {
    initBaseLogicActions();
  }

  @observable
  int userIndex = 0;

  @observable
  bool everyoneIsOnline = false;

  @observable
  bool userIsSpeaking = false;

  @observable
  String userUID = '';

  @observable
  String sessionUID = '';

  @observable
  ObservableList<SessionUserInfoEntity> collaboratorInformation =
      ObservableList.of([]);

  @observable
  ObservableList<ContentBlock> content = ObservableList.of([]);

  @observable
  String? currentSpeakerUID = '';

  @observable
  String groupUID = '';

  @observable
  String queueUID = '';

  @observable
  bool userIsInSecondarySpeakingSpotlight = false;

  @observable
  ObservableStream<DateTime> time =
      Stream.periodic(Seconds.get(1)).map((_) => DateTime.now()).asObservable();

  @observable
  bool userCanSpeak = false;

  @observable
  bool secondarySpeakerSpotlightIsEmpty = false;

  @observable
  bool sessionHasBegun = false;

  @observable
  double affirmativePhase = -1.0;

  @observable
  String leaderUID = '';

  @observable
  String presetUID = '';

  @observable
  DateTime speakingTimerStart = DateTime.fromMillisecondsSinceEpoch(0);

  @observable
  DateTime sessionStartTime = DateTime.fromMillisecondsSinceEpoch(0);

  @observable
  SessionInstructionTypes instructionType = SessionInstructionTypes.initial;

  @action
  setAffirmativePhase(double value) => affirmativePhase = value;

  @observable
  ObservableStream<SessionMetadata> sessionMetadata =
      ObservableStream(const Stream.empty());

  StreamSubscription metadataStreamSubscription =
      const Stream.empty().listen((event) {});

  @action
  dispose() {
    metadataStreamSubscription = const Stream.empty().listen((event) {});
    sessionMetadata = ObservableStream(const Stream.empty());
  }

  @action
  Future<void> get() async {
    final result = await contract.listenToSessionMetadata();
    result.fold(
      (failure) {
        setErrorMessage(mapFailureToMessage(failure));
        setState(StoreState.initial);
      },
      (stream) {
        sessionMetadata = ObservableStream(stream);
        metadataStreamSubscription = sessionMetadata.listen((value) async {
          everyoneIsOnline = value.collaboratorInformation.every(
            (element) => element.sessionUserStatus != SessionUserStatus.offline,
          );
          collaboratorInformation =
              ObservableList.of(value.collaboratorInformation);
          speakingTimerStart = value.speakingTimerStart;
          secondarySpeakerSpotlightIsEmpty = value.secondarySpotlightIsEmpty;
          userIsInSecondarySpeakingSpotlight =
              value.userIsInSecondarySpeakingSpotlight;
          currentSpeakerUID = value.speakerUID;
          sessionHasBegun = value.sessionStatus == SessionStatus.started;
          userIsSpeaking = value.userIsSpeaking;
          userCanSpeak = value.userCanSpeak;
          sessionUID = value.sessionUID;

          setState(StoreState.loaded);
        });
      },
    );
  }

  getUIDFromName(String name) {
    for (var collaborator in collaboratorInformation) {
      if (collaborator.fullName == name) {
        return collaborator.uid;
      }
    }
  }

  @computed
  bool get canStartTheSession => collaboratorStatuses
      .every((element) => element == SessionUserStatus.readyToStart);

  @computed
  bool get canStartUsingSession => collaboratorStatuses
      .every((element) => element == SessionUserStatus.online);

  @computed
  bool get canExitTheSession => collaboratorStatuses
      .every((element) => element == SessionUserStatus.readyToLeave);

  @computed
  String get currentPurpose =>
      content.isEmpty ? 'No purpose yet' : content.last.content;

  @computed
  bool get canStillAbort => numberOfCollaborators == 1;

  @computed
  String get currentGroup =>
      groupUID.isEmpty ? 'No group selected' : 'Group: $groupUID';

  @computed
  String get currentQueue =>
      queueUID.isEmpty ? 'No queue selected' : 'Queue: $queueUID';

  @computed
  DateTime get now => time.value ?? DateTime.now();

  @computed
  int get speakingLength =>
      speakingTimerStart != DateTime.fromMillisecondsSinceEpoch(0)
          ? now.difference(speakingTimerStart).inSeconds
          : 0;

  @computed
  GlowColor get glowColor {
    if (userCanSpeak) {
      return GlowColor.transparent;
    } else {
      if (speakingLength <= 62) {
        return GlowColor.green;
      } else if (speakingLength > 62 && speakingLength <= 90) {
        return GlowColor.yellow;
      } else if (speakingLength > 90 && speakingLength < 107) {
        return GlowColor.red;
      } else {
        return GlowColor.inflectionRed;
      }
    }
  }

  @computed
  String get currentSpeakerFirstName {
    if (currentSpeakerUID != null) {
      String name = '';
      for (var collaborator in collaboratorInformation) {
        if (collaborator.uid == currentSpeakerUID) {
          name = collaborator.fullName.split(' ').first;
        }
      }
      return name;
    } else {
      return '';
    }
  }

  @computed
  bool get isCooking => !secondarySpeakerSpotlightIsEmpty && userIsSpeaking;

  @computed
  bool get isBeingRalliedWith =>
      userIsInSecondarySpeakingSpotlight && !userIsSpeaking;

  @computed
  bool get showLetEmCook =>
      !userIsSpeaking &&
      secondarySpeakerSpotlightIsEmpty &&
      glowColor != GlowColor.green;

  @computed
  int get numberOfCollaborators => collaboratorInformation.length;

  @computed
  bool get canStillLeave => collaboratorInformation.length < 2;

  @computed
  List<String> get fullNames {
    final names = <String>[];
    for (int i = 0; i < collaboratorInformation.length; i++) {
      if (i != userIndex) {
        names.add(collaboratorInformation[i].fullName);
      }
    }
    return names;
  }

  @computed
  List<String> get collaboratorUIDs {
    final uids = <String>[];
    for (int i = 0; i < collaboratorInformation.length; i++) {
      if (i != userIndex) {
        uids.add(collaboratorInformation[i].uid);
      }
    }
    return uids;
  }

  @computed
  List<SessionUserStatus> get collaboratorStatuses {
    final statuses = <SessionUserStatus>[];
    for (int i = 0; i < collaboratorInformation.length; i++) {
      if (i != userIndex) {
        statuses.add(collaboratorInformation[i].sessionUserStatus);
      }
    }
    return statuses;
  }
}
