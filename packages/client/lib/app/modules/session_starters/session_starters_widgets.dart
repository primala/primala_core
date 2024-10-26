import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/widgets/modules.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'session_starters.dart';
export 'constants/constants.dart';
export 'data/data.dart';
export 'domain/domain.dart';
export 'presentation/presentation.dart';
export 'session_starters_logic.dart';

class SessionStartersWidgetsModule extends Module {
  @override
  List<Module> get imports => [
        ConnectivityModule(),
        GestureCrossModule(),
      ];

  @override
  void binds(Injector i) {
    i.add<SessionStarterWidgetsCoordinator>(
      () => SessionStarterWidgetsCoordinator(
        presetArticle: PresetArticleStore(
          nokhteBlur: NokhteBlurStore(),
        ),
        sessionScroller: SessionScrollerStore(),
        headerText: SmartTextStore(),
        presetCards: PresetCardsStore(),
        swipeGuide: SwipeGuideStore(),
        presetHeader: PresetHeaderStore(
          presetIcons: PresetIconsStore(),
        ),
        qrCode: NokhteQrCodeStore(),
        nokhteBlur: NokhteBlurStore(),
        gestureCross: Modular.get<GestureCrossStore>(),
        beachWaves: BeachWavesStore(),
        qrSubtitleSmartText: SmartTextStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        homeNokhte: AuxiliaryNokhteStore(),
        centerNokhte: CenterNokhteStore(),
      ),
    );
    i.add<SessionStarterEntryWidgetsCoordinator>(
      () => SessionStarterEntryWidgetsCoordinator(
        gestureCross: Modular.get<GestureCrossStore>(),
        beachWaves: BeachWavesStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
      ),
    );
  }
}
