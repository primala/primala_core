import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/widgets/widget_modules/mirrored_text_module.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'session.dart';

class SessionWidgetsModule extends Module {
  @override
  List<Module> get imports => [
        MirroredTextModule(),
        ConnectivityModule(),
        GestureCrossModule(),
        NavigationMenuModule(),
        SessionNavigationModule(),
        SessionLogicModule(),
      ];
  @override
  void exportedBinds(Injector i) {
    injectCore(i);
    injectHybrid(i);
    injectNotes(i);
  }

  injectCore(i) {
    i.add<SessionInformationWidgetsCoordinator>(
      () => SessionInformationWidgetsCoordinator(
        tint: TintStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
        // presetCard: ExpandedPresetCardsStore(),
      ),
    );

    i.add<ActionSliderRouterWidgetsCoordinator>(
      () => ActionSliderRouterWidgetsCoordinator(
        beachWaves: BeachWavesStore(),
      ),
    );

    i.add<SessionPauseWidgetsCoordinator>(
      () => SessionPauseWidgetsCoordinator(
        tint: TintStore(),
        pauseIcon: PauseIconStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
      ),
    );

    i.add<SessionLobbyWidgetsCoordinator>(
      () => SessionLobbyWidgetsCoordinator(
        contextHeader: ContextHeaderStore(),
        navigationMenu: Modular.get<NavigationMenuStore>(),
        touchRipple: TouchRippleStore(),
        primarySmartText: SmartTextStore(),
        qrCode: NokhteQrCodeStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
      ),
    );

    i.add<SessionPlaylistsWidgetsCoordinator>(
      () => SessionPlaylistsWidgetsCoordinator(
        queueSelector: QueueSelectorStore(),
        navigationMenu: Modular.get<NavigationMenuStore>(),
        headerText: SmartTextStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
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

  injectHybrid(i) {
    i.add<SessionSoloHybridWidgetsCoordinator>(
      () => SessionSoloHybridWidgetsCoordinator(
        purposeBanner: PurposeBannerStore(
          nokhteBlur: NokhteBlurStore(),
        ),
        navigationMenu: Modular.get<NavigationMenuStore>(),
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
}
