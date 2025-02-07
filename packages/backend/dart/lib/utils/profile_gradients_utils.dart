import 'package:nokhte_backend/types/types.dart';

mixin ProfileGradientUtils {
  static ProfileGradient mapStringToProfileGradient(String gradient) {
    switch (gradient) {
      case 'glacier':
        return ProfileGradient.glacier;
      case 'lagoon':
        return ProfileGradient.lagoon;
      case 'slate':
        return ProfileGradient.slate;
      case 'cotton_candy':
        return ProfileGradient.cottonCandy;
      case 'twilight_sky':
        return ProfileGradient.twilightSky;
      case 'amethyst':
        return ProfileGradient.amethyst;
      case 'sandstorm':
        return ProfileGradient.sandstorm;
      case 'desert_dawn':
        return ProfileGradient.desertDawn;
      case 'ruby':
        return ProfileGradient.ruby;
      default:
        return ProfileGradient.none;
    }
  }

  static String mapProfileGradientToString(ProfileGradient gradient) {
    switch (gradient) {
      case ProfileGradient.glacier:
        return 'glacier';
      case ProfileGradient.lagoon:
        return 'lagoon';
      case ProfileGradient.slate:
        return 'slate';
      case ProfileGradient.cottonCandy:
        return 'cotton_candy';
      case ProfileGradient.twilightSky:
        return 'twilight_sky';
      case ProfileGradient.amethyst:
        return 'amethyst';
      case ProfileGradient.sandstorm:
        return 'sandstorm';
      case ProfileGradient.desertDawn:
        return 'desert_dawn';
      case ProfileGradient.ruby:
        return 'ruby';
      default:
        return 'none';
    }
  }
}
