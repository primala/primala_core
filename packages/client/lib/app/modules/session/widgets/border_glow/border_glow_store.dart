// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/base_widget_store.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/session/widgets/border_glow/border_glow.dart';
import 'package:simple_animations/simple_animations.dart';
part 'border_glow_store.g.dart';

class BorderGlowStore = _BorderGlowStoreBase with _$BorderGlowStore;

abstract class _BorderGlowStoreBase extends BaseWidgetStore<NoParams>
    with Store {
  _BorderGlowStoreBase() {
    setMovie(BorderGlowMovies.glowUp());
  }

  @action
  @override
  initMovie(param) {
    setMovie(BorderGlowMovies.glowUp());
    setMovieStatus(MovieStatus.inProgress);
    setControl(Control.playFromStart);
  }

  @action
  resetCurrentBackToGreen() {
    setMovie(
      BorderGlowMovies.glowUp(
        startingColor: currentColor,
        startingWidth: currentWidth,
      ),
    );
    setControl(Control.playFromStart);
  }

  @action
  initGlowDown() {
    setMovie(BorderGlowMovies.glowDown(
      lastColor: currentColor,
      lastWidth: currentWidth,
    ));
    setControl(Control.playFromStart);
  }

  @action
  synchronizeGlow(
    DateTime startTime,
  ) {
    setMovie(
      BorderGlowMovies.synchronizeGlow(
        startTime: startTime,
      ),
    );

    setControl(Control.playFromStart);
  }

  @observable
  Color currentColor = Colors.transparent;

  @observable
  double currentWidth = 0.0;

  @action
  setAnimationValues({
    required Color color,
    required double width,
  }) {
    currentColor = color;
    currentWidth = width;
  }
}
