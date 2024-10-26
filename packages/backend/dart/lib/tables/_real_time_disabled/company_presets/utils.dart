import 'package:nokhte_backend/tables/company_presets.dart';

mixin CompanyPresetsUtils {
  static List<SessionTags> mapTagsToEnum(List tags) =>
      tags.map((e) => mapTagToEnum(e)).toList();

  static SessionTags mapTagToEnum(String tag) {
    switch (tag) {
      case 'strict_seating':
        return SessionTags.strictSeating;
      case 'flexible_seating':
        return SessionTags.flexibleSeating;
      case 'hold_to_speak':
        return SessionTags.holdToSpeak;
      case 'tap_to_speak':
        return SessionTags.tapToSpeak;
      case 'mono_focal_notes':
        return SessionTags.monoFocalNotes;
      case 'multi_focal_notes':
        return SessionTags.multiFocalNotes;
      case 'deactivated_notes':
        return SessionTags.deactivatedNotes;
      default:
        return SessionTags.none;
    }
  }

  static List<String> mapEnumsToTags(List<SessionTags> tags) =>
      tags.map((e) => mapEnumToTag(e)).toList();

  static String mapEnumToTag(SessionTags tag) {
    switch (tag) {
      case SessionTags.strictSeating:
        return 'strict_seating';
      case SessionTags.flexibleSeating:
        return 'flexible_seating';
      case SessionTags.holdToSpeak:
        return 'hold_to_speak';
      case SessionTags.tapToSpeak:
        return 'tap_to_speak';
      case SessionTags.monoFocalNotes:
        return 'mono_focal_notes';
      case SessionTags.multiFocalNotes:
        return 'multi_focal_notes';
      case SessionTags.deactivatedNotes:
        return 'deactivated_notes';
      default:
        return 'none';
    }
  }

  static PresetTypes mapStringToPresetType(String type) {
    switch (type) {
      case 'Consultation':
        return PresetTypes.consultative;
      case 'Collaboration':
        return PresetTypes.collaborative;
      case 'Solo':
        return PresetTypes.solo;
      default:
        return PresetTypes.none;
    }
  }

  static mapTypeToPresetType(PresetTypes type) {
    switch (type) {
      case PresetTypes.consultative:
        return 'Consultation';
      case PresetTypes.collaborative:
        return 'Collaboration';
      case PresetTypes.solo:
        return 'Solo';
      case PresetTypes.none:
        return '';
    }
  }

  static SessionScreenTypes fromRawScreenType(String param) {
    if (param.contains('solo')) {
      return SessionScreenTypes.soloHybrid;
    } else if (param.contains('group')) {
      return SessionScreenTypes.groupHybrid;
    } else if (param.contains('poly')) {
      return SessionScreenTypes.polymorphicSolo;
    } else {
      return SessionScreenTypes.none;
    }
  }
}
