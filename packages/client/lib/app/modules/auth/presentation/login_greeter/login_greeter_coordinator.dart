// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/auth/auth.dart';
part 'login_greeter_coordinator.g.dart';

class LoginGreeterCoordinator = _LoginGreeterCoordinatorBase
    with _$LoginGreeterCoordinator;

abstract class _LoginGreeterCoordinatorBase
    with Store, BaseCoordinator, Reactions {
  final LoginGreeterWidgetsCoordinator widgets;
  final AuthContract contract;
  final IdentifyUser identifyUser;
  final UserInformationCoordinator userInfo;
  @override
  final CaptureScreen captureScreen;

  _LoginGreeterCoordinatorBase({
    required this.contract,
    required this.widgets,
    required this.userInfo,
    required this.identifyUser,
    required this.captureScreen,
  }) {
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
    widgets.constructor();
    listenToAuthState();
    initReactors();
    await userInfo.checkIfVersionIsUpToDate();
    await captureScreen(AuthConstants.greeter);
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
    disposers.add(widgets.animatedScaffoldReactor());
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
  signInWithApple() async {
    await contract.signInWithApple();
  }

  @action
  signInWithGoogle() async {
    await contract.signInWithGoogle();
  }

  @action
  onLogIn() {
    if (disableAllTouchFeedback) return;
    widgets.setShowWidgets(false);
    Timer(Seconds.get(0, milli: 500), () {
      Modular.to.navigate(AuthConstants.login);
    });
    setDisableAllTouchFeedback(true);
  }

  @action
  onSignUp() {
    if (disableAllTouchFeedback) return;
    widgets.setShowWidgets(false);
    Timer(Seconds.get(0, milli: 500), () {
      Modular.to.navigate(AuthConstants.signup);
    });
    setDisableAllTouchFeedback(true);
  }

  authStateReactor() => reaction((p0) => isLoggedIn, (p0) async {
        if (p0) {
          widgets.loggedInOnResumed();
          await contract.addName();
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
