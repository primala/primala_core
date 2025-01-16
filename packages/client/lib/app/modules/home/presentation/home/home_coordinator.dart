// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
part 'home_coordinator.g.dart';

class HomeCoordinator = _HomeCoordinatorBase with _$HomeCoordinator;

abstract class _HomeCoordinatorBase
    with Store, BaseCoordinator, BaseMobxLogic, Reactions {
  final HomeWidgetsCoordinator widgets;
  final HomeLogicCoordinator logic;
  final TapDetector tap;
  @override
  final CaptureScreen captureScreen;

  late BuildContext buildContext;

  _HomeCoordinatorBase({
    required this.widgets,
    required this.tap,
    required this.logic,
    required this.captureScreen,
  }) {
    initBaseCoordinatorActions();
  }

  @action
  constructor(BuildContext context) async {
    buildContext = context;
    widgets.constructor();
    initReactors();
    await logic.getUserInformation();
    await logic.listenToCollaboratorRequests();
    await logic.listenToSessionRequests();
    await logic.listenToCollaboratorRelationships();
    await captureScreen(HomeConstants.home);
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
    disposers.add(userInformationReactor());
    disposers.add(collaboratorsReactor());
    disposers.add(requestsReactor());
    disposers.add(sessionsReactor());
    disposers.add(qrCodeScannerReactor());
  }

  userInformationReactor() => reaction((p0) => logic.userInformation, (p0) {
        widgets.onUserInformationReceived(p0);
      });

  collaboratorsReactor() => reaction((p0) => logic.collaborators, (p0) {
        widgets.collaboratorCard.setCollaborators(p0);
      });

  requestsReactor() => reaction((p0) => logic.collaboratorRequests, (p0) {
        ScaffoldMessenger.of(buildContext)
            .showSnackBar(
              SnackBar(
                action: SnackBarAction(
                  textColor: const Color.fromARGB(255, 58, 225, 108),
                  label: 'Accept',
                  onPressed: () async {
                    await logic.updateRequestStatus(
                      UpdateRequestStatusParams(
                        requestUID: p0.last.requestUID,
                        shouldAccept: true,
                        senderUID: p0.last.senderUID,
                      ),
                    );
                  },
                ),
                showCloseIcon: true,
                backgroundColor: Colors.black.withOpacity(.4),
                elevation: 0,
                content: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Jost(
                    'Request from ${p0.last.senderName}',
                    fontSize: 18,
                  ),
                ),
                duration: const Duration(seconds: 190),
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  bottom: 20.0,
                ),
                behavior: SnackBarBehavior.fixed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            )
            .closed
            .then((reason) async {
          if (reason != SnackBarClosedReason.action) {
            await logic.updateRequestStatus(
              UpdateRequestStatusParams(
                requestUID: p0.last.requestUID,
                shouldAccept: false,
                senderUID: p0.last.senderUID,
              ),
            );
          }
        });
      });

  sessionsReactor() => reaction((p0) => logic.sessionRequests, (p0) {
        ScaffoldMessenger.of(buildContext).showSnackBar(
          SnackBar(
            action: SnackBarAction(
              textColor: const Color.fromARGB(255, 58, 225, 108),
              label: 'Accept',
              onPressed: () async {
                // await logic.joinSession(
                //   p0.last.sessionUID,
                // );
                // Modular.to.navigate(SessionConstants.lobby);
              },
            ),
            showCloseIcon: true,
            backgroundColor: Colors.black.withOpacity(.4),
            elevation: 0,
            content: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Jost(
                '${p0.last.groupName}: Join Session?',
                fontSize: 18,
              ),
            ),
            duration: const Duration(seconds: 190),
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 20.0,
            ),
            behavior: SnackBarBehavior.fixed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        );
      });

  qrCodeScannerReactor() =>
      reaction((p0) => widgets.qrScanner.mostRecentScannedUID, (p0) async {
        if (p0.isNotEmpty) {
          await logic.sendRequest(
            SendRequestParams(
              recipientUID: p0,
              senderName: logic.userInformation.fullName,
            ),
          );
          widgets.qrScanner.resetMostRecentScannedUID();
        }
      });

  deconstructor() {
    dispose();
    logic.dispose();
    widgets.dispose();
  }
}
