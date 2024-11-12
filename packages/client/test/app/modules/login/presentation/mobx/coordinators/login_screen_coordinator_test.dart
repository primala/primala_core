import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/login/login.dart';
import '../../../../shared/shared_mocks.mocks.dart';
import '../../../fixtures/authentication_stack_mock_gen.mocks.dart';

void main() {
  late LoginScreenWidgetsCoordinator mockWidgetsStore;
  late TapDetector mockTapDetector;
  late LoginCoordinator testStore;
  late BeachWavesStore mockLayer1BeachWavesStore;
  late SmartTextStore smartTextStore;
  late MockWifiDisconnectOverlayStore wifiDisconnectOverlayStore;

  setUp(() {
    wifiDisconnectOverlayStore = MockWifiDisconnectOverlayStore();
    mockLayer1BeachWavesStore = BeachWavesStore();
    smartTextStore = SmartTextStore();
    mockWidgetsStore = LoginScreenWidgetsCoordinator(
      wifiDisconnectOverlay: wifiDisconnectOverlayStore,
      beachWaves: mockLayer1BeachWavesStore,
      smartTextStore: smartTextStore,
    );
    mockTapDetector = TapDetector();
    testStore = LoginCoordinator(
      identifyUser: MockIdentifyUser(),
      contract: MockLoginContract(),
      captureScreen: MockCaptureScreen(),
      userInfo: MockUserInformationCoordinator(),
      widgets: mockWidgetsStore,
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
