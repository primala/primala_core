import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:simple_animations/simple_animations.dart';

mixin EnRouteRouter on EnRoute {
  getModularArgs(ResumeOnShoreParams params) => {
        HomeConstants.RESUME_ON_SHORE_PARAMS: params,
      };
}

mixin EnRouteWidgetsRouter on EnRoute, Reactions {
  BeachWavesStore get beachWaves;

  final _waterDirection = Observable(WaterDirection.down);

  WaterDirection get waterDirecton => _waterDirection.value;

  _setWaterDirection(WaterDirection params) => _waterDirection.value = params;

  Action actionSetWaterDirection = Action(() {});

  initEnRouteWidgetsActions() {
    actionSetWaterDirection = Action(_setWaterDirection);
  }

  setWaterDirection(WaterDirection params) => actionSetWaterDirection([params]);

  beachWavesMovieStatusReactor() =>
      reaction((p0) => beachWaves.movieStatus, (p0) {
        if (beachWaves.movieStatus == MovieStatus.finished) {
          beachWaves.setMovieStatus(MovieStatus.inProgress);
          if (waterDirecton == WaterDirection.up) {
            beachWaves.currentStore.setControl(Control.playFromStart);
            setWaterDirection(WaterDirection.down);
          } else {
            beachWaves.currentStore.setControl(Control.playReverseFromEnd);
            setWaterDirection(WaterDirection.up);
          }
        }
      });

  setupEnRouteWidgets({
    bool initReator = true,
  }) {
    initEnRouteActions();
    initEnRouteWidgetsActions();
    if (initReator) {
      disposers.add(beachWavesMovieStatusReactor());
    }
  }
}

mixin EnRoute {
  final _params = Observable(const ResumeOnShoreParams());

  ResumeOnShoreParams get params => _params.value;

  _setParams(ResumeOnShoreParams params) => _params.value = params;

  Action actionSetParams = Action(() {});

  initEnRouteActions() {
    actionSetParams = Action(_setParams);
  }

  setParams(ResumeOnShoreParams params) => actionSetParams([params]);

  bool get hasReceivedRoutingArgs => Modular.args.data.toString() != 'null';
}

mixin EnRouteConsumer on EnRoute, Reactions {
  BeachWavesStore get beachWaves;

  consumeRoutingArgs({
    bool isInverted = false,
  }) {
    if (isInverted) {
      setParams(const ResumeOnShoreParams(isInverted: true));
    }
    if (hasReceivedRoutingArgs) {
      setParams(Modular.args.data[HomeConstants.RESUME_ON_SHORE_PARAMS]);
    }
    beachWaves.setMovieMode(BeachWaveMovieModes.resumeOnShore);
    beachWaves.currentStore.initMovie(params);
  }
}
