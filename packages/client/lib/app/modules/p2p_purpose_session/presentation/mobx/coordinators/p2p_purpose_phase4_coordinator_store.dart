// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:equatable/equatable.dart';
import 'package:nokhte/app/core/modules/solo_doc/domain/domain.dart';
import 'package:nokhte/app/core/modules/solo_doc/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/beach_widgets/shared/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
part 'p2p_purpose_phase4_coordinator_store.g.dart';

class P2PPurposePhase4CoordinatorStore = _P2PPurposePhase4CoordinatorStoreBase
    with _$P2PPurposePhase4CoordinatorStore;

abstract class _P2PPurposePhase4CoordinatorStoreBase extends Equatable
    with Store {
  final SmartFadingAnimatedTextTrackerStore fadingText;
  final BeachWavesTrackerStore beachWaves;
  final SoloDocCoordinatorStore soloDoc;
  final SwipeDetector swipe;

  _P2PPurposePhase4CoordinatorStoreBase({
    required this.swipe,
    required this.beachWaves,
    required this.fadingText,
    required this.soloDoc,
  }) {
    reaction((p0) => beachWaves.movieStatus, (p0) {
      if (beachWaves.movieStatus == MovieStatus.finished &&
          beachWaves.movieMode == BeachWaveMovieModes.timesUp) {
        beachWaves.teeUpBackToTheDepths();
        beachWaves.backToTheDepthsCount++;
      } else if (beachWaves.movieStatus == MovieStatus.finished &&
          beachWaves.movieMode == BeachWaveMovieModes.backToTheDepths) {
        fadingText.fadeTheTextOut();
        Modular.to.navigate('/p2p_purpose_session/phase-5/');
      }
    });
  }

  @action
  screenConstructor() async {
    beachWaves.initiateSuspendedAtTheDepths();

    fadingText.moveToNextMessage();
    fadingText.fadeTheTextIn();
    await soloDoc
        .getSoloDoc(
          const GetSoloDocParams(
            getCollaboratorsDoc: true,
          ),
        )
        .then((value) => Future.delayed(Seconds.get(2), () {
              fadingText.togglePause();
              beachWaves.initiateTimesUp(
                timerLength: const Duration(
                  seconds: 10,
                  // minutes: 5,
                  // TODO COMMENT OUT FOR PROD
                ),
                // pMovieMode: MovieModes.purposeCallTimesUp,
              );
            }));
    fadingText.setMainMessage(
      index: 4,
      thePhrase: soloDoc.getSoloDoc.docContent,
    );
  }

  @override
  List<Object> get props => [];
}
