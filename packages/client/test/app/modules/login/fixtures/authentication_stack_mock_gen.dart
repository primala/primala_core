// ignore_for_file: must_be_immutable
import 'package:mockito/annotations.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/modules/login/login.dart';

@GenerateMocks([
  LoginRemoteSourceImpl,
  LoginRemoteSource,
  LoginContract,
  CaptureScreen,
])
@GenerateNiceMocks(
    [MockSpec<IdentifyUser>(), MockSpec<LoginScreenWidgetsCoordinator>()])
void main() {}
