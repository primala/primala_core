// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/nokhtes/nokhtes.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';
part 'auxiliary_nokhte_store.g.dart';

class AuxiliaryNokhteStore = _AuxiliaryNokhteStoreBase
    with _$AuxiliaryNokhteStore;

abstract class _AuxiliaryNokhteStoreBase
    extends BaseWidgetStore<NokhteScaleState> with Store {
  _AuxiliaryNokhteStoreBase() {
    setMovie(
      AuxiliaryNokhteMovies.fadeIn(
        screenSize,
        position: position,
        colorway: colorway,
      ),
    );
  }

  @observable
  ScreenSizeData screenSize = ScreenSizeData.zero();

  @action
  setScreenSize(ScreenSizeData value) {
    // print("SET SCREENSIZE");
    return screenSize = value;
  }

  @observable
  AuxiliaryNokhteMovieModes movieMode = AuxiliaryNokhteMovieModes.initial;

  @action
  setMovieMode(AuxiliaryNokhteMovieModes movieMode) =>
      this.movieMode = movieMode;

  @observable
  AuxiliaryNokhtePositions position = AuxiliaryNokhtePositions.bottom;
  @observable
  AuxiliaryNokhteColorways colorway = AuxiliaryNokhteColorways.beachWave;

  @action
  setAndFadeIn(
    AuxiliaryNokhtePositions position,
    AuxiliaryNokhteColorways colorway,
  ) {
    Timer.periodic(const Duration(milliseconds: 1), (timer) {
      if (screenSize.height != 0) {
        this.position = position;
        this.colorway = colorway;
        setMovie(
          AuxiliaryNokhteMovies.fadeIn(
            screenSize,
            position: position,
            colorway: colorway,
          ),
        );
        Timer(Seconds.get(0, milli: 1), () {
          setControl(Control.playFromStart);
        });
        setMovieStatus(MovieStatus.inProgress);
        timer.cancel();
      }
    });
  }

  @action
  explode() {
    setMovieMode(AuxiliaryNokhteMovieModes.explode);
    setMovie(
      AuxiliaryNokhteMovies.explode(
        screenSize,
        position: position,
        colorway: colorway,
      ),
    );
    setMovieStatus(MovieStatus.inProgress);
    setControl(Control.playFromStart);
  }

  @action
  disappear() {
    setMovieMode(AuxiliaryNokhteMovieModes.disappear);
    setMovie(
      AuxiliaryNokhteMovies.disappear(
        screenSize,
        position: position,
        colorway: colorway,
      ),
    );
    setMovieStatus(MovieStatus.inProgress);
    setControl(Control.playFromStart);
  }

  @override
  @action
  initMovie(params) {
    setMovieMode(AuxiliaryNokhteMovieModes.scale);
    setMovie(
      AuxiliaryNokhteMovies.scale(
        screenSize,
        position: position,
        colorway: colorway,
        direction: params,
      ),
    );
    setMovieStatus(MovieStatus.inProgress);
    setControl(Control.playFromStart);
  }

  @computed
  bool get textShouldBeOnTop => position != AuxiliaryNokhtePositions.bottom;

  @computed
  String get text {
    switch (colorway) {
      case AuxiliaryNokhteColorways.beachWave:
        return "Home";
      case AuxiliaryNokhteColorways.invertedBeachWave:
        return "Start";
      case AuxiliaryNokhteColorways.vibrantBlue:
        return "Notes";
      case AuxiliaryNokhteColorways.deeperBlue:
        return "Deactivate";
      case AuxiliaryNokhteColorways.orangeSand:
        return "Join";
      case AuxiliaryNokhteColorways.exitVibrantBlue:
        return 'Exit';
      case AuxiliaryNokhteColorways.informationTint:
        return 'Session Information';
      case AuxiliaryNokhteColorways.exitOrangeSand:
        return 'Exit';
    }
  }
}
