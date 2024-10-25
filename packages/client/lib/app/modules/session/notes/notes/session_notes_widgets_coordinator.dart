// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
part 'session_notes_widgets_coordinator.g.dart';

class SessionNotesWidgetsCoordinator = _SessionNotesWidgetsCoordinatorBase
    with _$SessionNotesWidgetsCoordinator;

abstract class _SessionNotesWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator, Reactions {
  final BeachWavesStore beachWaves;
  final TextEditorStore textEditor;
  final SmartTextStore smartText;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;

  _SessionNotesWidgetsCoordinatorBase({
    required this.beachWaves,
    required this.wifiDisconnectOverlay,
    required this.textEditor,
    required this.smartText,
  }) {
    initBaseWidgetsCoordinatorActions();
  }

  @observable
  bool canSwipeUp = true;

  @observable
  bool showSubmitText = false;

  @observable
  String lastSubmittedText = '';

  @observable
  int inactivityCount = 0;

  @observable
  PresetTypes presetType = PresetTypes.none;

  @action
  setPresetType(PresetTypes type) {
    presetType = type;
  }

  constructor({required Function onEarlyReturn}) {
    smartText.setMessagesData(SessionLists.notesPrimary);
    smartText.setWidgetVisibility(false);
    smartText.startRotatingText();
    beachWaves.setMovieMode(BeachWaveMovieModes.skyToHalfAndHalf);
    textEditor.initFadeIn();

    textEditor.focusNode.addListener(() {
      hybridTextEditorListener();
    });
    Timer(Seconds.get(9, milli: 500), () async {
      if (inactivityCount == 0) {
        textEditor.setWidgetVisibility(false);
        afterSwipeUp(includeTimer: false);
        await onEarlyReturn();
      }
    });
    disposers.add(beachWavesMovieStatusReactor());
  }

  @action
  onCollaboratorLeft() {
    textEditor.setWidgetVisibility(false);
    smartText.setWidgetVisibility(false);
  }

  @action
  onCollaboratorJoined() {
    textEditor.setWidgetVisibility(true);
    smartText.setWidgetVisibility(smartText.pastShowWidget);
  }

  @action
  regularTextEditorListener() {
    inactivityCount++;
    if (!textEditor.focusNode.hasFocus) {
      if (textEditor.controller.text.length != (0)) {
        smartText.setWidgetVisibility(true);
      }
    } else {
      smartText.setWidgetVisibility(false);
    }
  }

  @action
  hybridTextEditorListener() {
    inactivityCount++;
    if (!textEditor.focusNode.hasFocus) {
      if (textEditor.controller.text.length != (0)) {
        smartText.setWidgetVisibility(true);
      } else {
        textEditor.setWidgetVisibility(false);
        afterSwipeUp();
      }
    } else {
      smartText.setWidgetVisibility(false);
    }
  }

  @action
  onSwipeUp(
    Function(String) onSwipeUp,
  ) async {
    if (canSwipeUp) {
      if (textEditor.controller.text.isNotEmpty &&
          textEditor.controller.text != lastSubmittedText) {
        lastSubmittedText = textEditor.controller.text;
        await onSwipeUp(textEditor.controller.text);
        canSwipeUp = false;
        smartText.setWidgetVisibility(false);
        textEditor.setWidgetVisibility(false);
        afterSwipeUp();
      }
    }
  }

  @action
  onSwipeDown() {
    textEditor.setWidgetVisibility(false);
    Timer(Seconds.get(1), () {
      Modular.to.navigate(SessionConstants.exit);
    });
  }

  @action
  afterSwipeUp({
    bool includeTimer = true,
  }) =>
      Timer(Seconds.get(includeTimer ? 1 : 0), () {
        // if (presetType == PresetTypes.collaborative) {
        textEditor.setWidgetVisibility(false);
        beachWaves.setMovieMode(BeachWaveMovieModes.skyToHalfAndHalf);
        beachWaves.currentStore.initMovie(const NoParams());
        // } else if (presetType == PresetTypes.consultative) {
        //   if (screenType == SessionScreenTypes.notes) {
        //     textEditor.controller.clear();
        //     textEditor.setWidgetVisibility(true);
        //     canSwipeUp = true;
        //   } else {
        //     textEditor.setWidgetVisibility(false);
        //     beachWaves.setMovieMode(
        //       BeachWaveMovieModes.skyToInvertedHalfAndHalf,
        //     );
        //     beachWaves.currentStore.initMovie(NoParams());
        //   }
        // } else {
        //   Modular.to.navigate(SessionConstants.exit);
        // }
      });

  beachWavesMovieStatusReactor() =>
      reaction((p0) => beachWaves.movieStatus, (p0) {
        if (p0 == MovieStatus.finished) {
          if (presetType == PresetTypes.consultative) {
            Modular.to.navigate(SessionConstants.groupHybrid);
          } else if (presetType == PresetTypes.collaborative) {
            Modular.to.navigate(SessionConstants.soloHybrid);
          } else if (presetType == PresetTypes.solo) {
            Modular.to.navigate(SessionConstants.polymorphicSolo);
          }
        }
      });

  deconstructor() {
    dispose();
    textEditor.focusNode.dispose();
    textEditor.controller.dispose();
  }

  // @computed
  // bool get isAImpermanentNotesScreen =>
  //     screenType == SessionScreenTypes.groupHybrid ||
  //     screenType == SessionScreenTypes.soloHybrid;

  // @computed
  // bool get isAPermanentNotesScreen =>
  //     presetType == PresetTypes.consultative &&
  //     screenType == SessionScreenTypes.notes;
}
