// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/documents.dart';
import 'package:nokhte_backend/tables/sessions.dart';
part 'session_metadata_store.g.dart';

class SessionMetadataStore = _SessionMetadataStoreBase
    with _$SessionMetadataStore;

abstract class _SessionMetadataStoreBase
    with Store, BaseMobxLogic<NoParams, Stream<SessionMetadata>>, Reactions {
  final SessionPresenceContract contract;
  final DocsContract docsContract;
  final ViewDocCoordinator viewDoc;
  _SessionMetadataStoreBase({
    required this.contract,
    required this.viewDoc,
  }) : docsContract = viewDoc.contract {
    initBaseLogicActions();
  }

  @observable
  bool everyoneIsOnline = false;

  @observable
  bool userIsSpeaking = false;

  @observable
  int sessionId = -1;

  @observable
  ObservableList<SessionUserEntity> collaboratorInformation =
      ObservableList.of([]);

  @observable
  String? currentSpeakerUID = '';

  @observable
  PowerupType currentPowerup = PowerupType.none;

  @observable
  String userUID = '';

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
  ObservableList<int> documentIds = ObservableList.of([]);

  @observable
  ObservableList<DocumentEntity> documents = ObservableList();

  @observable
  int? activeDocument;

  @observable
  int groupId = -1;

  @observable
  DateTime speakingTimerStart = DateTime.fromMillisecondsSinceEpoch(0);

  @observable
  DateTime sessionStartTime = DateTime.fromMillisecondsSinceEpoch(0);

  @observable
  ObservableStream<SessionMetadata> sessionMetadata =
      ObservableStream(const Stream.empty());

  StreamSubscription metadataStreamSubscription =
      const Stream.empty().listen((event) {});

  @observable
  ObservableStream<DocumentEntities> documentsStream =
      ObservableStream(const Stream.empty());

  @observable
  StreamSubscription documentsStreamSubscription =
      const Stream.empty().listen((event) {});

  @override
  @action
  dispose() async {
    super.dispose();
    await viewDoc.dispose();
    metadataStreamSubscription = const Stream.empty().listen((event) {});
    sessionMetadata = ObservableStream(const Stream.empty());
  }

  initReactors() {
    disposers.add(documentsReactor());
    disposers.add(activeDocumentReactor());
  }

  @action
  Future<void> get() async {
    initReactors();
    final result = await contract.listenToSessionMetadata();
    result.fold(
      (failure) {
        setErrorMessage(mapFailureToMessage(failure));
        setState(StoreState.initial);
      },
      (stream) {
        sessionMetadata = ObservableStream(stream);
        metadataStreamSubscription = sessionMetadata.listen((value) async {
          everyoneIsOnline = value.collaborators.every(
            (element) => element.sessionUserStatus != SessionUserStatus.offline,
          );
          userUID = value.userUID;
          final docs = value.documents
              .map((e) => double.parse(e.toString()).toInt())
              .toList();
          documentIds = ObservableList.of(docs);
          activeDocument = value.activeDocument;
          currentPowerup = value.currentPowerup;
          groupId = value.groupId;
          collaboratorInformation = ObservableList.of(value.collaborators);
          speakingTimerStart = value.speakingTimerStart;
          secondarySpeakerSpotlightIsEmpty = value.secondarySpotlightIsEmpty;
          userIsInSecondarySpeakingSpotlight =
              value.userIsInSecondarySpeakingSpotlight;
          currentSpeakerUID = value.speakerUID;
          sessionHasBegun = value.sessionStatus == SessionStatus.started;
          userIsSpeaking = value.userIsSpeaking;
          userCanSpeak = value.userCanSpeak;
          sessionId = value.sessionId;
          setState(StoreState.loaded);
        });
      },
    );
  }

  documentsReactor() => reaction((p0) => documentIds, (p0) async {
        if (documentIds.isEmpty) return;
        await listenToSpecificDocuments(documentIds);
      });

  activeDocumentReactor() => reaction((p0) => activeDocument, (p0) async {
        if (activeDocument == null) return;
        await listenToActiveDocumentContent();
      });

  @action
  listenToActiveDocumentContent() async {
    if (activeDocument != null) {
      await viewDoc.constructor(activeDoc);
    }
  }

  @action
  listenToSpecificDocuments(List<int> documentIds) async {
    final res = await docsContract.listenToSpecificDocuments(
      documentIds,
    );
    res.fold((failure) {}, (stream) {
      documentsStream = ObservableStream(stream);
      documentsStreamSubscription = documentsStream.listen((event) async {
        documents = ObservableList.of(event);
        viewDoc.constructor(activeDoc);
      });
    });
  }

  @computed
  DocumentEntity get activeDoc {
    if (activeDocument != null) {
      return documents.firstWhere((element) => element.id == activeDocument);
    } else {
      return DocumentEntity.initial();
    }
  }

  @computed
  bool get canStartTheSession =>
      collaboratorStatuses
          .every((element) => element == SessionUserStatus.readyToStart) &&
      collaboratorStatuses.length > 1;

  @computed
  bool get canStartUsingSession => collaboratorStatuses
      .every((element) => element == SessionUserStatus.online);

  @computed
  bool get canExitTheSession => collaboratorStatuses
      .every((element) => element == SessionUserStatus.readyToLeave);

  @computed
  bool get canStillAbort => numberOfCollaborators == 1;

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
  int get userIndex {
    int index = -1;
    for (int i = 0; i < collaboratorInformation.length; i++) {
      if (collaboratorInformation[i].uid == userUID) {
        index = i;
      }
    }
    return index;
  }

  @computed
  List<SessionUserEntity> get collaboratorsMinusUser {
    final temp = <SessionUserEntity>[];
    for (int i = 0; i < collaboratorInformation.length; i++) {
      if (collaboratorInformation[i].uid != userUID) {
        temp.add(collaboratorInformation[i]);
      }
    }
    return temp;
  }

  @computed
  List<SessionUserStatus> get collaboratorStatuses {
    final statuses = <SessionUserStatus>[];
    for (int i = 0; i < collaboratorInformation.length; i++) {
      statuses.add(collaboratorInformation[i].sessionUserStatus);
    }
    return statuses;
  }
}
