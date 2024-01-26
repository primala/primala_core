import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nokhte/app/core/interfaces/auth_providers.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/authentication/presentation/presentation.dart';
import '../../../../shared/shared_mocks.mocks.dart';
import '../../../fixtures/authentication_stack_mock_gen.mocks.dart';

void main() {
  late LoginScreenWidgetsCoordinator mockWidgetsStore;
  late MockSignInWithAuthProviderStore mockAuthProviderStore;
  late MockGetAuthStateStore mockAuthStateStore;
  late SwipeDetector mockSwipeDetector;
  late TapDetector mockTapDetector;
  late LoginScreenCoordinator testStore;
  late BeachWavesStore mockLayer1BeachWavesStore;
  late BeachWavesStore mockLayer2BeachWavesStore;
  late SmartTextStore smartTextStore;
  late NokhteStore nokhteStore;
  late TrailingTextStore topTrailingTextStore;
  late TrailingTextStore bottomTrailingTextStore;
  late MockWifiDisconnectOverlayStore wifiDisconnectOverlayStore;
  const tCoordinates = Offset(1, 1);

  setUp(() {
    wifiDisconnectOverlayStore = MockWifiDisconnectOverlayStore();
    mockLayer1BeachWavesStore = BeachWavesStore();
    mockLayer2BeachWavesStore = BeachWavesStore();
    smartTextStore = SmartTextStore();
    nokhteStore = NokhteStore();
    topTrailingTextStore = TrailingTextStore();
    bottomTrailingTextStore = TrailingTextStore();
    mockWidgetsStore = LoginScreenWidgetsCoordinator(
      gestureCross: MockGestureCrossStore(),
      wifiDisconnectOverlay: wifiDisconnectOverlayStore,
      layer1BeachWaves: mockLayer1BeachWavesStore,
      layer2BeachWaves: mockLayer2BeachWavesStore,
      smartTextStore: smartTextStore,
      nokhte: nokhteStore,
      bottomTrailingText: bottomTrailingTextStore,
      topTrailingText: topTrailingTextStore,
    );
    mockAuthStateStore = MockGetAuthStateStore();
    mockAuthProviderStore = MockSignInWithAuthProviderStore();
    mockSwipeDetector = SwipeDetector();
    mockTapDetector = TapDetector();
    testStore = LoginScreenCoordinator(
      widgets: mockWidgetsStore,
      signInWithAuthProvider: mockAuthProviderStore,
      authStateStore: mockAuthStateStore,
      tap: mockTapDetector,
      swipe: mockSwipeDetector,
    );
  });

  group("initial values", () {
    test("authProvider", () {
      expect(testStore.authProvider, AuthProvider.apple);
    });

    test("isLoggedIn", () {
      expect(testStore.isLoggedIn, false);
    });

    test("hasAttemptedToLogin", () {
      expect(testStore.hasAttemptedToLogin, false);
    });
  });

  group("actions", () {
    test("toggleHasAttemptedToLogin", () {
      testStore.toggleHasAttemptedToLogin();
      expect(testStore.hasAttemptedToLogin, true);
      testStore.toggleHasAttemptedToLogin();
      expect(testStore.hasAttemptedToLogin, false);
    });
    test("screenConstructor", () {
      testStore.constructor(tCoordinates);
      // verify(mockWidgetsStore.constructor(
      //   tCoordinates,
      //   testStore.logTheUserIn,
      //   testStore.onConnected,
      //   testStore.onDisconnected,
      // ));
    });

    test("logTheUserIn", () {
      testStore.logTheUserIn();
      verify(
          mockAuthProviderStore.routeAuthProviderRequest(AuthProvider.apple));
    });

    group("OnResumed", () {
      test("!isLoggedIn", () {
        testStore.onResumed();
        // verify(mockWidgetsStore.loggedOutOnResumed());
      });
      test("hasAttemptedToLogin", () {
        testStore.toggleHasAttemptedToLogin();
        testStore.onResumed();
        expect(testStore.hasAttemptedToLogin, false);
      });
    });
    group("OnInactive", () {
      test("!isLoggedIn", () {
        testStore.onInactive();
        // verify(mockWidgetsStore.loggedOutOnInactive());
      });
      test("isLoggedIn", () {
        testStore.isLoggedIn = true;
        testStore.onInactive();
        // verify(mockWidgetsStore.loggedInOnInactive());
      });
    });
  });
}
