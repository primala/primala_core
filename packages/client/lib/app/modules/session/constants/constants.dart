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

  static const lobby = '$module$relativeLobby';
}
