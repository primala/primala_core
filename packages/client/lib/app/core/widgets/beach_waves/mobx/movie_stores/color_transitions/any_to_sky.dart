// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';
part 'any_to_sky.g.dart';

class AnyToSky = _AnyToSkyBase with _$AnyToSky;

abstract class _AnyToSkyBase
    extends BaseBeachWaveMovieStore<DurationAndGradient> with Store {
  _AnyToSkyBase()
      : super(
          shouldPaintSand: TwoSecondBeachTransitionMovie.shouldPaintSand,
        ) {
    movie = TwoSecondBeachTransitionMovie.getMovie(
      MovieTween(),
      WaterColorsAndStops.toTheDepthsWater,
      WaterColorsAndStops.toTheDepthsWater,
    );
  }

  @override
  initMovie(DurationAndGradient param) {
    movie = TwoSecondBeachTransitionMovie.getMovie(
      MovieTween(),
      param.gradient,
      WaterColorsAndStops.sky,
      end: param.duration,
    );
    control = Control.playFromStart;
  }

  @override
  reverseMovie(DurationAndGradient param) {
    movie = TwoSecondBeachTransitionMovie.getMovie(
      MovieTween(),
      param.gradient,
      WaterColorsAndStops.sky,
      end: param.duration,
    );
    control = Control.playReverseFromEnd;
  }
}
