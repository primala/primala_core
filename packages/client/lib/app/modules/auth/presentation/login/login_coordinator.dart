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
part 'login_coordinator.g.dart';

class LoginCoordinator = _LoginCoordinatorBase with _$LoginCoordinator;

abstract class _LoginCoordinatorBase with Store, BaseCoordinator, Reactions {
  final LoginWidgetsCoordinator widgets;
  final AuthContract contract;
  final IdentifyUser identifyUser;
  final UserInformationCoordinator userInfo;
  @override
  final CaptureScreen captureScreen;
  _LoginCoordinatorBase({
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
    await captureScreen(AuthConstants.login);
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
    disposers.add(backButtonReactor());
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
  logIn() async {
    final res = await contract.logIn(
      LogInParams(
        email: widgets.authTextFields.email,
        password: widgets.authTextFields.password,
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
