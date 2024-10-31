import 'package:equatable/equatable.dart';
import 'package:nokhte/app/modules/presets/presets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

class PresetArticleEntity extends Equatable {
  final List<ArticleOptions> options;
  final List<ArticleSection> articleSections;
  final PresetTypes presetType;
  final String title;
  final String tagline;
  final String uniqueFeature;
  final List<SessionTags> presetTags;

  PresetArticleEntity({
    required this.presetTags,
    required this.presetType,
    required this.articleSections,
  })  : options = _getOptionsToggles(presetTags),
        title = _getTitle(presetType),
        tagline = _getTagline(presetType),
        uniqueFeature = _getUniqueFeature(presetType);

  factory PresetArticleEntity.initial() => PresetArticleEntity(
        articleSections: const [],
        presetTags: const [],
        presetType: PresetTypes.none,
      );

  factory PresetArticleEntity.fromExistingEntity({
    required PresetArticleEntity base,
    required List<SessionTags> newPresetTags,
  }) {
    return PresetArticleEntity(
      presetTags: base.presetTags,
      presetType: base.presetType,
      articleSections: ArticleSection.fromExistingEntity(
        base.presetType,
        newPresetTags,
        base,
      ),
    );
  }

  static List<ArticleOptions> _getOptionsToggles(List<SessionTags> tags) {
    List<ArticleOptions> options = [];
    if (tags.contains(SessionTags.tapToSpeak) &&
        tags.contains(SessionTags.holdToSpeak)) {
      options.add(ArticleOptions.talkingToggle);
    }

    bool hasMonoFocal = tags.contains(SessionTags.monoFocalNotes);
    bool hasMultiFocal = tags.contains(SessionTags.multiFocalNotes);
    bool hasNotesDeactivated = tags.contains(SessionTags.deactivatedNotes);

    if ((hasMonoFocal && hasMultiFocal) ||
        (hasMonoFocal && hasNotesDeactivated) ||
        (hasMultiFocal && hasNotesDeactivated)) {
      options.add(ArticleOptions.notesToggle);
    }
    return options;
  }

  static String _getTitle(PresetTypes type) {
    switch (type) {
      case PresetTypes.collaborative:
        return 'Collaboration';
      case PresetTypes.consultative:
        return 'Consultation';
      case PresetTypes.solo:
        return 'Solo';
      default:
        return '';
    }
  }

  static String _getTagline(PresetTypes type) {
    switch (type) {
      case PresetTypes.collaborative:
        return 'Great with smaller groups, and works best in creative endeavors';
      case PresetTypes.consultative:
        return 'Great for beginners, and groups of any size \n';
      case PresetTypes.solo:
        return 'Use the app in group settings without group approval \n'; // Empty for now
      default:
        return '';
    }
  }

  static List<ArticleOptions> getOptionsToggles(List<SessionTags> tags) {
    List<ArticleOptions> options = [];

    if (tags.contains(SessionTags.tapToSpeak) &&
        tags.contains(SessionTags.holdToSpeak)) {
      options.add(ArticleOptions.talkingToggle);
    }

    bool hasMonoFocal = tags.contains(SessionTags.monoFocalNotes);
    bool hasMultiFocal = tags.contains(SessionTags.multiFocalNotes);
    bool hasNotesDeactivated = tags.contains(SessionTags.deactivatedNotes);

    if ((hasMonoFocal && hasMultiFocal) ||
        (hasMonoFocal && hasNotesDeactivated) ||
        (hasMultiFocal && hasNotesDeactivated)) {
      options.add(ArticleOptions.notesToggle);
    }

    return options;
  }

  static String _getUniqueFeature(PresetTypes type) {
    switch (type) {
      case PresetTypes.collaborative:
        return 'Flexibility: sit anywhere, notes anytime';
      case PresetTypes.consultative:
        return 'One at a time: The group is either listening or writing notes, not both.';
      case PresetTypes.solo:
        return 'Adaptive: Change the session to fit your needs ';
      default:
        return '';
    }
  }

  @override
  List<Object> get props => [
        options,
        title,
        tagline,
        uniqueFeature,
      ];
}
