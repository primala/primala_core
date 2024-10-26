import 'package:equatable/equatable.dart';
import 'package:nokhte/app/modules/presets/presets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

class ArticleSection extends Equatable {
  final SessionTags tag;
  final TagCategory category;
  final String sectionHeader;
  final List<String> articleInstructions;
  final List<String> articleJustifications;
  final PowerupInfo powerup;

  ArticleSection({
    required PresetTypes presetType,
    required this.tag,
    required this.category,
  })  : sectionHeader = _getSectionHeader(tag),
        articleJustifications = _getJustifications(tag),
        articleInstructions = _getInstructions(tag, presetType),
        powerup = PowerupInfo(_getPowerup(presetType, category));

  static String _getSectionHeader(SessionTags tag) {
    if (tag == SessionTags.tapToSpeak || tag == SessionTags.holdToSpeak) {
      return 'How to speak:';
    } else if (tag == SessionTags.monoFocalNotes ||
        tag == SessionTags.multiFocalNotes) {
      return 'How to take notes:';
    } else if (tag == SessionTags.deactivatedNotes) {
      return 'Notes are deactivated';
    } else if (tag == SessionTags.flexibleSeating ||
        tag == SessionTags.strictSeating) {
      return 'Where to sit:';
    }
    return '';
  }

  static List<ArticleSection> fromExistingEntity(
    PresetTypes presetType,
    List<SessionTags> tags,
    PresetArticleEntity base,
  ) {
    final temp = <ArticleSection>[];
    for (int i = 0; i < tags.length; i++) {
      temp.add(ArticleSection(
        presetType: presetType,
        tag: tags[i],
        category: base.articleSections[i].category,
      ));
    }
    return temp;
  }

  factory ArticleSection.initial() => ArticleSection(
        presetType: PresetTypes.none,
        tag: SessionTags.none,
        category: TagCategory.none,
      );

  static Powerups _getPowerup(PresetTypes presetType, TagCategory category) {
    if (category == TagCategory.speaking) {
      if (presetType == PresetTypes.consultative) {
        return Powerups.letEmCook;
      } else if (presetType == PresetTypes.collaborative) {
        return Powerups.rally;
      }
    }
    return Powerups.none;
  }

  static List<String> _getInstructions(
      SessionTags tag, PresetTypes presetType) {
    switch (tag) {
      case SessionTags.tapToSpeak:
        return [
          '**Tap** on the yellow side to speak',
          '**Tap again** when you are finished'
        ];
      case SessionTags.holdToSpeak:
        final temp = [
          'Locate the phone **to your right**',
          '**Hold** on the yellow side to speak',
          '**Let go** when you are finished'
        ];
        if (presetType == PresetTypes.solo) {
          temp.removeAt(0);
        }
        return temp;
      case SessionTags.flexibleSeating:
        return ['**Sit or stand** anywhere', '**Keep** your phone with you'];
      case SessionTags.strictSeating:
        return [
          'Sit in a **circle**',
          'Place your phone **halfway** between you and the person to your right'
        ];
      case SessionTags.monoFocalNotes:
        return [
          'Locate the **phone to your left**',
          '**Tap** on the blue to write your note',
          '**Swipe up** to submit'
        ];
      case SessionTags.multiFocalNotes:
        return [
          '**Tap** on the blue to write your note',
          '**Swipe up** to submit'
        ];
      case SessionTags.deactivatedNotes:
        return [];
      default:
        return [];
    }
  }

  static List<String> _getJustifications(SessionTags tag) {
    switch (tag) {
      case SessionTags.tapToSpeak:
        return ['Allows you to do other things **while talking**'];
      case SessionTags.holdToSpeak:
        return [
          'Encourages speaking with **brevity**',
          'Gives you less time to **repeat yourself**'
        ];
      case SessionTags.flexibleSeating:
        return [
          'Can **move anytime** in the meeting',
          'Can be used in **more spaces**'
        ];
      case SessionTags.strictSeating:
        return ["**See** everyone's face", '**Hear** people clearly'];
      case SessionTags.monoFocalNotes:
      case SessionTags.multiFocalNotes:
        return [
          'Write with brevity **(104 characters)**',
          '**Keep** track of ideas'
        ];
      default:
        return [];
    }
  }

  @override
  List<Object> get props => [
        tag,
        category,
        sectionHeader,
        articleInstructions,
        articleJustifications,
      ];
}
