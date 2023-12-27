import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widget_constants.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/presentation/mobx/mobx.dart';
import 'package:simple_animations/simple_animations.dart';
import '../../../../shared/shared_mocks.mocks.dart';
import '../../../../shared/shared_utils.dart';

void main() {
  late BeachWavesStore beachWaves;
  late MockWifiDisconnectOverlayStore wifiDisconnectOverlay;
  late GestureCrossStore gestureCross;
  late SmartTextStore primarySmartText;
  late SmartTextStore secondarySmartText;
  late HomeScreenWidgetsCoordinator testStore;
  late NokhteBlurStore nokhteBlurStore;
  late TimeAlignmentModelCoordinator timeModel;
  setUp(() {
    timeModel = TimeAlignmentModelCoordinator(
      clockFace: ClockFaceStore(),
      availabilitySectors: AvailabilitySectorsStore(),
    );
    secondarySmartText = SmartTextStore();
    beachWaves = SharedTestUtils.getBeachWaves();
    wifiDisconnectOverlay = MockWifiDisconnectOverlayStore();
    gestureCross = GestureCrossStore();
    nokhteBlurStore = NokhteBlurStore();
    primarySmartText = SmartTextStore();

    testStore = HomeScreenWidgetsCoordinator(
      timeModel: timeModel,
      nokhteBlur: nokhteBlurStore,
      beachWaves: beachWaves,
      wifiDisconnectOverlay: wifiDisconnectOverlay,
      gestureCross: gestureCross,
      primarySmartText: primarySmartText,
      secondarySmartText: secondarySmartText,
    );
  });

  group("initial values", () {
    test("hasInitiatedBlur", () {
      expect(testStore.hasInitiatedBlur, false);
    });

    test("secondaryTextIsInProgress", () {
      expect(testStore.secondaryTextIsInProgress, false);
    });

    test("clockIsVisible", () {
      expect(testStore.clockIsVisible, false);
    });

    test("isDisconnected", () {
      expect(testStore.isDisconnected, false);
    });
  });

  group("actions", () {
    test("toggleSecondaryTextIsInProgress", () {
      testStore.toggleSecondaryTextIsInProgress();
      expect(testStore.secondaryTextIsInProgress, true);
      testStore.toggleSecondaryTextIsInProgress();
      expect(testStore.secondaryTextIsInProgress, false);
    });

    test("toggleClockIsVisible", () {
      testStore.toggleClockIsVisible();
      expect(testStore.clockIsVisible, true);
      testStore.toggleClockIsVisible();
      expect(testStore.clockIsVisible, false);
    });
    test("onConnected", () {
      testStore.onConnected();
      expect(testStore.isDisconnected, false);
    });

    test("onDisconnected", () {
      testStore.onDisconnected();
      expect(testStore.isDisconnected, true);
    });
    test("constructor", () async {
      await testStore.constructor();
      expect(primarySmartText.messagesData, MessagesData.firstTimeHomeList);
      expect(secondarySmartText.messagesData,
          MessagesData.firstTimeSecondaryHomeList);
      expect(beachWaves.movieMode, BeachWaveMovieModes.onShore);
      verify(wifiDisconnectOverlay.connectionReactor(
        onConnected: testStore.onConnected,
        onDisconnected: testStore.onDisconnected,
      ));
    });

    group("constructor dependendent", () {
      setUp(() => testStore.constructor());
      test("onAvailabilitySectorMovieStatusFinished", () {
        timeModel.availabilitySectors.setPastControl(Control.playFromStart);
        testStore.onAvailabilitySectorMovieStatusFinished(MovieStatus.finished);
        expect(timeModel.clockFace.control, Control.playReverseFromEnd);
        expect(secondarySmartText.control, Control.stop);
        expect(beachWaves.currentControl, Control.mirror);
        expect(testStore.secondarySmartText.showWidget, false);
        expect(nokhteBlurStore.control, Control.playReverseFromEnd);
      });

      test("onClockFaceAnimationFinished", () {
        fakeAsync((async) {
          testStore.onClockFaceAnimationFinished(MovieStatus.finished);
          async.elapse(Seconds.get(10));
          expect(secondarySmartText.control, Control.playFromStart);
          expect(testStore.clockIsVisible, true);
        });
      });
      test("onSecondarySmartTextTransitions", () {
        fakeAsync((async) async {
          await testStore.onSecondarySmartTextTransitions(2);
          async.elapse(Seconds.get(10));
          expect(testStore.secondaryTextIsInProgress, true);
          expect(secondarySmartText.currentIndex, 0);
          expect(secondarySmartText.control, Control.playFromStart);
        });
      });
      group("onGestureCrossTap", () {
        test("if !isDisconnected + !hasInitiatedBlur", () {
          fakeAsync((async) async {
            await testStore.onGestureCrossTap();
            async.elapse(Seconds.get(10));
            expect(nokhteBlurStore.control, Control.playFromStart);
            expect(primarySmartText.control, Control.playFromStart);
            expect(beachWaves.currentControl, Control.playFromStart);
          });
        });
        test("if clockIsVisible && !secondaryTextIsInProgress", () {
          testStore.toggleClockIsVisible();
          fakeAsync((async) async {
            await testStore.onGestureCrossTap();
            async.elapse(Seconds.get(10));
            expect(testStore.secondaryTextIsInProgress, true);
            expect(secondarySmartText.control, Control.playReverse);
          });
        });
      });
    });
  });
}
