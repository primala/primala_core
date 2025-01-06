// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';
part 'any_to_blackout.g.dart';

class AnyToBlackout = _AnyToBlackoutBase with _$AnyToBlackout;

abstract class _AnyToBlackoutBase
    extends BaseBeachWaveMovieStore<DurationAndGradient> with Store {
  _AnyToBlackoutBase()
      : super(
          shouldPaintSand: TwoSecondBeachTransitionMovie.shouldPaintSand,
        ) {
    movie = TwoSecondBeachTransitionMovie.getMovie(
      MovieTween(),
      WaterColorsAndStops.blackOut,
      WaterColorsAndStops.drySand,
    );
  }

  @override
  @action
  initMovie(DurationAndGradient param) {
    movie = TwoSecondBeachTransitionMovie.getMovie(
      MovieTween(),
      param.gradient,
      WaterColorsAndStops.blackOut,
      end: param.duration,
    );
    control = Control.playFromStart;
  }
}
