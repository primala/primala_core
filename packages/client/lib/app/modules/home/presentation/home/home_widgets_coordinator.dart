// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/session/constants/constants.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:simple_animations/simple_animations.dart';
part 'home_widgets_coordinator.g.dart';

class HomeWidgetsCoordinator = _HomeWidgetsCoordinatorBase
    with _$HomeWidgetsCoordinator;

abstract class _HomeWidgetsCoordinatorBase
    with
        Store,
        EnRoute,
        Reactions,
        EnRouteConsumer,
        SwipeNavigationUtils,
        EnRouteWidgetsRouter,
        BaseWidgetsCoordinator {
  final NavigationCarouselsStore navigationCarousels;
  @override
  final BeachWavesStore beachWaves;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;
  final QrScannerStore qrScanner;
  final SmartTextStore smartText;
  final NokhteQrCodeStore qrCode;
  final CollaboratorCardStore collaboratorCard;

  _HomeWidgetsCoordinatorBase({
    required this.navigationCarousels,
    required this.wifiDisconnectOverlay,
    required this.qrScanner,
    required this.smartText,
    required this.qrCode,
    required this.collaboratorCard,
  }) : beachWaves = navigationCarousels.beachWaves {
    initEnRouteActions();
    initSwipeNavigationUtils();

    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    qrCode.setWidgetVisibility(false);
    collaboratorCard.setWidgetVisibility(false);
    smartText.setMessagesData(SharedLists.emptyList);
    navigationCarousels
        .setNavigationCarouselsType(NavigationCarouselsType.homescreen);
    beachWaves.setMovieMode(BeachWaveMovieModes.onShore);
    consumeRoutingArgs();
    setupEnRouteWidgets();
    disposers.add(beachWavesMovieStatusReactor());
    disposers.add(qrSectionReactor());
    disposers.add(cameraSectionReactor());
    disposers.add(collaboratorSectionReactor());
  }

  @action
  onUserInformationReceived(UserInformationEntity userInfo) {
    qrCode.setWidgetVisibility(true);
    qrCode.setQrCodeData(userInfo.uid);
    final firstName = userInfo.fullName.split(' ').first;
    smartText.setMessagesData(HomeList.getQrList(firstName));
    smartText.startRotatingText();
    navigationCarousels.setShowSections(true);
  }

  @override
  beachWavesMovieStatusReactor() =>
      reaction((p0) => beachWaves.movieStatus, (p0) {
        if (beachWaves.movieStatus == MovieStatus.finished) {
          if (beachWaves.movieMode == BeachWaveMovieModes.anyToOnShore) {
            Modular.to.navigate(SessionConstants.polymorphicSolo);
          } else {
            beachWaves.setMovieStatus(MovieStatus.inProgress);
            if (waterDirecton == WaterDirection.up) {
              beachWaves.currentStore.setControl(Control.playFromStart);
              setWaterDirection(WaterDirection.down);
            } else {
              beachWaves.currentStore.setControl(Control.playReverseFromEnd);
              setWaterDirection(WaterDirection.up);
            }
          }
        }
      });

  qrSectionReactor() => reaction((p0) => qrSectionIsActive, (p0) {
        if (p0) {
          qrCode.setWidgetVisibility(true);
          smartText.setWidgetVisibility(true);
        } else {
          qrCode.setWidgetVisibility(false);
          smartText.setWidgetVisibility(false);
        }
      });

  collaboratorSectionReactor() =>
      reaction((p0) => collaboratorSectionIsActive, (p0) {
        if (p0) {
          collaboratorCard.setWidgetVisibility(true);
        } else {
          collaboratorCard.setWidgetVisibility(false);
        }
      });

  cameraSectionReactor() => reaction((p0) => cameraSectionIsActive, (p0) async {
        if (p0) {
          await qrScanner.fadeIn();
        } else {
          await qrScanner.fadeOut();
        }
      });

  @computed
  bool get qrSectionIsActive =>
      navigationCarousels.currentlySelectedSection ==
      NavigationCarouselsSectionTypes.qrCodeIcon;

  @computed
  bool get cameraSectionIsActive =>
      navigationCarousels.currentlySelectedSection ==
      NavigationCarouselsSectionTypes.cameraIcon;

  @computed
  bool get collaboratorSectionIsActive =>
      navigationCarousels.currentlySelectedSection ==
      NavigationCarouselsSectionTypes.queueIcon;
}
