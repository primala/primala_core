// ignore_for_file: must_be_immutable, library_private_types_in_public_api
// * Mobx Import
// import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
// * Equatable Import
import 'package:equatable/equatable.dart';
import 'package:primala/app/core/types/types.dart';
import 'package:primala/app/core/widgets/mobx/all_custom_widgets_tracker_store.dart';
// import 'package:primala/app/core/widgets/beach_waves/stack/constants/types/types.dart';
import 'package:primala/app/core/widgets/widget_constants.dart';
import 'package:primala/app/core/widgets/widgets.dart';
// import 'package:primala/app/core/widgets/widgets.dart';
// import 'package:primala/app/core/widgets/widgets.dart';
import './sub_stores/sub_stores.dart';
import 'package:primala/app/modules/p2p_collaborator_pool/domain/logic/validate_query.dart';
// * Mobx Codegen Inclusion
part 'speak_the_collaborator_phrase_coordinator_store.g.dart';

class SpeakTheCollaboratorPhraseCoordinatorStore = _SpeakTheCollaboratorPhraseCoordinatorStoreBase
    with _$SpeakTheCollaboratorPhraseCoordinatorStore;

abstract class _SpeakTheCollaboratorPhraseCoordinatorStoreBase extends Equatable
    with Store {
  final AllCustomWidgetsTrackerStore widgetStore;
  final SpeechToTextStore speechToTextStore;
  final OnSpeechResultStore onSpeechResultStore;
  final ValidateQueryStore validateQueryStore;
  final EnterCollaboratorPoolStore enterCollaboratorPoolStore;
  late BeachWavesTrackerStore beachWavesStore;
  late BreathingPentagonsStateTrackerStore breathingPentagonsStore;
  late SmartFadingAnimatedTextTrackerStore fadingTextStore;

  @observable
  bool isReadyToEnterPool = false;

  _SpeakTheCollaboratorPhraseCoordinatorStoreBase({
    required this.widgetStore,
    required this.speechToTextStore,
    required this.onSpeechResultStore,
    required this.validateQueryStore,
    required this.enterCollaboratorPoolStore,
  }) {
    beachWavesStore = widgetStore.beachWavesStore;
    fadingTextStore = widgetStore.smartFadingAnimatedTextStore;
    breathingPentagonsStore = widgetStore.breathingPentagonsStore;
    reaction((p0) => onSpeechResultStore.currentPhraseIndex, (p0) {
      fadingTextStore.togglePause(gestureType: Gestures.none);
      fadingTextStore.addNewMessage(
        mainMessage: onSpeechResultStore.currentSpeechResult,
      );
      validateQueryStore.validateTheLength(
        inputString: onSpeechResultStore.currentSpeechResult,
      );
    });
    reaction((p0) => validateQueryStore.isProperLength, (p0) {
      if (validateQueryStore.isProperLength == ValidationStatus.invalid) {
        fadingTextStore.changeFutureSubMessage(
          amountOfMessagesForward:
              onSpeechResultStore.currentPhraseIndex == 1 ? 2 : 1,
          message: "invalid length collaborator phrase",
        );
      } else if (validateQueryStore.isProperLength == ValidationStatus.valid) {
        validateQueryStore.call(
          ValidateQueryParams(
            query: onSpeechResultStore.currentSpeechResult,
          ),
        );
      }
    });
    reaction((p0) => validateQueryStore.isValidated, (p0) {
      if (validateQueryStore.isValidated == ValidationStatus.valid &&
          validateQueryStore.isProperLength == ValidationStatus.valid) {
        fadingTextStore.changeFutureSubMessage(
          amountOfMessagesForward:
              onSpeechResultStore.currentPhraseIndex == 1 ? 2 : 1,
          message: "Swipe Up To Enter",
        );
      } else if (validateQueryStore.isValidated == ValidationStatus.invalid &&
          validateQueryStore.isProperLength == ValidationStatus.valid) {
        fadingTextStore.changeFutureSubMessage(
          amountOfMessagesForward:
              onSpeechResultStore.currentPhraseIndex == 1 ? 2 : 1,
          message: "invalid collaborator phrase",
        );
      }
    });
  }

  @action
  breathingPentagonsHoldStartCallback() {
    validateQueryStore.resetCheckerFields();
    breathingPentagonsStore.gestureFunctionRouter();
    speechToTextStore.startListening();
  }

  @action
  breathingPentagonsHoldEndCallback() {
    breathingPentagonsStore.gestureFunctionRouter();
    Future.delayed(const Duration(milliseconds: 500), () {
      speechToTextStore.stopListening();
    }).then((value) => onSpeechResultStore.currentPhraseIndex++);
  }

  @action
  swipeDownCallback() {
    widgetStore.backToShoreWidgetChanges();
  }

  @action
  swipeUpCallback() {
    if (validateQueryStore.isValidated == ValidationStatus.valid) {
      enterCollaboratorPoolStore(validateQueryStore.phraseIDs);
      enterCollaboratorPoolStore(validateQueryStore.phraseIDs);
      widgetStore.toTheDepthsWidgetChanges();
    }
  }

  screenConstructorCallback({
    required SpeakTheCollaboratorPhraseCoordinatorStore coordinatorStore,
  }) {
    coordinatorStore.speechToTextStore.initSpeech();
    if (!fadingTextStore.showText && !fadingTextStore.firstTime) {
      fadingTextStore.resetToDefault();
    }

    beachWavesStore.initiateSuspendedAtSea();
  }

  @override
  List<Object> get props => [];
}
