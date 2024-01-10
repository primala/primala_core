// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:equatable/equatable.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/beach_widgets/shared/shared.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
part 'collaborator_pool_screen_widgets_coordinator.g.dart';

class CollaboratorPoolScreenWidgetsCoordinator = _CollaboratorPoolScreenWidgetsCoordinatorBase
    with _$CollaboratorPoolScreenWidgetsCoordinator;

abstract class _CollaboratorPoolScreenWidgetsCoordinatorBase extends Equatable
    with Store {
  final BeachWavesStore beachWaves;
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;
  // add waitingOnCollaborator text;

  _CollaboratorPoolScreenWidgetsCoordinatorBase({
    required this.beachWaves,
    required this.wifiDisconnectOverlay,
  });

  @action
  constructor() {
    beachWaves.setMovieMode(BeachWaveMovieModes.vibrantBlueGradientToTimesUp);
    beachWaves.currentStore.initMovie(NoParams());
    beachWavesMovieStatusReactor();
  }

  beachWavesMovieStatusReactor() =>
      reaction((p0) => beachWaves.movieStatus, (p0) {
        if (p0 == MovieStatus.finished &&
            beachWaves.movieMode ==
                BeachWaveMovieModes.vibrantBlueGradientToTimesUp) {
          beachWaves.setMovieMode(BeachWaveMovieModes.timesUp);
          beachWaves.currentStore.initMovie(Seconds.get(63));
        }
      });

  @override
  List<Object> get props => [];
}
