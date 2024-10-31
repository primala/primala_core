import 'package:mockito/annotations.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

@GenerateNiceMocks([
  MockSpec<WifiDisconnectOverlayStore>(),
  MockSpec<BeachWavesStore>(),
  MockSpec<GestureCrossStore>(),
  MockSpec<SmartTextStore>(),
  MockSpec<UserInformationCoordinator>(),
  MockSpec<NokhteBlurStore>(),
  MockSpec<TapDetector>(),
])
void main() {}
