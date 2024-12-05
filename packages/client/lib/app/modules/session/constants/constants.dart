import 'package:flutter/material.dart';

mixin SessionConstants {
  static const blue = Color(0xFF00E0FF);
  static const white = Colors.white;
  static const limeTextGrad = [
    Color(0xFFA1FFAA),
    Color(0xFF39FF18),
  ];

  static const isTheHost = 'isTheHost';

  static const shouldRefreshStream = 'shouldRefreshStream';

  static const module = '/session';
  static const relativeRoot = '/';

  static const coreModule = '/core';

  static const relativeSocraticSpeakingExit = '/socratic_speaking_exit';
  static const relativeActionSliderRouter = '/action_slider_router';

  static const relativePresets = '/presets';
  static const relativeLobby = '/lobby';
  static const relativeInformation = '/info';
  static const relativePause = '/pause';
  static const relativeRefreshRouter = '/refresh_router';
  static const relativeDuoGreeter = '/duo_greeter';
  static const relativeGroupGreeter = '/group_greeter';
  static const relativeCollaborationGreeter = '/collaboration_greeter';
  static const relativeTrialGreeter = '/trial_greeter';
  static const relativeExit = '/exit';
  static const relativePlaylists = '/playlists';

  static const relativeNotes = '/notes';

  static const relativeInstructions = '/instructions';
  static const relativeFullInstructions = '/full_instructions';
  static const relativeHalfInstructions = '/half_instructions';

  static const relativePaywall = '/paywall';

  static const socraticSpeakingExit =
      '$module$coreModule$relativeSocraticSpeakingExit';
  static const lobby = '$module$coreModule$relativeLobby';
  static const information = '$module$coreModule$relativeInformation';
  static const pause = '$module$hybridModule$relativePause';
  static const refreshRouter = '$module$coreModule$relativeRefreshRouter';
  static const actionSliderRouter =
      '$module$coreModule$relativeActionSliderRouter';
  static const collaborationGreeter =
      '$module$coreModule$relativeCollaborationGreeter';
  static const duoGreeter = '$module$coreModule$relativeDuoGreeter';
  static const groupGreeter = '$module$coreModule$relativeGroupGreeter';
  static const trialGreeter = '$module$coreModule$relativeTrialGreeter';
  static const exit = '$module$coreModule$relativeExit';
  static const presets = '$module$coreModule$relativePresets';
  static const playlists = '$module$coreModule$relativePlaylists';
  static const hybridModule = '/hybrid';

  static const relativeGroupHybrid = '/group_hybrid';
  static const relativeSoloHybrid = '/solo_hybrid';
  static const groupHybrid = '$module$hybridModule$relativeGroupHybrid';
  static const soloHybrid = '$module$hybridModule$relativeSoloHybrid';

  static const monetizeModule = '/monetize';

  static const paywall = '$module$monetizeModule$relativePaywall';

  static const notesModule = '/notes';
  static const notes = '$module$notesModule$relativeRoot';

  static const polymorphicModule = '/polymorphic';
  static const polymorphicSolo = '$module$polymorphicModule$relativeRoot';
}
