import 'package:equatable/equatable.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

class CaptureSessionEnd
    implements AbstractFutureLogic<void, CaptureSessionEndParams> {
  final PosthogContract contract;

  CaptureSessionEnd({required this.contract});

  @override
  call(params) async => await contract.captureSessionEnd(params);
}

class CaptureSessionEndParams extends Equatable {
  final DateTime sessionsStartTime;
  final PresetTypes presetType;

  const CaptureSessionEndParams({
    required this.sessionsStartTime,
    required this.presetType,
  });

  @override
  List<Object> get props => [sessionsStartTime, presetType];
}
