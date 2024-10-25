// ignore_for_file: must_be_immutable, library_private_types_in_public_api,
import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/constants/failure_constants.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/clean_up_collaboration_artifacts/clean_up_collaboration_artifacts.dart';
import 'package:nokhte/app/core/modules/in_app_purchase/in_app_purchase.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'session_paywall_widgets_coordinator.dart';
part 'session_paywall_coordinator.g.dart';

class SessionPaywallCoordinator = _SessionPaywallCoordinatorBase
    with _$SessionPaywallCoordinator;

abstract class _SessionPaywallCoordinatorBase
    with Store, EnRoute, EnRouteRouter, BaseCoordinator, Reactions {
  final TapDetector tap;
  final SessionPaywallWidgetsCoordinator widgets;
  final SessionPresenceCoordinator presence;
  final SessionMetadataStore sessionMetadata;
  final SwipeDetector swipe;
  final InAppPurchaseCoordinator iap;
  final CleanUpCollaborationArtifactsCoordinator cleanUpCollaborationArtifacts;
  @override
  final CaptureScreen captureScreen;

  _SessionPaywallCoordinatorBase({
    required this.cleanUpCollaborationArtifacts,
    required this.captureScreen,
    required this.widgets,
    required this.tap,
    required this.presence,
    required this.swipe,
    required this.iap,
  }) : sessionMetadata = presence.sessionMetadataStore {
    initEnRouteActions();
    initBaseCoordinatorActions();
  }

  @action
  constructor() async {
    widgets.constructor();
    initReactors();
    swipe.setMinDistance(100.0);
    await iap.getSubscriptionInfo();
    await captureScreen(SessionConstants.paywall);
  }

  initReactors() {
    disposers.add(tapReactor());
    disposers.add(swipeReactor());
    disposers.add(presence.initReactors(
      onCollaboratorJoined: () {},
      onCollaboratorLeft: () {},
    ));
    disposers.addAll(widgets.wifiDisconnectOverlay.initReactors(
      onQuickConnected: () => setDisableAllTouchFeedback(false),
      onLongReConnected: () {
        widgets.setDisableTouchInput(false);
      },
      onDisconnected: () {
        widgets.setDisableTouchInput(true);
      },
    ));
    disposers.add(subscriptionInfoReactor());
    disposers.add(purchaseSuccessReactor());
    disposers.add(purchaseErrorReactor());
    disposers.add(phaseReactor());
    disposers.add(validSessionReactor());
  }

  subscriptionInfoReactor() => reaction((p0) => iap.skuProductEntity, (p0) {
        widgets.onProductInfoReceived(p0);
      });

  purchaseErrorReactor() => reaction((p0) => iap.errorMessage, (p0) {
        if (p0 == FailureConstants.cancelledPurchaseFailureMsg) {
          widgets.onPaymentFailure();
          iap.setErrorMessage('');
        }
      });

  validSessionReactor() =>
      reaction((p0) => sessionMetadata.isAValidSession, (p0) {
        // Modular.to.navigate(SessionConstants.waitingPatron);
      });

  purchaseSuccessReactor() =>
      reaction((p0) => iap.hasPurchasedSubscription, (p0) async {
        if (p0) {
          // Modular.to.navigate(SessionConstants.waitingPatron);
        }
      });

  phaseReactor() => reaction((p0) => sessionMetadata.currentPhases, (p0) async {
        if (p0.contains(-1.0)) {
          widgets.onExit();
        }
      });

  tapReactor() => reaction(
        (p0) => tap.tapCount,
        (p0) => ifTouchIsNotDisabled(
          () {
            widgets.onTap(
              tap.currentTapPosition,
            );
          },
        ),
      );

  @observable
  bool hasSwipedDown = false;

  swipeReactor() => reaction((p0) => swipe.directionsType, (p0) async {
        switch (p0) {
          case GestureDirections.up:
            widgets.onSwipeUp(
              () async => await iap.buySubscription(),
            );
          case GestureDirections.down:
            if (!hasSwipedDown) {
              await cleanUpCollaborationArtifacts(const NoParams());
              hasSwipedDown = true;
            }
          default:
            break;
        }
      });

  deconstructor() {
    dispose();
    widgets.dispose();
  }
}
