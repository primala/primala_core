// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/gyroscopic/presentation/presentation.dart';
import 'package:nokhte/app/core/modules/gyroscopic/types/types.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/beach_widgets/shared/shared.dart';
import 'package:nokhte/app/core/widgets/smart_fading_animated_text/stack/constants/constants.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/presentation/mobx/main/main.dart';
import 'package:nokhte/app/modules/home/types/types.dart';
import 'package:simple_animations/simple_animations.dart';

part 'home_screen_coordinator_store.g.dart';

class HomeScreenCoordinatorStore = _HomeScreenCoordinatorStoreBase
    with _$HomeScreenCoordinatorStore;

abstract class _HomeScreenCoordinatorStoreBase extends BaseCoordinator
    with Store {
  final PortalAPI portalAPI;
  final NewBeachWavesStore newBeachWave;
  final SwipeDetector swipe;
  final HoldDetector hold;
  final GetExistingCollaborationsInfoStore getExistingCollaborationInfo;
  final GesturePillStore gesturePillStore;
  final AddNameToDatabaseStore addNameToDatabaseStore;
  final SmartFadingAnimatedTextTrackerStore fadingTextStateTrackerStore;
  final GetCollaboratorPhraseStore getCollaboratorPhraseStore;

  _HomeScreenCoordinatorStoreBase({
    required this.newBeachWave,
    required this.getExistingCollaborationInfo,
    required this.swipe,
    required this.hold,
    required this.portalAPI,
    required this.gesturePillStore,
    required this.addNameToDatabaseStore,
    required this.fadingTextStateTrackerStore,
    required this.getCollaboratorPhraseStore,
  });

  @observable
  int placesYouCanGoCount = 0;

  @action
  incrementPlacesYouCanGoCount() => placesYouCanGoCount++;

  @observable
  PlacesYouCanGo thePlaceTheyAreGoing = PlacesYouCanGo.initial;

  @action
  homeScreenConstructorCallback() async {
    // beachWaves.setControl(Control.mirror);
    newBeachWave.setMovieMode(BeachWaveMovieModes.onShore);
    beachWavesListener();
    gesturePillStore
        .setPillMovie(BottomCircleGoesUp.getMovie(firstGradientColors: [
      const Color(0xFF41D2F8),
      const Color(0xFF69E9BC),
    ], secondGradientColors: [
      const Color(0xFF41D2F8),
      const Color(0xFF69E9BC),
    ]));

    gestureListener();
    holdListener();
    await getExistingCollaborationInfo(NoParams());
    Duration fadeInDuration;
    await addNameToDatabaseStore(NoParams());
    await getCollaboratorPhraseStore(NoParams());

    getExistingCollaborationInfo.hasACollaboration
        ? {
            fadeInDuration = Seconds.get(10),
            fadingTextStateTrackerStore.setMessagesData(
              MessagesData.hasACollaboratorHomeList,
            ),
            fadingTextStateTrackerStore.setMainMessage(
              index: 1,
              thePhrase: getCollaboratorPhraseStore.collaboratorPhrase,
            )
          }
        : {
            fadeInDuration = Seconds.get(3),
            fadingTextStateTrackerStore.setMessagesData(
              MessagesData.homeList,
            ),
            fadingTextStateTrackerStore.setMainMessage(
              index: 2,
              thePhrase: getCollaboratorPhraseStore.collaboratorPhrase,
            )
          };
    fadingTextStateTrackerStore.startRotatingText(fadeInDuration);
    await portalAPI.setupTheStream();
    portalAPIListener();
  }

  @action
  portalAPIListener() => reaction((p0) => portalAPI.drawingMode, (p0) async {
        if (p0 == DrawingStatus.hasDrawn &&
            getExistingCollaborationInfo.hasDonePerspectives &&
            getExistingCollaborationInfo.hasCommittedAPurpose) {
          await Haptics.vibrate(HapticsType.medium);
          fadeTheTextOutAndWaterComesDown(PlacesYouCanGo.individualSession);
        }
      });

  @observable
  bool isNavigating = false;

  @action
  toggleIsNavigating() => isNavigating = !isNavigating;

  beachWavesListener() => reaction((p0) => newBeachWave.movieStatus, (p0) {
        if (newBeachWave.movieStatus == MovieStatus.finished &&
            newBeachWave.movieMode == BeachWaveMovieModes.onShoreToOceanDive) {
          switch (thePlaceTheyAreGoing) {
            case PlacesYouCanGo.newCollaboration:
              // Modular.to.navigate('/p2p_collaborator_pool/');
              Modular.to.navigate('/p2p_purpose_session/');
            case PlacesYouCanGo.collectiveSession:
              Modular.to.navigate('/collective_session/');
            case PlacesYouCanGo.individualSession:
              Modular.to.navigate('/individual_session/');
            case PlacesYouCanGo.perspectivesSession:
              Modular.to.navigate('/p2p_perspective_session/');
            default:
              break;
          }
        }
      });

  @action
  gestureListener() => reaction((p0) => swipe.directionsType, (p0) {
        print("$p0");
        if (isAllowedMakeANavigation) {
          // todo make this more specific so this doesn't trigger if no purpose is ocmmitted
          switch (p0) {
            case GestureDirections.up:
              if (getExistingCollaborationInfo.hasCommittedAPurpose) {
                final thePlaceTheyAreGoing =
                    getExistingCollaborationInfo.hasDonePerspectives
                        ? PlacesYouCanGo.collectiveSession
                        : PlacesYouCanGo.perspectivesSession;
                fadeTheTextOutAndWaterComesDown(thePlaceTheyAreGoing);
              }
            default:
              break;
          }
          incrementPlacesYouCanGoCount();
        }
      });

  @action
  holdListener() => reaction((p0) => hold.holdCount, (p0) async {
        print("$p0");
        if (isAllowedMakeANavigation) {
          await Haptics.vibrate(HapticsType.medium);
          fadeTheTextOutAndWaterComesDown(PlacesYouCanGo.newCollaboration);
          incrementPlacesYouCanGoCount();
        }
      });

  @action
  fadeTheTextOutAndWaterComesDown(PlacesYouCanGo thePlaceTheyAreGoingParam) {
    thePlaceTheyAreGoing = thePlaceTheyAreGoingParam;
    if (!fadingTextStateTrackerStore.isPaused) {
      fadingTextStateTrackerStore.togglePause();
    }
    if (newBeachWave.movieStatus != MovieStatus.inProgress) {
      gesturePillStore.setPillAnimationControl(Control.play);
      fadingTextStateTrackerStore.currentMainText = "";
      fadingTextStateTrackerStore.currentSubText = "";
      newBeachWave.setMovieMode(BeachWaveMovieModes.onShoreToOceanDiveSetup);
    }
  }

  @computed
  bool get isAllowedMakeANavigation => placesYouCanGoCount == 0;

  @override
  List<Object> get props => [];
}
