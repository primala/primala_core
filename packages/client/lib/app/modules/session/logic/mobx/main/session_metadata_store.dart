// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/extensions/extensions.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/presets/presets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
import 'package:nokhte_backend/tables/rt_active_nokhte_sessions.dart';
part 'session_metadata_store.g.dart';

class SessionMetadataStore = _SessionMetadataStoreBase
    with _$SessionMetadataStore;

abstract class _SessionMetadataStoreBase
    with Store, BaseMobxLogic<NoParams, Stream<NokhteSessionMetadata>> {
  final SessionPresenceContract contract;
  final PresetsLogicCoordinator presetsLogic;
  _SessionMetadataStoreBase({
    required this.contract,
    required this.presetsLogic,
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
  ObservableList<NameAndUID> namesAndUIDs = ObservableList.of([]);

  @observable
  String? currentSpeakerUID = '';

  @observable
  bool userIsInSecondarySpeakingSpotlight = false;

  @observable
  ObservableStream<DateTime> time =
      Stream.periodic(Seconds.get(1)).map((_) => DateTime.now()).asObservable();

  @observable
  bool userCanSpeak = false;

  @observable
  ObservableList<double> currentPhases = ObservableList.of([]);

  @observable
  ObservableList<String> content = ObservableList.of([]);

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
  ObservableStream<NokhteSessionMetadata> sessionMetadata =
      ObservableStream(const Stream.empty());

  StreamSubscription streamSubscription =
      const Stream.empty().listen((event) {});

  @action
  resetValues() {
    setState(StoreState.initial);
    presetsLogic.reset();
    currentPhases = ObservableList.of([]);
  }

  @action
  dispose() {
    streamSubscription = const Stream.empty().listen((event) {});
    sessionMetadata = ObservableStream(const Stream.empty());
  }

  @action
  _getStaticMetadata() async {
    final res = await contract.getSTSessionMetadata(const NoParams());
    res.fold((failure) => mapFailureToMessage(failure), (entity) async {
      if (presetsLogic.presetsEntity.uids.isEmpty) {
        userIndex = entity.userIndex;
        namesAndUIDs = ObservableList.of(entity.namesAndUIDs);
        presetUID = entity.presetUID;
        sessionStartTime = entity.createdAt;
        leaderUID = entity.leaderUID;
        await presetsLogic.getCompanyPresets(Right(entity.presetUID));
      }
    });
  }

  @action
  refetchStaticMetadata() async {
    presetsLogic.reset();
    await _getStaticMetadata();
  }

  @action
  Future<void> get(params) async {
    resetValues();
    final result = await contract.listenToRTSessionMetadata(params);
    result.fold(
      (failure) {
        setErrorMessage(mapFailureToMessage(failure));
        setState(StoreState.initial);
      },
      (stream) {
        sessionMetadata = ObservableStream(stream);
        streamSubscription = sessionMetadata.listen((value) async {
          if (value.phases.length != currentPhases.length) {
            await _getStaticMetadata();
          }
          everyoneIsOnline = value.everyoneIsOnline;
          final phases = value.phases.map((e) => double.parse(e.toString()));
          speakingTimerStart = value.speakingTimerStart;
          secondarySpeakerSpotlightIsEmpty = value.secondarySpotlightIsEmpty;
          userIsInSecondarySpeakingSpotlight =
              value.userIsInSecondarySpeakingSpotlight;
          currentSpeakerUID = value.speakerUID;
          final strContent = value.content.map((e) => e.toString());
          // print('strContent: $strContent');
          content = ObservableList.of(strContent);
          // print('content: $content');
          currentPhases = ObservableList.of(phases);
          sessionHasBegun = value.sessionHasBegun;
          userIsSpeaking = value.userIsSpeaking;
          userCanSpeak = value.userCanSpeak;

          setState(StoreState.loaded);
        });
      },
    );
  }

  getUIDFromName(String name) {
    for (var nameAndUID in namesAndUIDs) {
      if (nameAndUID.name == name) {
        return nameAndUID.uid;
      }
    }
  }

  @computed
  bool get canStartTheSession =>
      (currentPhases.every((e) => e >= 1.0) &&
          currentPhases.length.isGreaterThan(1)) ||
      presetType == PresetTypes.solo;

  @computed
  bool get canStartUsingSession =>
      currentPhases.every((e) => e.isGreaterThanOrEqualTo(2));

  @computed
  bool get canExitTheSession => currentPhases.every((e) => e == 3);

  @computed
  bool get canReturnHome =>
      currentPhases.every((e) => e.isGreaterThanOrEqualTo(5));

  @computed
  double get userPhase => currentPhases[userIndex];

  @computed
  int get numberOfAffirmative {
    int count = 0;
    for (double value in currentPhases) {
      if (value == affirmativePhase) {
        count++;
      }
    }
    return count;
  }

  @computed
  String get currentPurpose =>
      content.isEmpty ? 'No purpose yet' : content.last;

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
      for (var nameAndUID in namesAndUIDs) {
        if (nameAndUID.uid == currentSpeakerUID) {
          name = nameAndUID.name.split(' ').first;
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
  int get numberOfCollaborators => currentPhases.length;

  @computed
  bool get someoneIsTakingANote =>
      currentPhases.any((element) => element == 2.5);

  @computed
  List<String> get fullNames {
    final names = <String>[];
    for (int i = 0; i < namesAndUIDs.length; i++) {
      if (i != userIndex) {
        names.add(namesAndUIDs[i].name);
      }
    }

    return names;
  }

  @computed
  CompanyPresetsEntity get presetEntity => presetsLogic.presetsEntity;

  @computed
  SessionScreenTypes get screenType => presetEntity.articles.isEmpty
      ? SessionScreenTypes.none
      : presetEntity.screenTypes.first;

  @computed
  PresetTypes get presetType => presetEntity.articles.isEmpty
      ? PresetTypes.none
      : presetEntity.presets.first;

  @computed
  List<SessionTags> get tags {
    if (presetEntity.tags.isEmpty) {
      return [];
    } else {
      final list = <SessionTags>[];
      for (var section in presetEntity.articles.first.articleSections) {
        list.add(section.tag);
      }
      return list;
    }
  }

  @computed
  PresetArticleEntity get article => presetEntity.articles.first;

  @computed
  List<bool> get canRallyArray {
    final list = <bool>[];
    for (int i = 0; i < currentPhases.length; i++) {
      if (i != userIndex) {
        list.add(currentPhases[i] == 2.0);
      }
    }
    return list;
  }
}
