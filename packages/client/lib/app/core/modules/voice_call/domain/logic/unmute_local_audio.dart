import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/modules/voice_call/domain/domain.dart';

class UnmuteLocalAudio extends AbstractFutureLogic<bool, NoParams> {
  final VoiceCallContract contract;

  UnmuteLocalAudio({required this.contract});

  @override
  call(NoParams params) async => contract.unmuteLocalAudio();
}
