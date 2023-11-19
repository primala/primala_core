// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:equatable/equatable.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/modules/timer/domain/logic/logic.dart';
import 'package:nokhte/app/core/modules/timer/presentation/presentation.dart';
import 'package:nokhte/app/core/modules/voice_call/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/beach_widgets/shared/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';
part 'p2p_purpose_phase2_coordinator_store.g.dart';

class P2PPurposePhase2CoordinatorStore = _P2PPurposePhase2CoordinatorStoreBase
    with _$P2PPurposePhase2CoordinatorStore;

abstract class _P2PPurposePhase2CoordinatorStoreBase extends Equatable
    with Store {
  final TimerCoordinator timer;
  final AgoraCallbacksStore agoraCallbacksStore;
  final VoiceCallActionsStore voiceCallActionsStore;
  final CheckIfUserHasTheQuestionStore questionCheckerStore;
  final BeachWavesTrackerStore beachWaves;
  final SmartFadingAnimatedTextTrackerStore fadingText;
  final MeshCircleButtonStore meshCircleStore;
  final SwipeDetector swipe;
  final HoldDetector hold;

  @observable
  bool isFirstTimeTalking = true;

  @observable
  bool isFirstTimeStartingMovie = true;

  @action
  screenConstructor() async {
    beachWaves.initiateSuspendedAtTheDepths();
    holdStartListener();
    await timer.setupAndStreamListenerActivation(
        const CreateTimerParams(timerLengthInMinutes: 5), initOrPauseTimesUp);

    holdEndListener();
    meshCircleStore.widgetConstructor();
    await fadingText
        .oneSecondDelay(() async => await fadingText.fadeTheTextIn());
    await questionCheckerStore(NoParams()).then((_) {
      fadingText.setMainMessage(
        index: 1,
        thePhrase: questionCheckerStore.hasTheQuestion
            ? "Ask: What Could We Collectively Create?"
            : "Wait For Your Collaborator To Start The Conversation",
      );
    }).then((value) => Future.delayed(Seconds.get(1), () {
          fadingText.togglePause();
        }));
  }

  _P2PPurposePhase2CoordinatorStoreBase({
    required this.timer,
    required this.swipe,
    required this.hold,
    required this.agoraCallbacksStore,
    required this.questionCheckerStore,
    required this.voiceCallActionsStore,
    required this.beachWaves,
    required this.fadingText,
    required this.meshCircleStore,
  }) {
    reaction((p0) => beachWaves.movieMode, (p0) {
      if (beachWaves.movieMode == BeachWaveMovieModes.backToTheDepthsSetup) {
        meshCircleStore.toggleWidgetVisibility();
      }
    });
    reaction((p0) => beachWaves.movieStatus, (p0) async {
      if (beachWaves.movieStatus == MovieStatus.finished &&
          beachWaves.movieMode == BeachWaveMovieModes.timesUp) {
        beachWaves.teeUpBackToTheDepths();
        beachWaves.backToTheDepthsCount++;
      } else if (beachWaves.movieStatus == MovieStatus.finished &&
          beachWaves.movieMode == BeachWaveMovieModes.backToTheDepths) {
        await voiceCallActionsStore.enterOrLeaveCall(Left(NoParams()));
        meshCircleStore.toggleWidgetVisibility();
        Modular.to.navigate('/p2p_purpose_session/phase-3/');
      }
    });
  }

  holdStartListener() => reaction((p0) => hold.holdCount, (p0) {
        audioButtonHoldStartCallback();
      });

  holdEndListener() => reaction((p0) => hold.letGoCount, (p0) {
        audioButtonHoldEndCallback();
      });

  @action
  initOrPauseTimesUp(bool shouldRun) {
    if (shouldRun) {
      if (isFirstTimeStartingMovie) {
        final Duration timerLength =
            kDebugMode ? Seconds.get(20) : const Duration(minutes: 5);
        beachWaves.initiateTimesUp(timerLength: timerLength);
        isFirstTimeStartingMovie = false;
      } else {
        beachWaves.setControl(Control.play);
      }
    } else {
      beachWaves.setControl(Control.stop);
    }
  }

  @action
  audioButtonHoldStartCallback() async {
    await timer.updateTimerRunningStatus(true);

    if (fadingText.currentIndex == 1 && fadingText.showText) {
      Future.delayed(Seconds.get(10), () => fadingText.fadeTheTextOut());
    }

    voiceCallActionsStore.muteOrUnmuteAudio(wantToMute: false);
    meshCircleStore.toggleColorAnimation();
  }

  @action
  audioButtonHoldEndCallback() {
    voiceCallActionsStore.muteOrUnmuteAudio(wantToMute: true);
    meshCircleStore.toggleColorAnimation();
  }

  @override
  List<Object> get props => [];
}
