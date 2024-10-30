// ignore_for_file: must_be_immutable, library_private_types_in_public_api,  overridden_fields
import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session_starters/session_starters.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
part 'home_coordinator.g.dart';

class HomeCoordinator = _HomeCoordinatorBase with _$HomeCoordinator;

abstract class _HomeCoordinatorBase
    with Store, BaseCoordinator, BaseMobxLogic, Reactions {
  final GetNokhteSessionArtifacts getNokhteSessionArtifactsLogic;
  final HomeWidgetsCoordinator widgets;
  final TapDetector tap;
  final SwipeDetector swipe;
  final SessionStartersLogicCoordinator sessionStartersLogic;
  @override
  final CaptureScreen captureScreen;

  _HomeCoordinatorBase({
    required this.swipe,
    required this.widgets,
    required this.tap,
    required this.sessionStartersLogic,
    required this.getNokhteSessionArtifactsLogic,
    required this.captureScreen,
  }) {
    initBaseCoordinatorActions();
  }

  @observable
  ObservableList<NokhteSessionArtifactEntity> nokhteSessionArtifacts =
      ObservableList();

  @action
  constructor() async {
    widgets.constructor();
    initReactors();
    await captureScreen(HomeConstants.home);
    await getNokhteSessionArtifacts();
  }

  initReactors() {
    disposers.addAll(widgets.wifiDisconnectOverlay.initReactors(
      onQuickConnected: () {
        widgets.setIsDisconnected(false);
        setDisableAllTouchFeedback(false);
      },
      onLongReConnected: () {
        widgets.setIsDisconnected(false);
        setDisableAllTouchFeedback(false);
      },
      onDisconnected: () {
        setDisableAllTouchFeedback(true);
        widgets.setIsDisconnected(true);
      },
    ));
    disposers.add(swipeReactor());
    disposers.add(tapReactor());
  }

  tapReactor() => reaction((p0) => tap.doubleTapCount, (p0) {
        ifTouchIsNotDisabled(() async {
          if (widgets.hasInitiatedBlur) return;
          widgets.initSoloSession();
          await sessionStartersLogic.initialize(
            const Right(PresetTypes.solo),
          );
          setDisableAllTouchFeedback(true);
        });
      });

  swipeReactor() => reaction((p0) => swipe.directionsType, (p0) {
        ifTouchIsNotDisabled(() {
          switch (p0) {
            case GestureDirections.up:
              widgets.onSwipeUp();
            case GestureDirections.right:
              widgets.onSwipeRight();
            case GestureDirections.down:
              widgets.onSwipeDown();
            case GestureDirections.left:
              widgets.onSwipeLeft();
            default:
              break;
          }
        });
      });

  @action
  getNokhteSessionArtifacts() async {
    final res = await getNokhteSessionArtifactsLogic(const NoParams());
    res.fold(
      (failure) => errorUpdater(failure),
      (artifacts) => nokhteSessionArtifacts = ObservableList.of(artifacts),
    );
  }

  deconstructor() {
    dispose();
    widgets.dispose();
  }
}
