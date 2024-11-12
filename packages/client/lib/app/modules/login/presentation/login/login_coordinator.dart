// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/login/login.dart';
import 'package:nokhte/app/modules/home/home.dart';
part 'login_coordinator.g.dart';

class LoginCoordinator = _LoginCoordinatorBase with _$LoginCoordinator;

abstract class _LoginCoordinatorBase
    with
        Store,
        EnRoute,
        EnRouteRouter,
        HomeScreenRouter,
        BaseCoordinator,
        Reactions {
  final LoginScreenWidgetsCoordinator widgets;
  final LoginContract contract;
  final TapDetector tap;
  final IdentifyUser identifyUser;
  @override
  final UserInformationCoordinator userInfo;
  @override
  final CaptureScreen captureScreen;

  _LoginCoordinatorBase({
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
  toggleHasAttemptedToLogin() => hasAttemptedToLogin = !hasAttemptedToLogin;

  @action
  constructor() async {
    widgets.constructor();
    listenToAuthState();
    initReactors();
    await userInfo.checkIfVersionIsUpToDate();
    await captureScreen(LoginConstants.root);
  }

  initReactors() {
    disposers.add(tapReactor());
    disposers.add(authStateReactor());
    disposers.addAll(
        widgets.wifiDisconnectOverlay.initReactors(onQuickConnected: () {
      setDisableAllTouchFeedback(false);
    }, onLongReConnected: () {
      setDisableAllTouchFeedback(false);
    }, onDisconnected: () {
      setDisableAllTouchFeedback(true);
    }));
    disposers.add(widgets.beachWavesReactor(onAnimationComplete));
  }

  @action
  onConnected() {
    if (disableAllTouchFeedback) {
      toggleDisableAllTouchFeedback();
    }
  }

  @action
  onDisconnected() {
    if (!disableAllTouchFeedback) {
      toggleDisableAllTouchFeedback();
    }
  }

  @action
  logIn(AuthProvider provider) async {
    if (widgets.showLoginButtons) {
      await contract.routeAuthProviderRequest(provider);
    } else {
      widgets.onTap();
    }
  }

  tapReactor() => reaction(
        (p0) => tap.tapCount,
        (p0) => ifTouchIsNotDisabled(() => widgets.onTap()),
      );

  authStateReactor() => reaction((p0) => isLoggedIn, (p0) async {
        if (p0) {
          widgets.loggedInOnResumed();
          await contract.addName(const NoParams());
          await contract.addMetadata(const NoParams());
          await identifyUser(const NoParams());
          await authStateStream.close();
        }
      });

  @action
  listenToAuthState() {
    authStateStream = ObservableStream(contract.getAuthState(const NoParams()));
    authStateStream.listen((isLoggedIn) {
      this.isLoggedIn = isLoggedIn;
    });
  }

  deconstructor() {
    dispose();
    widgets.dispose();
  }
}
