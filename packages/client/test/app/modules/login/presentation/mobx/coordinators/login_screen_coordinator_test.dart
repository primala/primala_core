import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/login/login.dart';
import '../../../../shared/shared_mocks.mocks.dart';
import '../../../fixtures/authentication_stack_mock_gen.mocks.dart';

void main() {
  late LoginScreenWidgetsCoordinator mockWidgetsStore;
  late MockSignInWithAuthProviderStore mockAuthProviderStore;
  late MockGetLoginStateStore mockAuthStateStore;
  late TapDetector mockTapDetector;
  late LoginCoordinator testStore;
  late BeachWavesStore mockLayer1BeachWavesStore;
  late BeachWavesStore mockLayer2BeachWavesStore;
  late SmartTextStore smartTextStore;
  late MockWifiDisconnectOverlayStore wifiDisconnectOverlayStore;
  late MockAddName mockAddNameToDatabase;

  setUp(() {
    mockAddNameToDatabase = MockAddName();
    wifiDisconnectOverlayStore = MockWifiDisconnectOverlayStore();
    mockLayer1BeachWavesStore = BeachWavesStore();
    mockLayer2BeachWavesStore = BeachWavesStore();
    smartTextStore = SmartTextStore();
    mockWidgetsStore = LoginScreenWidgetsCoordinator(
      wifiDisconnectOverlay: wifiDisconnectOverlayStore,
      layer1BeachWaves: mockLayer1BeachWavesStore,
      layer2BeachWaves: mockLayer2BeachWavesStore,
      smartTextStore: smartTextStore,
    );
    mockAuthStateStore = MockGetLoginStateStore();
    mockAuthProviderStore = MockSignInWithAuthProviderStore();
    mockTapDetector = TapDetector();
    testStore = LoginCoordinator(
      identifyUser: MockIdentifyUser(),
      addMetadata: MockAddMetadata(),
      captureScreen: MockCaptureScreen(),
      userInfo: MockUserInformationCoordinator(),
      addName: mockAddNameToDatabase,
      widgets: mockWidgetsStore,
      signInWithAuthProvider: mockAuthProviderStore,
      authStateStore: mockAuthStateStore,
      tap: mockTapDetector,
    );
  });

  group("initial values", () {
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
  });
}
