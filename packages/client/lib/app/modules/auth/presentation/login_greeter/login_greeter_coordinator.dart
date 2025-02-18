// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/modules/auth/auth.dart';
part 'login_greeter_coordinator.g.dart';

class LoginGreeterCoordinator = _LoginGreeterCoordinatorBase
    with _$LoginGreeterCoordinator;

abstract class _LoginGreeterCoordinatorBase
    with Store, BaseCoordinator, Reactions {
  final LoginGreeterWidgetsCoordinator widgets;
  final AuthContract contract;
  final IdentifyUser identifyUser;
  @override
  final CaptureScreen captureScreen;

  _LoginGreeterCoordinatorBase({
    required this.contract,
    required this.widgets,
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
    if (disableAllTouchFeedback) return;
    await contract.signInWithApple();
  }

  @action
  signInWithGoogle() async {
    if (disableAllTouchFeedback) return;
    await contract.signInWithGoogle();
  }

  @action
  onLogIn() {
    if (disableAllTouchFeedback) return;
    Modular.to.push(
      MaterialPageRoute(builder: (BuildContext context) {
        return LoginScreen(
          coordinator: Modular.get<LoginCoordinator>(),
        );
      }),
    );
  }

  @action
  onSignUp() {
    if (disableAllTouchFeedback) return;
    Modular.to.push(
      MaterialPageRoute(builder: (BuildContext context) {
        return SignupScreen(
          coordinator: Modular.get<SignupCoordinator>(),
        );
      }),
    );
  }

  authStateReactor() => reaction((p0) => isLoggedIn, (p0) async {
        if (p0) {
          setDisableAllTouchFeedback(true);
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
