import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nokhte_backend/types/types.dart';

mixin NokhteGradients {
  LinearGradient get glacier => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFA0FCFF),
          Color(0xFF184AFF),
        ],
        stops: [0.0, 1.0],
      );

  LinearGradient get lagoon => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0048FF),
          Color(0xFF28FFF8),
        ],
        stops: [0.0, 1.0],
      );

  LinearGradient get slate => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF000000),
          Color(0xFF4B4B4B),
        ],
        stops: [0.0, 1.0],
      );

  LinearGradient get cottonCandy => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFF60CD),
          Color(0xFFFECAFF),
        ],
        stops: [0.0, 1.0],
      );

  LinearGradient get twilightSky => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFFB1E5),
          Color(0xFF3DBEFF),
        ],
        stops: [0.0, 1.0],
      );

  LinearGradient get amethyst => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF9500FF),
          Color(0xFFFF98CD),
        ],
        stops: [0.0, 1.0],
      );

  LinearGradient get sandstorm => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFF4800),
          Color(0xFFFF8C8C),
        ],
        stops: [0.0, 1.0],
      );

  LinearGradient get desertDawn => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFF6262),
          Color(0xFFFFD500),
        ],
        stops: [0.0, 1.0],
      );

  LinearGradient get ruby => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFF0F0F),
          Color(0xFFFF9C9C),
        ],
        stops: [0.0, 1.0],
      );

  Gradient mapProfileGradientToLinearGradient(ProfileGradient gradient) {
    switch (gradient) {
      case ProfileGradient.glacier:
        return glacier;
      case ProfileGradient.lagoon:
        return lagoon;
      case ProfileGradient.slate:
        return slate;
      case ProfileGradient.cottonCandy:
        return cottonCandy;
      case ProfileGradient.twilightSky:
        return twilightSky;
      case ProfileGradient.amethyst:
        return amethyst;
      case ProfileGradient.sandstorm:
        return sandstorm;
      case ProfileGradient.desertDawn:
        return desertDawn;
      case ProfileGradient.ruby:
        return ruby;
      case ProfileGradient.none:
        return twilightSky;
    }
  }

  static ProfileGradient getRandomGradient() {
    final randomGradient =
        ProfileGradient.values.where((g) => g != ProfileGradient.none).toList();
    return randomGradient[Random().nextInt(randomGradient.length)];
  }
}
