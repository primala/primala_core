// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/auth/auth.dart';
import 'package:nokhte/app/modules/home/home.dart';
part 'signup_coordinator.g.dart';

class SignupCoordinator = _SignupCoordinatorBase with _$SignupCoordinator;

abstract class _SignupCoordinatorBase
    with
        Store,
        EnRoute,
        EnRouteRouter,
        HomeScreenRouter,
        BaseCoordinator,
        Reactions {
  final SignupWidgetsCoordinator widgets;
  final AuthContract contract;
  final TapDetector tap;
  final IdentifyUser identifyUser;
  @override
  final UserInformationCoordinator userInfo;
  @override
  final CaptureScreen captureScreen;
  _SignupCoordinatorBase({
    required this.contract,
    required this.widgets,
    required this.userInfo,
    required this.identifyUser,
    required this.tap,
    required this.captureScreen,
  }) {
    initEnRouteActions();
    initBaseCoordinatorActions();
  }

  @observable
  bool isLoggedIn = false;

  @observable
  bool hasAttemptedToLogin = false;

  @observable
  ObservableStream<bool> authStateStream =
      ObservableStream(const Stream.empty());

  @action
  constructor() async {
    widgets.initFadein();
    listenToAuthState();
    initReactors();
    await userInfo.checkIfVersionIsUpToDate();
    await captureScreen(AuthConstants.signup);
  }

  initReactors() {
    disposers.add(authStateReactor());
    disposers.addAll(
        widgets.wifiDisconnectOverlay.initReactors(onQuickConnected: () {
      setDisableAllTouchFeedback(false);
    }, onLongReConnected: () {
      setDisableAllTouchFeedback(false);
    }, onDisconnected: () {
      setDisableAllTouchFeedback(true);
    }));
    disposers.add(widgets.animatedScaffoldReactor(onAnimationComplete));
    disposers.add(backButtonReactor());
  }

  @action
  onConnected() {
    setDisableAllTouchFeedback(false);
  }

  @action
  onDisconnected() {
    setDisableAllTouchFeedback(true);
  }

  @action
  signUp() async {
    final res = await contract.signUp(
      SignUpParams(
        email: widgets.authTextFields.email,
        password: widgets.authTextFields.password,
        fullName: widgets.authTextFields.fullName,
      ),
    );
    res.fold((l) {
      widgets.authTextFields.setPasswordErrorText(l.message);
    }, (r) {});
  }

  @action
  onGoBack() {
    if (disableAllTouchFeedback) return;
    widgets.setShowWidgets(false);
    Timer(Seconds.get(0, milli: 500), () {
      Modular.to.navigate(AuthConstants.greeter);
    });
    setDisableAllTouchFeedback(true);
  }

  backButtonReactor() => reaction((p0) => widgets.backButton.tapCount, (p0) {
        if (disableAllTouchFeedback || !widgets.backButton.showWidget) return;

        onGoBack();
      });

  authStateReactor() => reaction((p0) => isLoggedIn, (p0) async {
        if (p0) {
          widgets.loggedInOnResumed();
          await identifyUser(const NoParams());
          await authStateStream.close();
        }
      });

  @action
  listenToAuthState() {
    authStateStream = ObservableStream(contract.getAuthState());
    authStateStream.listen((isLoggedIn) {
      this.isLoggedIn = isLoggedIn;
    });
  }

  deconstructor() {
    dispose();
    widgets.dispose();
  }
}
