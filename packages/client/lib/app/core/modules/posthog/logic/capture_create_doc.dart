import 'package:nokhte/app/core/modules/posthog/posthog.dart';

class CaptureCreateDoc {
  final PosthogContract contract;

  CaptureCreateDoc({required this.contract});

  call() async => await contract.captureCreateDoc();
}
