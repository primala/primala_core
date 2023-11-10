import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/modules/collective_session/domain/domain.dart';
import 'package:nokhte_backend/storage/perspectives_audio.dart';

class MoveIndividualPerspectivesAudioToCollectiveSpace
    implements
        AbstractFutureLogic<
            IndividualAudioMovementToCollectiveSpaceStatusEntity,
            CollectiveSessionAudioExtrapolationInfo> {
  final CollectiveSessionContract contract;

  MoveIndividualPerspectivesAudioToCollectiveSpace({
    required this.contract,
  });

  @override
  call(params) async =>
      await contract.moveIndividualPerspectivesAudioToCollectiveSpace(params);
}
