// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';
part 'any_to_on_shore.g.dart';

class AnyToOnShore = _AnyToOnShoreBase with _$AnyToOnShore;

abstract class _AnyToOnShoreBase
    extends BaseBeachWaveMovieStore<AnyToOnShoreParams> with Store {
  _AnyToOnShoreBase()
      : super(
          shouldPaintSand: AnyToShoreMovie.shouldPaintSand,
        ) {
    movie = AnyToShoreMovie.getMovie(WaterColorsAndStops.oceanDiveWater);
  }
  @override
  @action
  initMovie(AnyToOnShoreParams params) {
    movie = AnyToShoreMovie.getMovie(
      params.startingColors,
      endingColors: params.endingColors,
      endValue: params.endValue,
    );
    control = Control.playFromStart;
  }

  @override
  @action
  reverseMovie(AnyToOnShoreParams params) {
    callsOnCompleteTwice = true;
    movie = AnyToShoreMovie.getMovie(
      params.startingColors,
      endingColors: params.endingColors,
      endValue: params.endValue,
    );
    control = Control.playReverseFromEnd;
  }
}
