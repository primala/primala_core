// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:equatable/equatable.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'dart:core';
import 'package:simple_animations/simple_animations.dart';
part 'beach_waves_store.g.dart';

class BeachWavesStore = _BeachWavesStoreBase with _$BeachWavesStore;

abstract class _BeachWavesStoreBase extends Equatable with Store {
  _BeachWavesStoreBase() {
    movieModeToStoreLookup = {
      BeachWaveMovieModes.anyToOnShore: AnyToOnShoreMovieStore(),
      BeachWaveMovieModes.anyToSky: AnyToSkyMovieStore(),
      BeachWaveMovieModes.anyToHalfAndHalf: AnyToHalfAndHalfMovieStore(),
      BeachWaveMovieModes.anyToInvertedHalfAndHalf:
          AnyToInvertedHalfAndHalfMovieStore(),
      BeachWaveMovieModes.borealisToSky: BorealisToSkyMovieStore(),
      BeachWaveMovieModes.blackOut: StaticBlackOutMovieStore(),
      BeachWaveMovieModes.blackOutToDrySand: BlackOutToDrySandMovieStore(),
      BeachWaveMovieModes.deepSeaToBorealis: DeepSeaToBorealisMovieStore(),
      BeachWaveMovieModes.deepSeaToSky: DeepSeaToSkyMovieStore(),
      BeachWaveMovieModes.drySandToSky: DrySandToSkyMovieStore(),
      BeachWaveMovieModes.halfAndHalfToDrySand:
          HalfAndHalfToDrySandMovieStore(),
      BeachWaveMovieModes.invertedOnShore: InvertedOnShoreMovieStore(),
      BeachWaveMovieModes.invertedOnShoreToInvertedDeepSea:
          InvertedOnShoreToInvertedDeepSeaMovieStore(),
      BeachWaveMovieModes.invertedOnShoreToInvertedOceanDive:
          InvertedOnShoreToInvertedOceanDiveMovieStore(),
      BeachWaveMovieModes.invertedOnShoreToInvertedSky:
          InvertedOnShoreToInvertedSkyMovieStore(),
      BeachWaveMovieModes.invertedHalfAndHalfToDrySand:
          InvertedHalfAndHalfToDrySandMovieStore(),
      BeachWaveMovieModes.none: BaseBeachWaveMovieStore(),
      BeachWaveMovieModes.oceanDiveToSky: OceanDiveToSkyMovieStore(),
      BeachWaveMovieModes.onShore: OnShoreMovieStore(),
      BeachWaveMovieModes.onShoreToDeepSea: OnShoreToDeepSeaMovieStore(),
      BeachWaveMovieModes.onShoreToDrySand: OnShoreToDrySandMovieStore(),
      BeachWaveMovieModes.onShoreToOceanDive: OnShoreToOceanDiveMovieStore(),
      BeachWaveMovieModes.onShoreToSky: OnShoreToSkyMovieStore(),
      BeachWaveMovieModes.resumeOnShore: ResumeOnShoreMovieStore(),
      BeachWaveMovieModes.staticHalfAndHalf: StaticHalfAndHalfMovieStore(),
      BeachWaveMovieModes.staticDepths: StaticDepthsMovieStore(),
      BeachWaveMovieModes.staticOceanDive: StaticOceanDiveStore(),
      BeachWaveMovieModes.skyToHalfAndHalf: SkyToHalfAndHalfMovieStore(),
      BeachWaveMovieModes.skyToInvertedHalfAndHalf:
          SkyToInvertedHalfAndHalfMovieStore(),
      BeachWaveMovieModes.skyToDrySand: SkyToDrySandMovieStore(),
      BeachWaveMovieModes.waterFromTopToOnShorePt1:
          WaterFromTopToOnShoreMoviePart1Store(),
      BeachWaveMovieModes.waterFromTopToOnShorePt2:
          WaterFromTopToOnShoreMoviePart2Store(),
    };
  }

  Map<BeachWaveMovieModes, BaseBeachWaveMovieStore> movieModeToStoreLookup = {};

  @observable
  ObservableList currentAnimationValues = ObservableList.of([]);

  @action
  setCurrentAnimationValues(newList) =>
      currentAnimationValues = ObservableList.of(newList);

  @observable
  int finishedCount = 0;

  @action
  onCompleted() {
    if (currentStore.callsOnCompleteTwice) {
      if (finishedCount == 0) {
        finishedCount++;
      } else {
        setMovieStatus(MovieStatus.finished);
        currentStore.setMovieStatus(MovieStatus.finished);
      }
    } else {
      setMovieStatus(MovieStatus.finished);
      currentStore.setMovieStatus(MovieStatus.finished);
    }
  }

  @observable
  ObservableList<ColorAndStop> pivotColors = ObservableList.of([]);

  @action
  setPivotColors(List currentAnimationValues) {
    pivotColors = ObservableList.of([
      ColorAndStop(currentAnimationValues[1], currentAnimationValues[9]),
      ColorAndStop(currentAnimationValues[2], currentAnimationValues[10]),
      ColorAndStop(currentAnimationValues[3], currentAnimationValues[11]),
      ColorAndStop(currentAnimationValues[4], currentAnimationValues[12]),
      ColorAndStop(currentAnimationValues[5], currentAnimationValues[13]),
      ColorAndStop(currentAnimationValues[6], currentAnimationValues[14]),
      ColorAndStop(currentAnimationValues[7], currentAnimationValues[15]),
      ColorAndStop(currentAnimationValues[8], currentAnimationValues[16]),
    ]);
  }

  @computed
  List<ColorAndStop> get currentColorsAndStops => [
        ColorAndStop(currentAnimationValues[1], currentAnimationValues[9]),
        ColorAndStop(currentAnimationValues[2], currentAnimationValues[10]),
        ColorAndStop(currentAnimationValues[3], currentAnimationValues[11]),
        ColorAndStop(currentAnimationValues[4], currentAnimationValues[12]),
        ColorAndStop(currentAnimationValues[5], currentAnimationValues[13]),
        ColorAndStop(currentAnimationValues[6], currentAnimationValues[14]),
        ColorAndStop(currentAnimationValues[7], currentAnimationValues[15]),
        ColorAndStop(currentAnimationValues[8], currentAnimationValues[16]),
      ];

  @observable
  MovieStatus movieStatus = MovieStatus.idle;

  @action
  setMovieStatus(MovieStatus newMovieStatus) => movieStatus = newMovieStatus;

  @observable
  BeachWaveMovieModes movieMode = BeachWaveMovieModes.onShore;

  @action
  setMovieMode(BeachWaveMovieModes newMovieMode) {
    finishedCount = 0;
    movieStatus = MovieStatus.idle;
    movieMode = newMovieMode;
  }

  @computed
  BaseBeachWaveMovieStore get currentStore =>
      movieModeToStoreLookup[movieMode] ?? OnShoreMovieStore();

  @computed
  Control get currentControl =>
      movieModeToStoreLookup[movieMode]?.control ?? Control.mirror;

  @computed
  bool get shouldPaintSandOnCurrent => currentStore.shouldPaintSand;

  @computed
  MovieStatus get currentMovieStatus =>
      movieModeToStoreLookup[movieMode]?.movieStatus ?? MovieStatus.idle;

  @computed
  MovieTween get currentMovie =>
      movieModeToStoreLookup[movieMode]?.movie ?? MovieTween();

  @override
  List<Object> get props => [];
}
