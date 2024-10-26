import 'package:equatable/equatable.dart';
import 'package:nokhte/app/modules/presets/presets.dart';

class PowerupInfo extends Equatable {
  final Powerups powerup;
  final PowerupCategory category;
  final String name;
  final String imagePath;
  final String tagline;
  final String description;

  PowerupInfo(
    this.powerup,
  )   : imagePath = _getImagePath(powerup),
        tagline = _getTagline(powerup),
        description = _getDescription(powerup),
        name = _getName(powerup),
        category = _getCategory(powerup);

  static String _getImagePath(Powerups powerup) {
    return powerup == Powerups.letEmCook
        ? 'assets/cook_button.png'
        : 'assets/rally_button_white.png';
  }

  factory PowerupInfo.initial() => PowerupInfo(Powerups.none);

  static String _getName(Powerups powerup) {
    return powerup == Powerups.letEmCook ? "Let 'em cook" : "Rally";
  }

  static String _getTagline(Powerups powerup) {
    return powerup == Powerups.letEmCook
        ? 'When someone is saying something valuable, you give them more time to speak.'
        : 'When you want to ask a quick question, or get a quick response, you can start a rally.';
  }

  static String _getDescription(Powerups powerup) {
    return powerup == Powerups.letEmCook
        ? 'Resets speaking timer to **green**.'
        : 'Allows you to **speak directly** with another person during your time.';
  }

  static PowerupCategory _getCategory(Powerups powerup) {
    return powerup == Powerups.letEmCook
        ? PowerupCategory.speech
        : PowerupCategory.speech;
  }

  @override
  List<Object?> get props =>
      [powerup, category, imagePath, tagline, description];
}
