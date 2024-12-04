// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';
part 'inverted_deeper_blue_to_deep_sea.g.dart';

class InvertedDeeperBlueToDeepSea = _InvertedDeeperBlueToDeepSeaBase
    with _$InvertedDeeperBlueToDeepSea;

abstract class _InvertedDeeperBlueToDeepSeaBase
    extends BaseBeachWaveMovieStore<NoParams> with Store {
  _InvertedDeeperBlueToDeepSeaBase()
      : super(
          shouldPaintSand: TwoSecondBeachTransitionMovie.shouldPaintSand,
        ) {
    movie = TwoSecondBeachTransitionMovie.getMovie(
      MovieTween(),
      WaterColorsAndStops.invertedDeeperBlue,
      WaterColorsAndStops.deepSeaWater,
    );
  }

  @override
  @action
  initMovie(NoParams params) {
    control = Control.playFromStart;
  }

  @override
  @action
  reverseMovie(NoParams params) {
    control = Control.playReverseFromEnd;
  }
}
