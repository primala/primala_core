// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'storage_home_coordinator.g.dart';

class StorageHomeCoordinator = _StorageHomeCoordinatorBase
    with _$StorageHomeCoordinator;

abstract class _StorageHomeCoordinatorBase
    with
        Store,
        EnRoute,
        EnRouteRouter,
        BaseCoordinator,
        BaseMobxLogic,
        Reactions {
  final StorageHomeWidgetsCoordinator widgets;
  final GetNokhteSessionArtifacts getNokhteSessionArtifactsLogic;
  final UpdateSessionAlias updateSessionAliasLogic;
  @override
  final CaptureScreen captureScreen;
  final TapDetector tap;

  final SwipeDetector swipe;
  _StorageHomeCoordinatorBase({
    required this.captureScreen,
    required this.getNokhteSessionArtifactsLogic,
    required this.updateSessionAliasLogic,
    required this.widgets,
    required this.swipe,
    required this.tap,
  }) {
    initEnRouteActions();
    initBaseCoordinatorActions();
    initBaseLogicActions();
  }

  @observable
  ObservableList<NokhteSessionArtifactEntity> nokhteSessionArtifacts =
      ObservableList();

  @observable
  bool aliasIsUpdated = false;

  @observable
  bool crossShouldUseObserver = true;

  @action
  setCrossShouldUseObserver(bool value) => crossShouldUseObserver = value;

  @action
  constructor() async {
    widgets.constructor();
    initReactors();
    await getNokhteSessionArtifacts();
    await captureScreen(StorageConstants.home);
  }

  @action
  getNokhteSessionArtifacts() async {
    final res = await getNokhteSessionArtifactsLogic(const NoParams());
    res.fold(
      (failure) => errorUpdater(failure),
      (artifacts) {
        nokhteSessionArtifacts = ObservableList.of(artifacts);
      },
    );
  }

  @action
  updateSessionAlias(UpdateSessionAliasParams params) async {
    final res = await updateSessionAliasLogic(params);
    res.fold(
      (failure) => errorUpdater(failure),
      (updateStatus) => aliasIsUpdated = updateStatus,
    );
  }

  initReactors() {
    // disposers.add(tapReactor());
    // disposers.add(swipeReactor());
    disposers.add(beachWavesMovieStatusReactor());
    disposers.add(sessionCardEditReactor());
    disposers.add(sessionCardTapReactor());
  }

  // tapReactor() => reaction((p0) => tap.tapCount, (p0) {
  //       ifTouchIsNotDisabled(() {
  //         widgets.onTap();
  //       });
  //     });

  // swipeReactor() => reaction((p0) => swipe.directionsType, (p0) {
  //       switch (p0) {
  //         case GestureDirections.left:
  //           ifTouchIsNotDisabled(() {
  //             widgets.onSwipeLeft();
  //           });
  //         default:
  //           break;
  //       }
  //     });

  beachWavesMovieStatusReactor() =>
      reaction((p0) => widgets.beachWaves.movieStatus, (p0) {
        if (p0 == MovieStatus.finished &&
            widgets.beachWaves.movieMode == BeachWaveMovieModes.anyToOnShore) {
          widgets.dispose();
          Modular.to.navigate(HomeConstants.home);
        } else if (p0 == MovieStatus.finished &&
            widgets.beachWaves.movieMode == BeachWaveMovieModes.skyToDrySand) {
          widgets.dispose();
          Modular.to.navigate(StorageConstants.content, arguments: {
            "content":
                nokhteSessionArtifacts[widgets.sessionCard.lastTappedIndex],
          });
        }
      });

  sessionCardEditReactor() => reaction(
        (p0) => widgets.sessionCard.lastEditedTitle,
        (p0) async {
          await updateSessionAlias(
            UpdateSessionAliasParams(
              sessionUID: widgets.sessionCard.lastEditedId,
              newAlias: p0,
            ),
          );
        },
      );

  sessionCardTapReactor() =>
      reaction((p0) => widgets.sessionCard.lastTappedIndex, (p0) {
        ifTouchIsNotDisabled(() {
          widgets.onSessionCardTapped();
          setDisableAllTouchFeedback(true);
        });
      });

  deconstructor() {
    dispose();
    widgets.dispose();
  }
}
