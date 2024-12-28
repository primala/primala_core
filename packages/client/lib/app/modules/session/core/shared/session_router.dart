import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/company_presets/types/types.dart';
export './session_router.dart';

mixin SessionRouter {
  BeachWavesStore get beachWaves;
  initTransition(SessionScreenTypes phoneType) {
    beachWaves.setMovieMode(BeachWaveMovieModes.skyToHalfAndHalf);
    beachWaves.currentStore.initMovie(const NoParams());
  }

  route({
    required bool isACollaborativeSession,
  }) {
    if (beachWaves.movieMode == BeachWaveMovieModes.skyToHalfAndHalf) {
      if (isACollaborativeSession) {
        Modular.to.navigate(SessionConstants.soloHybrid);
      } else {
        Modular.to.navigate(SessionConstants.groupHybrid);
      }
    } else if (beachWaves.movieMode == BeachWaveMovieModes.skyToDrySand) {
      Modular.to.navigate(SessionConstants.notes);
    }
  }

  beachWavesMovieStatusReactor({
    required bool isACollaborativeSession,
  }) =>
      reaction((p0) => beachWaves.movieStatus, (p0) {
        if (p0 == MovieStatus.finished) {
          route(isACollaborativeSession: isACollaborativeSession);
        }
      });
}
