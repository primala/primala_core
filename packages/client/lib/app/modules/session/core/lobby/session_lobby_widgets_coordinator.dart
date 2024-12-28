// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'dart:ui';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
part 'session_lobby_widgets_coordinator.g.dart';

class SessionLobbyWidgetsCoordinator = _SessionLobbyWidgetsCoordinatorBase
    with _$SessionLobbyWidgetsCoordinator;

abstract class _SessionLobbyWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator, Reactions, RoutingArgs {
  final BeachWavesStore beachWaves;
  final SmartTextStore primarySmartText;
  final NokhteQrCodeStore qrCode;
  final TouchRippleStore touchRipple;
  final NavigationMenuStore navigationMenu;
  final ContextHeaderStore contextHeader;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;

  _SessionLobbyWidgetsCoordinatorBase({
    required this.primarySmartText,
    required this.wifiDisconnectOverlay,
    required this.navigationMenu,
    required this.qrCode,
    required this.touchRipple,
    required this.contextHeader,
  }) : beachWaves = navigationMenu.beachWaves {
    initBaseWidgetsCoordinatorActions();
  }

  @observable
  bool constructorHasBeenCalled = false;

  @action
  constructor() {
    navigationMenu.setNavigationMenuType(
      NavigationMenuType.sessionLobbyNoOneJoined,
      shouldInitReactors: false,
    );

    beachWaves.setMovieMode(
      BeachWaveMovieModes.deepSeaToSky,
    );
    contextHeader.setWidgetVisibility(false);
    primarySmartText.setMessagesData(SessionLists.lobby);
    // primarySmartText.setWidgetVisibility(false);
    qrCode.setWidgetVisibility(false);

    disposers.add(smartTextIndexReactor());
    disposers.add(navigationMenu.swipeReactor());

    Timer(Seconds.get(1), () {
      primarySmartText.startRotatingText();
      // print('is this running');
    });

    Timer(Seconds.get(2), () {
      constructorHasBeenCalled = true;
    });
  }

  @observable
  bool isFirstTap = true;

  @observable
  Stopwatch cooldownStopwatch = Stopwatch();

  @action
  onTap(
    Offset tapPosition, {
    required Function onTap,
  }) async {
    if (isFirstTap) {
      touchRipple.onTap(tapPosition);
      isFirstTap = false;
      primarySmartText.startRotatingText(isResuming: true);
    }
    await onTap();
  }

  @action
  onQrCodeReady(String data) {
    qrCode.setQrCodeData(data);
    qrCode.setWidgetVisibility(true);
  }

  @observable
  bool presetInfoRecieved = false;

  @action
  onCanStartTheSession() {
    Timer.periodic(Seconds.get(0, milli: 100), (timer) {
      if (primarySmartText.currentIndex == 0 &&
          constructorHasBeenCalled &&
          primarySmartText.isDoneAnimating) {
        primarySmartText.startRotatingText(isResuming: true);
        timer.cancel();
      }
    });
  }

  @action
  onRevertCanStartSession() {
    Timer.periodic(Seconds.get(0, milli: 100), (timer) {
      if (primarySmartText.currentIndex == 1 &&
          constructorHasBeenCalled &&
          primarySmartText.isDoneAnimating) {
        primarySmartText.startRotatingText(isResuming: true);
        primarySmartText.setWidgetVisibility(false);
        timer.cancel();
      }
    });
  }

  @action
  onModalOpened() {
    navigationMenu.setWidgetVisibility(false);
    qrCode.setWidgetVisibility(false);
    primarySmartText.setWidgetVisibility(false);
  }

  @action
  onCollaboratorLeft() {
    primarySmartText.setWidgetVisibility(false);
    if (qrCode.qrCodeData.isNotEmpty) {
      qrCode.setWidgetVisibility(false);
    }
  }

  @action
  onCollaboratorJoined() {
    primarySmartText.setWidgetVisibility(primarySmartText.pastShowWidget);
    if (qrCode.qrCodeData.isNotEmpty) {
      qrCode.setWidgetVisibility(qrCode.pastShowWidget);
    }
  }

  @action
  enterSession() {
    beachWaves.setMovieMode(BeachWaveMovieModes.deepSeaToSky);
    beachWaves.currentStore.initMovie(const NoParams());
    qrCode.setWidgetVisibility(false);
    contextHeader.setWidgetVisibility(false);
    primarySmartText.setWidgetVisibility(false);
  }

  beachWavesMovieStatusReactor(Function onCompleted) =>
      reaction((p0) => beachWaves.movieStatus, (p0) {
        if (p0 == beachWaves.movieStatus) onCompleted();
      });

  smartTextIndexReactor() =>
      reaction((p0) => primarySmartText.currentIndex, (p0) {
        if (isFirstTap) {
          if (p0 == 2) {
            primarySmartText.setCurrentIndex(0);
            primarySmartText.setWidgetVisibility(true);
          }
        }
      });
}
