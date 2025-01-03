// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';
part 'half_and_half_to_dry_sand.g.dart';

class HalfAndHalfToDrySand = _HalfAndHalfToDrySandBase
    with _$HalfAndHalfToDrySand;

abstract class _HalfAndHalfToDrySandBase
    extends BaseBeachWaveMovieStore<NoParams> with Store {
  _HalfAndHalfToDrySandBase()
      : super(
          shouldPaintSand: TwoSecondBeachTransitionMovie.shouldPaintSand,
          callsOnCompleteTwice: false,
        ) {
    movie = TwoSecondBeachTransitionMovie.getMovie(
      MovieTween(),
      WaterColorsAndStops.halfWaterAndSand,
      WaterColorsAndStops.condensedDrySand,
    );
  }

  @override
  @action
  initMovie(NoParams params) {
    control = Control.playFromStart;
  }
}
