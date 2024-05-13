import 'package:mockito/annotations.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

@GenerateNiceMocks([
  MockSpec<WifiDisconnectOverlayStore>(),
  MockSpec<BeachWavesStore>(),
  MockSpec<GestureCrossStore>(),
  MockSpec<SmartTextStore>(),
  MockSpec<GetUserInfoStore>(),
  MockSpec<TrailingTextStore>(),
  MockSpec<NokhteBlurStore>(),
  MockSpec<NokhteStore>(),
  MockSpec<TapDetector>(),
])
void main() {}
