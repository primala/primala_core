import 'package:flutter/material.dart';

mixin SessionConstants {
  static const blue = Color(0xFF00E0FF);
  static const white = Colors.white;
  static const limeTextGrad = [
    Color(0xFFA1FFAA),
    Color(0xFF39FF18),
  ];

  static const module = '/session';
  static const relativeLobby = '/lobby';
  static const relativeSessionStarter = '/session_starter';
  static const relativeMainScreen = '/main';
  static const relativeGreeter = '/greeter';
  static const relativePause = '/pause';
  static const relativeDocPicker = '/doc_picker';
  static const relativeExitSession = '/exit_session';

  static const lobby = '$module$relativeLobby';
  static const sessionStarter = '$module$relativeSessionStarter';
  static const mainScreen = '$module$relativeMainScreen';
  static const greeter = '$module$relativeGreeter';
  static const pause = '$module$relativePause';
  static const docPicker = '$module$relativeDocPicker';
  static const exitSession = '$module$relativeExitSession';
}
