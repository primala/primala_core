// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/update_existing_collaborations/mobx/coordinator/update_existing_collaborations_coordinator.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/beach_widgets/shared/shared.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/p2p_collaborator_pool/presentation/mobx/mobx.dart';

part 'collaborator_pool_screen_coordinator_store.g.dart';

class CollaboratorPoolScreenCoordinatorStore = _CollaboratorPoolScreenCoordinatorStoreBase
    with _$CollaboratorPoolScreenCoordinatorStore;

abstract class _CollaboratorPoolScreenCoordinatorStoreBase
    extends BaseCoordinator with Store {
  final ExitCollaboratorPoolStore exitCollaboratorPoolStore;
  final CancelCollaboratorStreamStore cancelStreamStore;
  final GetCollaboratorSearchStatusStore getCollaboratorSearchStatusStore;
  final FadeInAndChangeColorTextStore fadeInAndColorTextStore;
  final UpdateExistingCollaborationsCoordinator updateExistingCollaborations;

  _CollaboratorPoolScreenCoordinatorStoreBase({
    required this.exitCollaboratorPoolStore,
    required this.updateExistingCollaborations,
    required this.cancelStreamStore,
    required this.getCollaboratorSearchStatusStore,
    required super.beachWaves,
    required this.fadeInAndColorTextStore,
  });

  beachWavesMovieStatusListener() =>
      reaction((p0) => beachWaves.movieStatus, (p0) {
        if (beachWaves.movieMode == BeachWaveMovieModes.timesUp) {
          if (beachWaves.movieStatus == MovieStatus.finished) {
            beachWaves.initiateBackToOceanDive();
            Future.delayed(Seconds.get(3), () async {
              await cleanUpAndTransitionBackToOceanDive();
            });
          } else if (beachWaves.movieStatus == MovieStatus.inProgress) {
            delayedNavigation(() async {
              beachWaves.initiateBackToOceanDive();
              await cleanUpAndTransitionBackToOceanDive();
            });
          }
        } else if (beachWaves.movieMode ==
            BeachWaveMovieModes.backToTheDepths) {
          if (beachWaves.movieStatus == MovieStatus.finished) {
            Modular.to.navigate('/p2p_purpose_session/');
          } else if (beachWaves.movieStatus == MovieStatus.inProgress) {
            delayedNavigation(() {
              Modular.to.navigate('/p2p_purpose_session/');
            });
          }
        }
      });

  cleanUpAndTransitionBackToOceanDive() async {
    await exitCollaboratorPoolStore(NoParams());
    await cancelStreamStore(NoParams());
    Modular.to.navigate('/p2p_collaborator_pool/');
  }

  searchStatusListener() =>
      reaction((p0) => getCollaboratorSearchStatusStore.searchStatus, (p0) {
        p0.listen((value) async {
          if (value.hasFoundTheirCollaborator && !value.hasEntered) {
            Future.delayed(Seconds.get(2), () {
              beachWaves.teeUpBackToTheDepths();
              fadeInAndColorTextStore.teeUpFadeOut();
            });
            await updateExistingCollaborations
                .updateIndividualCollaboratorEntryStatus(true);
          }
        });
      });

  @action
  screenConstructorCallback() {
    final duration = kDebugMode ? Seconds.get(10) : Seconds.get(45);
    beachWaves.initiateTimesUp(
      timerLength: duration,
    );
    getCollaboratorSearchStatusStore();
    searchStatusListener();
    beachWavesMovieStatusListener();
  }
}
