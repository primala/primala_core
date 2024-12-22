import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';

mixin HomeNavigation on Reactions {
  SwipeGuideStore get swipeGuide;
  AuxiliaryNokhteStore get homeNokhte;
  CenterNokhteStore get centerNokhte;

  initHomeNavigationReactions() {
    disposers.add(centerNokhteReactor());
    disposers.add(homeNokhteReactor());
  }

  centerNokhteReactor() => reaction(
        (p0) => centerNokhte.movieStatus,
        (p0) {
          if (p0 == MovieStatus.finished &&
              centerNokhte.movieMode == CenterNokhteMovieModes.moveAround) {
            homeNokhte.explode();
          }
        },
      );

  homeNokhteReactor() => reaction((p0) => homeNokhte.movieStatus, (p0) {
        if (p0 == MovieStatus.finished &&
            homeNokhte.movieMode == AuxiliaryNokhteMovieModes.explode) {
          Modular.to.navigate(HomeConstants.entry);
        }
      });
}
