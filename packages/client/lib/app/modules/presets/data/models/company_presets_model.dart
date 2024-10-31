import 'package:nokhte/app/modules/presets/presets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
import 'package:nokhte_backend/tables/company_presets_preferences.dart';

class CompanyPresetsModel extends CompanyPresetsEntity {
  const CompanyPresetsModel({
    required super.uids,
    required super.tags,
    required super.presets,
    required super.articles,
    required super.screenTypes,
  });

  static CompanyPresetsModel fromSupabase(List presetsRes) {
    if (presetsRes.isEmpty) {
      return const CompanyPresetsModel(
        uids: [],
        tags: [],
        presets: [],
        articles: [],
        screenTypes: [],
      );
    } else {
      final List<String> uids = [];
      final List<List<SessionTags>> tags = [];
      final List<PresetTypes> types = [];
      final List<PresetArticleEntity> articles = [];
      final List<SessionScreenTypes> screenTypes = [];

      for (var preset in presetsRes) {
        final formattedTags = CompanyPresetsUtils.mapTagsToEnum(
            preset[CompanyPresetsQueries.TAGS]);
        final presetType = CompanyPresetsUtils.mapStringToPresetType(
            preset[CompanyPresetsQueries.NAME]);
        final prefsRes = preset[CompanyPresetsPreferencesQueries.TABLE];
        final formattedScreenType = CompanyPresetsUtils.fromRawScreenType(
          preset[CompanyPresetsQueries.PHONE_TYPE],
        );

        screenTypes.add(formattedScreenType);
        uids.add(preset[CompanyPresetsQueries.UID]);
        tags.add(formattedTags);
        types.add(presetType);
        articles.add(
          PresetArticleEntity(
            presetTags: formattedTags,
            presetType: presetType,
            articleSections: getArticleSections(
              presetType,
              formattedTags,
              prefsRes,
            ),
          ),
        );
      }

      return CompanyPresetsModel(
        screenTypes: screenTypes,
        uids: uids,
        tags: tags,
        presets: types,
        articles: articles,
      );
    }
  }

  static TagCategory categorizeTag(SessionTags tag) {
    switch (tag) {
      case SessionTags.strictSeating:
      case SessionTags.flexibleSeating:
        return TagCategory.sitting;

      case SessionTags.holdToSpeak:
      case SessionTags.tapToSpeak:
        return TagCategory.speaking;
      case SessionTags.monoFocalNotes:
      case SessionTags.multiFocalNotes:
      case SessionTags.deactivatedNotes:
        return TagCategory.notes;
      default:
        return TagCategory.none;
    }
  }

  static List<ArticleSection> getArticleSections(
    PresetTypes presetType,
    List<SessionTags> possibleTags,
    List userPrefsRes,
  ) {
    List<ArticleSection> sections;

    if (userPrefsRes.isEmpty && possibleTags.length == 3) {
      sections = possibleTags
          .map((tag) => ArticleSection(
                presetType: presetType,
                tag: tag,
                category: categorizeTag(tag),
              ))
          .toList();
    } else if (userPrefsRes.isEmpty && possibleTags.length != 3) {
      final defaultTags =
          CompanyPresetsPreferencesQueries.mapTypeToChosenDefaultTags(
              presetType);
      sections = defaultTags
          .map((tag) => ArticleSection(
                presetType: presetType,
                tag: tag,
                category: categorizeTag(tag),
              ))
          .toList();
    } else {
      final userTags = CompanyPresetsUtils.mapTagsToEnum(
          userPrefsRes.first[CompanyPresetsQueries.TAGS]);
      // print(userTags);

      sections = userTags.map((tag) {
        return ArticleSection(
          presetType: presetType,
          tag: tag,
          category: categorizeTag(tag),
        );
      }).toList();
    }

    return sections;
  }
}
