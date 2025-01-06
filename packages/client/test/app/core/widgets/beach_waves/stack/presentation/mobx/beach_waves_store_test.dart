import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';

import '../../../../../../modules/shared/shared_test_utils.dart';

void main() {
  late BeachWavesStore testStore;
  List mockAnimationValues = [
    0.0, // water y values
    Colors.black, // water colors
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black,
    0.0, // water stops
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
  ];

  setUp(() {
    testStore = SharedTestUtils.getBeachWaves();
  });

  group("initial values", () {
    test("movieMode", () {
      testStore.movieMode = BeachWaveMovieModes.onShore;
    });

    group('movieModeToStoreLookup', () {
      test("onShore key", () {
        final onShoreRes =
            testStore.movieModeToStoreLookup[BeachWaveMovieModes.onShore];
        expect(onShoreRes?.movie.duration, Seconds.get(1));
      });
      test("onShoreToOceanDive key", () {
        final res = testStore
            .movieModeToStoreLookup[BeachWaveMovieModes.onShoreToOceanDive];
        expect(res?.movie.duration, Seconds.get(1));
      });
      test("onShoreToOceanDive key", () {
        final oceanDiveRes = testStore
            .movieModeToStoreLookup[BeachWaveMovieModes.onShoreToOceanDive];
        expect(oceanDiveRes?.movie.duration, Seconds.get(1));
      });
      test("none key", () {
        final noneRes =
            testStore.movieModeToStoreLookup[BeachWaveMovieModes.none];
        expect(noneRes?.movie.duration, Seconds.get(0));
      });
    });

    group("computed values", () {
      test("currentControl", () {
        final currentControlRes = testStore.currentControl;
        expect(currentControlRes, Control.mirror);
      });

      test("shouldPaintSandOnCurrent", () {
        final currentControlRes = testStore.shouldPaintSandOnCurrent;
        expect(currentControlRes, true);
      });
      test("currentMovie", () {
        final currentMovieDuration = testStore.currentMovie.duration;
        expect(currentMovieDuration, Seconds.get(1));
      });
    });
  });

  group("actions", () {
    test('setMovieMode', () {
      testStore.setMovieMode(BeachWaveMovieModes.onShoreToOceanDive);
      expect(testStore.movieMode, BeachWaveMovieModes.onShoreToOceanDive);
    });
  });

  test("setPivotColors", () {
    testStore.setPivotColors(mockAnimationValues);
    expect(testStore.pivotColors, WaterColorsAndStops.blackOut);
  });

  group("computed values", () {
    setUp(() {
      testStore.setMovieMode(BeachWaveMovieModes.onShore);
    });
    test("currentControl", () {
      expect(testStore.currentControl, Control.mirror);
    });

    test("currentMovie", () {
      expect(testStore.currentMovie.duration, Seconds.get(1));
    });

    test('currentStore', () {
      expect(testStore.currentStore, isA<OnShore>());
    });
    test('currentMovieStatus', () {
      expect(testStore.currentMovieStatus, MovieStatus.idle);
    });
  });
}
