import 'package:nokhte_backend/types/types.dart';

mixin ProfileGradientUtils {
  ProfileGradient mapStringToProfileGradient(String gradient) {
    switch (gradient) {
      case 'glacier':
        return ProfileGradient.glacier;
      case 'lagoon':
        return ProfileGradient.lagoon;
      case 'slate':
        return ProfileGradient.slate;
      case 'cottonCandy':
        return ProfileGradient.cottonCandy;
      case 'twilightSky':
        return ProfileGradient.twilightSky;
      case 'amethyst':
        return ProfileGradient.amethyst;
      case 'sandstorm':
        return ProfileGradient.sandstorm;
      case 'desertDawn':
        return ProfileGradient.desertDawn;
      case 'ruby':
        return ProfileGradient.ruby;
      default:
        return ProfileGradient.none;
    }
  }

  String mapProfileGradientToString(ProfileGradient gradient) {
    switch (gradient) {
      case ProfileGradient.glacier:
        return 'glacier';
      case ProfileGradient.lagoon:
        return 'lagoon';
      case ProfileGradient.slate:
        return 'slate';
      case ProfileGradient.cottonCandy:
        return 'cottonCandy';
      case ProfileGradient.twilightSky:
        return 'twilightSky';
      case ProfileGradient.amethyst:
        return 'amethyst';
      case ProfileGradient.sandstorm:
        return 'sandstorm';
      case ProfileGradient.desertDawn:
        return 'desertDawn';
      case ProfileGradient.ruby:
        return 'ruby';
      default:
        return 'none';
    }
  }
}
