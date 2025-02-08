import 'package:equatable/equatable.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';

class CaptureSessionEnd
    implements AbstractFutureLogic<void, CaptureSessionEndParams> {
  final PosthogContract contract;

  CaptureSessionEnd({required this.contract});

  @override
  call(params) async => await contract.captureSessionEnd(params);
}

class CaptureSessionEndParams extends Equatable {
  final DateTime sessionStartTime;
  final int numberOfCollaborators;

  const CaptureSessionEndParams({
    required this.sessionStartTime,
    required this.numberOfCollaborators,
  });

  @override
  List<Object> get props => [sessionStartTime, numberOfCollaborators];
}
