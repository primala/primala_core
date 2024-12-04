import 'package:nokhte/app/core/widgets/widgets.dart';

mixin BeachWaveMovies {
  static Map<BeachWaveMovieModes, BaseBeachWaveMovieStore> getMap() => {
        BeachWaveMovieModes.anyToOnShore: AnyToOnShore(),
        BeachWaveMovieModes.anyToSky: AnyToSky(),
        BeachWaveMovieModes.anyToHalfAndHalf: AnyToHalfAndHalf(),
        BeachWaveMovieModes.anyToInvertedHalfAndHalf:
            AnyToInvertedHalfAndHalf(),
        BeachWaveMovieModes.borealisToSky: BorealisToSky(),
        BeachWaveMovieModes.invertedDeeperBlueToDeepSea:
            InvertedDeeperBlueToDeepSea(),
        BeachWaveMovieModes.blackOutToDrySand: BlackOutToDrySand(),
        BeachWaveMovieModes.deepSeaToBorealis: DeepSeaToBorealis(),
        BeachWaveMovieModes.deepSeaToSky: DeepSeaToSky(),
        BeachWaveMovieModes.deepSeaToHalfAndHalf: DeepSeaToHalfAndHalf(),
        BeachWaveMovieModes.emptyTheOcean: EmptyTheOcean(),
        BeachWaveMovieModes.deepSeaToInvertedHalfAndHalf:
            DeepSeaToInvertedHalfAndHalf(),
        BeachWaveMovieModes.drySandToSky: DrySandToSky(),
        BeachWaveMovieModes.emptyOceanToInvertedDeepSea:
            EmptyOceanToInvertedDeepSea(),
        BeachWaveMovieModes.halfAndHalfToDrySand: HalfAndHalfToDrySand(),
        BeachWaveMovieModes.invertedOnShore: InvertedOnShore(),
        BeachWaveMovieModes.invertedOnShoreToInvertedDeepSea:
            InvertedOnShoreToInvertedDeepSea(),
        BeachWaveMovieModes.invertedOnShoreToInvertedOceanDive:
            InvertedOnShoreToInvertedOceanDive(),
        BeachWaveMovieModes.invertedOnShoreToInvertedDeeperBlue:
            InvertedOnShoreToInvertedDeeperBlue(),
        BeachWaveMovieModes.invertedHalfAndHalfToDrySand:
            InvertedHalfAndHalfToDrySand(),
        BeachWaveMovieModes.none: BaseBeachWaveMovieStore(),
        BeachWaveMovieModes.oceanDiveToSky: OceanDiveToSky(),
        BeachWaveMovieModes.onShore: OnShore(),
        BeachWaveMovieModes.onShoreToDeepSea: OnShoreToDeepSea(),
        BeachWaveMovieModes.onShoreToDrySand: OnShoreToDrySand(),
        BeachWaveMovieModes.onShoreToOceanDive: OnShoreToOceanDive(),
        BeachWaveMovieModes.onShoreToSky: OnShoreToSky(),
        BeachWaveMovieModes.orangeSandToSky: OrangeSandToSky(),
        BeachWaveMovieModes.orangeSandToHalfAndHalf: OrangeSandToHalfAndHalf(),
        BeachWaveMovieModes.resumeOnShore: ResumeOnShore(),
        BeachWaveMovieModes.skyToHalfAndHalf: SkyToHalfAndHalf(),
        BeachWaveMovieModes.skyToInvertedHalfAndHalf:
            SkyToInvertedHalfAndHalf(),
        BeachWaveMovieModes.skyToDrySand: SkyToDrySand(),
        BeachWaveMovieModes.waterFromTopToOnShorePt1:
            WaterFromTopToOnShorePart1(),
        BeachWaveMovieModes.waterFromTopToOnShorePt2:
            WaterFromTopToOnShorePart2(),
      };
}
