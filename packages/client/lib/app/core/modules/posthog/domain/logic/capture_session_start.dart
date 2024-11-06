import 'package:equatable/equatable.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

class CaptureSessionStart
    implements AbstractFutureLogic<void, CaptureSessionStartParams> {
  final PosthogContract contract;

  CaptureSessionStart({required this.contract});

  @override
  call(params) async => await contract.captureSessionStart(params);
}

class CaptureSessionStartParams extends Equatable {
  final int numberOfCollaborators;
  final PresetTypes presetType;

  const CaptureSessionStartParams({
    required this.numberOfCollaborators,
    required this.presetType,
  });

  @override
  List<Object> get props => [numberOfCollaborators, presetType];
}
