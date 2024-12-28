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
  final DateTime sessionsStartTime;
  final int numberOfCollaborators;

  const CaptureSessionEndParams({
    required this.sessionsStartTime,
    required this.numberOfCollaborators,
  });

  @override
  List<Object> get props => [sessionsStartTime, numberOfCollaborators];
}
