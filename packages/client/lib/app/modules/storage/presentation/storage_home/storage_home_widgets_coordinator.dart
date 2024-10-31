// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/shared/mobx/home_navigation.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'storage_home_widgets_coordinator.g.dart';

class StorageHomeWidgetsCoordinator = _StorageHomeWidgetsCoordinatorBase
    with _$StorageHomeWidgetsCoordinator;

abstract class _StorageHomeWidgetsCoordinatorBase
    with
        Store,
        SmartTextPaddingAdjuster,
        BaseWidgetsCoordinator,
        NokhteWidgetsUtils,
        SwipeNavigationUtils,
        Reactions,
        HomeNavigation {
  final BeachWavesStore beachWaves;
  final GestureCrossStore gestureCross;
  final SessionCardStore sessionCard;
  final SmartTextStore primarySmartText;
  final SmartTextStore secondarySmartText;
  @override
  final CenterNokhteStore centerNokhte;
  @override
  final AuxiliaryNokhteStore homeNokhte;
  @override
  final List<AuxiliaryNokhteStore> auxNokhtes;

  @override
  final SwipeGuideStore swipeGuide;
  final NokhteBlurStore blur;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;
  _StorageHomeWidgetsCoordinatorBase({
    required this.wifiDisconnectOverlay,
    required this.beachWaves,
    required this.gestureCross,
    required this.swipeGuide,
    required this.primarySmartText,
    required this.secondarySmartText,
    required this.sessionCard,
    required this.centerNokhte,
    required this.homeNokhte,
    required this.blur,
  }) : auxNokhtes = [homeNokhte] {
    initBaseWidgetsCoordinatorActions();
    initSmartTextActions();
    initSwipeNavigationUtils();
    initNokhteWidgetsUtils();
  }

  @action
  constructor() {
    sessionCard.initFadeIn();
    homeNokhte.setAndFadeIn(
      AuxiliaryNokhtePositions.left,
      AuxiliaryNokhteColorways.beachWave,
    );
    primarySmartText.setMessagesData(StorageLists.homeHeader);
    setSmartTextBottomPaddingScalar(0);
    setSmartTextTopPaddingScalar(.15);
    secondarySmartText.setMessagesData(StorageLists.homeSecondary);
    secondarySmartText.startRotatingText();
    primarySmartText.startRotatingText();
    beachWaves.setMovieMode(BeachWaveMovieModes.skyToHalfAndHalf);
    gestureCross.cross.initStaticGlow();
    gestureCross.fadeInTheCross();
    centerNokhte.fadeIn();
    homeNokhte.setAndFadeIn(
      AuxiliaryNokhtePositions.left,
      AuxiliaryNokhteColorways.beachWave,
    );

    initReactors();
  }

  initReactors() {
    // disposers.add(centerCrossNokhteReactor());
    disposers.add(gestureCrossTapReactor());
    disposers.add(centerNokhteReactor());
    initHomeNavigationReactions();
  }

  @observable
  bool canTapOnGestureCross = true;

  @observable
  bool canTap = false;

  @action
  onSwipeLeft() {
    if (!isDisconnected && isAllowedToMakeGesture()) {
      if (hasInitiatedBlur && !hasSwiped()) {
        setSwipeDirection(GestureDirections.left);
        swipeGuide.setWidgetVisibility(false);
        centerNokhte.initMovie(AuxiliaryNokhtePositions.left);
      }
    }
  }

  @action
  onTap() {
    if (isAllowedToInteract) {
      if (canTap) {
        canTap = false;
        setSwipeDirection(GestureDirections.initial);
        setHasInitiatedBlur(false);
        secondarySmartText.startRotatingText(isResuming: true);
        centerNokhte.moveBackToCross();
        sessionCard.setDisableTouchInput(false);
        homeNokhte.initMovie(
          NokhteScaleState.shrink,
        );
        blur.reverse();
      } else if (hasInitiatedBlur && !hasSwiped()) {
        dismissNokhte();
      }
    }
  }

  @action
  onGestureCrossTap() {
    if (isAllowedToInteract) {
      if (!hasInitiatedBlur &&
          canTapOnGestureCross &&
          beachWaves.movieMode == BeachWaveMovieModes.skyToHalfAndHalf) {
        sessionCard.setDisableTouchInput(true);
        blur.init();
        sessionCard.setDisableTouchInput(true);
        swipeGuide.fadeIn();
        setHasInitiatedBlur(true);
        // gestureCross.centerCrossNokhte.setWidgetVisibility(false);
        // gestureCross.gradientNokhte.setWidgetVisibility(false);
        centerNokhte.moveToCenter();
        homeNokhte.setWidgetVisibility(true);
        homeNokhte.initMovie(
          NokhteScaleState.enlarge,
        );
      } else if (hasInitiatedBlur && !hasSwiped()) {
        dismissNokhte();
      }
    }
  }

  @action
  dismissNokhte() {
    sessionCard.setDisableTouchInput(false);
    setHasInitiatedBlur(false);
    blur.reverse();
    centerNokhte.moveBackToCross();
    homeNokhte.initMovie(
      NokhteScaleState.shrink,
    );
  }

  gestureCrossTapReactor() => reaction(
        (p0) => gestureCross.tapCount,
        (p0) => onGestureCrossTap(),
      );

  @action
  onSessionCardTapped() {
    beachWaves.setMovieMode(BeachWaveMovieModes.skyToDrySand);
    beachWaves.currentStore.initMovie(const NoParams());
    sessionCard.setWidgetVisibility(false);
    primarySmartText.setWidgetVisibility(false);
    centerNokhte.setWidgetVisibility(false);
    gestureCross.cross.setWidgetVisibility(false);
    gestureCross.strokeCrossNokhte.setWidgetVisibility(false);
    homeNokhte.setWidgetVisibility(false);
  }

  deconstructor() {
    sessionCard.dispose();
    dispose();
  }

  @computed
  bool get isAllowedToInteract =>
      centerNokhte.movieStatus != MovieStatus.inProgress;
}
