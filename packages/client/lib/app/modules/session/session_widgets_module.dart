import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/widgets/modules.dart';
import 'package:nokhte/app/core/widgets/widget_modules/mirrored_text_module.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'monetize/monetize.dart';
import 'session.dart';

class SessionWidgetsModule extends Module {
  @override
  List<Module> get imports => [
        MirroredTextModule(),
        ConnectivityModule(),
        GestureCrossModule(),
        SessionNavigationModule(),
        SessionLogicModule(),
      ];
  @override
  void exportedBinds(Injector i) {
    injectCore(i);
    injectHybrid(i);
    injectPolymorphic(i);
    injectNotes(i);
    injectMonetization(i);
  }

  injectCore(i) {
    i.add<SessionInformationWidgetsCoordinator>(
      () => SessionInformationWidgetsCoordinator(
        presetArticle: PresetArticleStore(
          nokhteBlur: NokhteBlurStore(),
        ),
        tint: TintStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
        // presetCard: ExpandedPresetCardsStore(),
      ),
    );

    i.add<SessionRefreshWidgetsCoordinator>(
      () => SessionRefreshWidgetsCoordinator(
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
        // presetCard: ExpandedPresetCardsStore(),
      ),
    );

    i.add<SessionLobbyWidgetsCoordinator>(
      () => SessionLobbyWidgetsCoordinator(
        presetArticle: PresetArticleStore(
          nokhteBlur: NokhteBlurStore(),
        ),
        touchRipple: TouchRippleStore(),
        primarySmartText: SmartTextStore(),
        qrCode: NokhteQrCodeStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
      ),
    );
    i.add<SessionDuoGreeterWidgetsCoordinator>(
      () => SessionDuoGreeterWidgetsCoordinator(
        touchRipple: TouchRippleStore(),
        primarySmartText: SmartTextStore(),
        secondarySmartText: SmartTextStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
      ),
    );
    i.add<SessionCollaborationGreeterWidgetsCoordinator>(
      () => SessionCollaborationGreeterWidgetsCoordinator(
        touchRipple: TouchRippleStore(),
        primarySmartText: SmartTextStore(),
        secondarySmartText: SmartTextStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
      ),
    );
    i.add<SessionTrialGreeterWidgetsCoordinator>(
      () => SessionTrialGreeterWidgetsCoordinator(
        touchRipple: TouchRippleStore(),
        primarySmartText: SmartTextStore(),
        secondarySmartText: SmartTextStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
      ),
    );
    i.add<SessionGroupGreeterWidgetsCoordinator>(
      () => SessionGroupGreeterWidgetsCoordinator(
        touchRipple: TouchRippleStore(),
        primarySmartText: SmartTextStore(),
        secondarySmartText: SmartTextStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
      ),
    );
    i.add<SocraticSpeakingExitWidgetsCoordinator>(
      () => SocraticSpeakingExitWidgetsCoordinator(
        exitStatusIndicator: ExitStatusIndicatorStore(),
        primarySmartText: SmartTextStore(),
        secondarySmartText: SmartTextStore(),
        beachWaves: BeachWavesStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
      ),
    );
    i.add<SessionExitWidgetsCoordinator>(
      () => SessionExitWidgetsCoordinator(
        borderGlow: BorderGlowStore(),
        exitStatusIndicator: ExitStatusIndicatorStore(),
        tint: TintStore(),
        primarySmartText: SmartTextStore(),
        secondarySmartText: SmartTextStore(),
        beachWaves: BeachWavesStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
      ),
    );
  }

  injectPolymorphic(i) {
    i.add<PolymorphicSoloWidgetsCoordinator>(
      () => PolymorphicSoloWidgetsCoordinator(
        refreshBanner: RefreshBannerStore(),
        backButton: BackButtonStore(),
        primarySmartText: SmartTextStore(),
        secondarySmartText: SmartTextStore(),
        sessionNavigation: Modular.get<SessionNavigationStore>(),
        tint: TintStore(),
        speakLessSmileMore: SpeakLessSmileMoreStore(),
        touchRipple: TouchRippleStore(),
        mirroredText: Modular.get<MirroredTextStore>(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
        borderGlow: BorderGlowStore(),
      ),
    );
  }

  injectHybrid(i) {
    i.add<SessionSoloHybridWidgetsCoordinator>(
      () => SessionSoloHybridWidgetsCoordinator(
        presenceOverlay:
            Modular.get<SessionPresenceCoordinator>().incidentsOverlayStore,
        refreshBanner: RefreshBannerStore(),
        sessionNavigation: Modular.get<SessionNavigationStore>(),
        rally: RallyStore(
          backButton: BackButtonStore(),
          tint: TintStore(),
        ),
        primarySmartText: SmartTextStore(),
        secondarySmartText: SmartTextStore(),
        othersAreTalkingTint: HalfScreenTintStore(),
        speakLessSmileMore: SpeakLessSmileMoreStore(),
        touchRipple: TouchRippleStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
        borderGlow: BorderGlowStore(),
      ),
    );
    i.add<SessionGroupHybridWidgetsCoordinator>(
      () => SessionGroupHybridWidgetsCoordinator(
        presenceOverlay:
            Modular.get<SessionPresenceCoordinator>().incidentsOverlayStore,
        refreshBanner: RefreshBannerStore(),
        letEmCook: LetEmCookStore(),
        sessionNavigation: Modular.get<SessionNavigationStore>(),
        othersAreTalkingTint: TintStore(),
        othersAreTakingNotesTint: HalfScreenTintStore(),
        speakLessSmileMore: SpeakLessSmileMoreStore(),
        touchRipple: TouchRippleStore(),
        mirroredText: Modular.get<MirroredTextStore>(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
        borderGlow: BorderGlowStore(),
      ),
    );
  }

  injectNotes(i) {
    i.add<SessionNotesWidgetsCoordinator>(
      () => SessionNotesWidgetsCoordinator(
        smartText: SmartTextStore(),
        textEditor: TextEditorStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
      ),
    );
  }

  injectMonetization(i) {
    i.add<SessionPaywallWidgetsCoordinator>(
      () => SessionPaywallWidgetsCoordinator(
        multiplyingNokhte: MultiplyingNokhteStore(),
        gestureCross: Modular.get<GestureCrossStore>(),
        beachWaves: BeachWavesStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        touchRipple: TouchRippleStore(),
        primarySmartText: SmartTextStore(),
        secondarySmartText: SmartTextStore(),
        tertiarySmartText: SmartTextStore(),
      ),
    );
  }
}
