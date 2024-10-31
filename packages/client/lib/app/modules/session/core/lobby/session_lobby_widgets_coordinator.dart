// ignore_for_file: must_be_immutable, library_private_types_in_public_api
// import 'dart:async';
import 'dart:async';
import 'dart:ui';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/presets/presets.dart';
import 'package:nokhte/app/modules/session_starters/session_starters.dart';
part 'session_lobby_widgets_coordinator.g.dart';

class SessionLobbyWidgetsCoordinator = _SessionLobbyWidgetsCoordinatorBase
    with _$SessionLobbyWidgetsCoordinator;

abstract class _SessionLobbyWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator, Reactions, RoutingArgs {
  final BeachWavesStore beachWaves;
  final SmartTextStore primarySmartText;
  final NokhteQrCodeStore qrCode;
  final TouchRippleStore touchRipple;
  final PresetArticleStore presetArticle;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;

  _SessionLobbyWidgetsCoordinatorBase({
    required this.beachWaves,
    required this.primarySmartText,
    required this.presetArticle,
    required this.wifiDisconnectOverlay,
    required this.qrCode,
    required this.touchRipple,
  }) {
    initBaseWidgetsCoordinatorActions();
  }

  @observable
  bool constructorHasBeenCalled = false;

  @action
  constructor() {
    beachWaves.setMovieMode(
      BeachWaveMovieModes.deepSeaToSky,
    );
    primarySmartText.setMessagesData(SessionLists.lobby);
    primarySmartText.setWidgetVisibility(false);

    if (hasReceivedRoutingArgs) {
      qrCode.setQrCodeData(
          Modular.args.data[SessionStarterConstants.QR_CODE_DATA]);
    }
    if (qrCode.qrCodeData.isEmpty) {
      qrCode.setWidgetVisibility(false);
    }

    disposers.add(smartTextIndexReactor());

    Timer(Seconds.get(1), () {
      primarySmartText.startRotatingText();
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
  }

  @action
  onPresetTypeReceived(
    CompanyPresetsEntity entity, {
    required Function onOpen,
    required Function onClose,
  }) {
    presetArticle.setShowPreview(true);
    if (!hasReceivedRoutingArgs) {
      presetArticle.showBottomSheet(
        entity,
        onOpen: onOpen,
        onClose: onClose,
      );
    } else {
      presetArticle.setPreset(entity);
    }
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
  onCollaboratorLeft() {
    primarySmartText.setWidgetVisibility(false);
    presetArticle.setShowPreview(false);
    if (qrCode.qrCodeData.isNotEmpty) {
      qrCode.setWidgetVisibility(false);
    }
  }

  @action
  onCollaboratorJoined() {
    primarySmartText.setWidgetVisibility(primarySmartText.pastShowWidget);
    presetArticle.setShowPreview(true);
    if (qrCode.qrCodeData.isNotEmpty) {
      qrCode.setWidgetVisibility(qrCode.pastShowWidget);
    }
  }

  @action
  enterSession(bool isAValidSession) {
    if (isAValidSession) {
      beachWaves.setMovieMode(BeachWaveMovieModes.deepSeaToSky);
      beachWaves.currentStore.initMovie(const NoParams());
    } else {
      beachWaves.setMovieMode(BeachWaveMovieModes.deepSeaToBorealis);
      beachWaves.currentStore.initMovie(const NoParams());
    }
    presetArticle.setShowPreview(false);
    presetArticle.setWidgetVisibility(true);
    qrCode.setWidgetVisibility(false);
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
