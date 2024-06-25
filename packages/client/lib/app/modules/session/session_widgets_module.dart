import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/widgets/modules.dart';
import 'package:nokhte/app/core/widgets/widget_modules/mirrored_text_module.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'monetize/monetize.dart';
import 'session.dart';

class SessionWidgetsModule extends Module {
  @override
  List<Module> get imports => [
        MirroredTextModule(),
        WifiDisconnectOverlayModule(),
        GestureCrossModule(),
      ];
  @override
  void exportedBinds(Injector i) {
    injectCore(i);
    injectInstructions(i);
    injectHybrid(i);
    injectSpeaking(i);
    injectNotes(i);
    injectMonetization(i);
  }

  injectInstructions(i) {
    i.add<SocraticJustSymbolsWidgetsCoordinator>(
      () => SocraticJustSymbolsWidgetsCoordinator(
        smartText: SmartTextStore(),
        touchRipple: TouchRippleStore(),
        beachWaves: BeachWavesStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        presetDiagram: PresetDiagramStore(),
      ),
    );
    i.add<SocraticFullInstructionsWidgetsCoordinator>(
      () => SocraticFullInstructionsWidgetsCoordinator(
        smartText: SmartTextStore(),
        touchRipple: TouchRippleStore(),
        beachWaves: BeachWavesStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        presetDiagram: PresetDiagramStore(),
      ),
    );
    i.add<CollaborationJustSymbolsWidgetsCoordinator>(
      () => CollaborationJustSymbolsWidgetsCoordinator(
        smartText: SmartTextStore(),
        touchRipple: TouchRippleStore(),
        beachWaves: BeachWavesStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        presetDiagram: PresetDiagramStore(),
      ),
    );
    i.add<SoloHybridInstructionsWidgetsCoordinator>(
      () => SoloHybridInstructionsWidgetsCoordinator(
        smartText: SmartTextStore(),
        touchRipple: TouchRippleStore(),
        beachWaves: BeachWavesStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        borderGlow: BorderGlowStore(),
        holdTimerIndicator: HoldTimerIndicatorStore(),
      ),
    );
    i.add<CollaborationFullInstructionsWidgetsCoordinator>(
      () => CollaborationFullInstructionsWidgetsCoordinator(
        presetDiagram: PresetDiagramStore(),
        smartText: SmartTextStore(),
        touchRipple: TouchRippleStore(),
        beachWaves: BeachWavesStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
      ),
    );
    i.add<ShowGroupGeometryWidgetsCoordinator>(
      () => ShowGroupGeometryWidgetsCoordinator(
        presetDiagram: PresetDiagramStore(),
        smartText: SmartTextStore(),
        touchRipple: TouchRippleStore(),
        beachWaves: BeachWavesStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
      ),
    );
    i.add<SessionNotesInstructionsWidgetsCoordinator>(
      () => SessionNotesInstructionsWidgetsCoordinator(
        touchRipple: TouchRippleStore(),
        beachWaves: BeachWavesStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        mirroredText: Modular.get<MirroredTextStore>(),
      ),
    );
    i.add<ConsultationNotesSymbolsWidgetsCoordinator>(
      () => ConsultationNotesSymbolsWidgetsCoordinator(
        touchRipple: TouchRippleStore(),
        presetDiagram: PresetDiagramStore(),
        beachWaves: BeachWavesStore(),
        smartText: SmartTextStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
      ),
    );
    i.add<ConsultationJustSymbolsWidgetsCoordinator>(
      () => ConsultationJustSymbolsWidgetsCoordinator(
        touchRipple: TouchRippleStore(),
        presetDiagram: PresetDiagramStore(),
        beachWaves: BeachWavesStore(),
        smartText: SmartTextStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
      ),
    );
    i.add<ConsultationSpeakingSymbolsWidgetsCoordinator>(
      () => ConsultationSpeakingSymbolsWidgetsCoordinator(
        touchRipple: TouchRippleStore(),
        presetDiagram: PresetDiagramStore(),
        beachWaves: BeachWavesStore(),
        smartText: SmartTextStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
      ),
    );

    i.add<SessionSpeakingInstructionsWidgetsCoordinator>(
      () => SessionSpeakingInstructionsWidgetsCoordinator(
        holdTimerIndicator: HoldTimerIndicatorStore(),
        touchRipple: TouchRippleStore(),
        mirroredText: Modular.get<MirroredTextStore>(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        borderGlow: BorderGlowStore(),
        beachWaves: BeachWavesStore(),
      ),
    );
  }

  injectCore(i) {
    i.add<SessionPreviewWidgetsCoordinator>(
      () => SessionPreviewWidgetsCoordinator(
        touchRipple: TouchRippleStore(),
        primarySmartText: SmartTextStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
        presetCard: ExpandedPresetCardsStore(),
      ),
    );
    i.add<SessionLobbyWidgetsCoordinator>(
      () => SessionLobbyWidgetsCoordinator(
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
        sessionPhonePlacementGuide: SessionPhonePlacementGuideStore(),
        tint: TintStore(),
        sessionSeatingGuide: SessionSeatingGuideStore(),
        touchRipple: TouchRippleStore(),
        primarySmartText: SmartTextStore(),
        secondarySmartText: SmartTextStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
      ),
    );
    i.add<SessionExitWidgetsCoordinator>(
      () => SessionExitWidgetsCoordinator(
        sessionExitStatusIndicator: SessionExitStatusIndicatorStore(),
        tint: TintStore(),
        gestureCross: Modular.get<GestureCrossStore>(),
        primarySmartText: SmartTextStore(),
        secondarySmartText: SmartTextStore(),
        beachWaves: BeachWavesStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
      ),
    );
  }

  injectSpeaking(i) {
    i.add<SessionSpeakingRootRouterWidgetsCoordinator>(
      () => SessionSpeakingRootRouterWidgetsCoordinator(
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
      ),
    );
    i.add<HalfSessionSpeakingInstructionsWidgetsCoordinator>(
      () => HalfSessionSpeakingInstructionsWidgetsCoordinator(
        halfScreenTint: HalfScreenTintStore(),
        holdTimerIndicator: HoldTimerIndicatorStore(),
        tint: TintStore(),
        errorSmartText: SmartTextStore(),
        touchRipple: TouchRippleStore(),
        mirroredText: Modular.get<MirroredTextStore>(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        borderGlow: BorderGlowStore(),
        beachWaves: BeachWavesStore(),
      ),
    );
    i.add<FullSessionSpeakingInstructionsWidgetsCoordinator>(
      () => FullSessionSpeakingInstructionsWidgetsCoordinator(
        holdTimerIndicator: HoldTimerIndicatorStore(),
        tint: TintStore(),
        errorSmartText: SmartTextStore(),
        touchRipple: TouchRippleStore(),
        mirroredText: Modular.get<MirroredTextStore>(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        borderGlow: BorderGlowStore(),
        beachWaves: BeachWavesStore(),
      ),
    );
    i.add<SessionSpeakingWaitingWidgetsCoordinator>(
      () => SessionSpeakingWaitingWidgetsCoordinator(
        tint: TintStore(),
        mirroredText: Modular.get<MirroredTextStore>(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
      ),
    );
    i.add<SessionSpeakingWidgetsCoordinator>(
      () => SessionSpeakingWidgetsCoordinator(
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
    i.add<SessionHybridRootRouterWidgetsCoordinator>(
      () => SessionHybridRootRouterWidgetsCoordinator(
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
      ),
    );
    i.add<SessionHybridWaitingWidgetsCoordinator>(
      () => SessionHybridWaitingWidgetsCoordinator(
        tint: TintStore(),
        mirroredText: Modular.get<MirroredTextStore>(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
      ),
    );
    i.add<SessionHybridSpeakingInstructionsWidgetsCoordinator>(
      () => SessionHybridSpeakingInstructionsWidgetsCoordinator(
        halfScreenTint: HalfScreenTintStore(),
        holdTimerIndicator: HoldTimerIndicatorStore(),
        tint: TintStore(),
        errorSmartText: SmartTextStore(),
        touchRipple: TouchRippleStore(),
        mirroredText: Modular.get<MirroredTextStore>(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        borderGlow: BorderGlowStore(),
        beachWaves: BeachWavesStore(),
      ),
    );
    i.add<SessionHybridNotesInstructionsWidgetsCoordinator>(
      () => SessionHybridNotesInstructionsWidgetsCoordinator(
        halfScreenTint: HalfScreenTintStore(),
        touchRipple: TouchRippleStore(),
        tint: TintStore(),
        mirroredText: Modular.get<MirroredTextStore>(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
      ),
    );
    i.add<SessionHybridWidgetsCoordinator>(
      () => SessionHybridWidgetsCoordinator(
        othersAreTalkingTint: HalfScreenTintStore(),
        speakLessSmileMore: SpeakLessSmileMoreStore(),
        touchRipple: TouchRippleStore(),
        mirroredText: Modular.get<MirroredTextStore>(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
        borderGlow: BorderGlowStore(),
      ),
    );
    i.add<SessionHybridNotesWidgetsCoordinator>(
      () => SessionHybridNotesWidgetsCoordinator(
        smartText: SmartTextStore(),
        borderGlow: BorderGlowStore(),
        touchRipple: TouchRippleStore(),
        textEditor: TextEditorStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
      ),
    );
    //
  }

  injectNotes(i) {
    i.add<SessionNotesWaitingWidgetsCoordinator>(
      () => SessionNotesWaitingWidgetsCoordinator(
        tint: TintStore(),
        mirroredText: Modular.get<MirroredTextStore>(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
      ),
    );
    i.add<HalfSessionNotesInstructionsWidgetsCoordinator>(
      () => HalfSessionNotesInstructionsWidgetsCoordinator(
        halfScreenTint: HalfScreenTintStore(),
        touchRipple: TouchRippleStore(),
        tint: TintStore(),
        mirroredText: Modular.get<MirroredTextStore>(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
      ),
    );
    i.add<SessionFullNotesInstructionsWidgetsCoordinator>(
      () => SessionFullNotesInstructionsWidgetsCoordinator(
        touchRipple: TouchRippleStore(),
        tint: TintStore(),
        mirroredText: Modular.get<MirroredTextStore>(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
      ),
    );
    i.add<SessionNotesWidgetsCoordinator>(
      () => SessionNotesWidgetsCoordinator(
        smartText: SmartTextStore(),
        touchRipple: TouchRippleStore(),
        textEditor: TextEditorStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        beachWaves: BeachWavesStore(),
      ),
    );
  }

  injectMonetization(i) {
    i.add<WaitingPatronWidgetsCoordinator>(
      () => WaitingPatronWidgetsCoordinator(
        gestureCross: Modular.get<GestureCrossStore>(),
        beachWaves: BeachWavesStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        nokhteGradientText: NokhteGradientTextStore(),
        tint: TintStore(),
      ),
    );
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
