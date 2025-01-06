import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/login/login.dart';
import '../../../../shared/shared_mocks.mocks.dart';

void main() {
  late BeachWavesStore layer1BeachWavesStore;
  late SmartTextStore smartTextStore;
  late MockWifiDisconnectOverlayStore wifiDisconnectOverlayStore;
  late LoginScreenWidgetsCoordinator testStore;

  setUp(() {
    wifiDisconnectOverlayStore = MockWifiDisconnectOverlayStore();
    layer1BeachWavesStore = BeachWavesStore();
    smartTextStore = SmartTextStore();
    testStore = LoginScreenWidgetsCoordinator(
      wifiDisconnectOverlay: wifiDisconnectOverlayStore,
      beachWaves: layer1BeachWavesStore,
      smartTextStore: smartTextStore,
    );
  });

  group("initial values", () {
    test("hasTriggeredLoginAnimation", () {
      expect(testStore.hasTriggeredLoginAnimation, false);
    });
  });

  group("actions", () {
    test("toggleHasTriggeredLoginAnimation", () {
      testStore.toggleHasTriggeredLoginAnimation();
      expect(testStore.hasTriggeredLoginAnimation, true);
    });
  });

  group("other functions", () {
    test("triggerLoginAnimation", () {
      testStore.triggerLoginAnimation();
      expect(testStore.hasTriggeredLoginAnimation, true);
    });

    group("loggedInOnResumed", () {
      test("!hasTriggeredAnimation", () {
        testStore.loggedInOnResumed();
        expect(testStore.hasTriggeredLoginAnimation, true);
      });
    });

    test("onTap", () {
      smartTextStore.setMessagesData(LoginList.list);
      smartTextStore.currentIndex = 1;
    });
  });
}
