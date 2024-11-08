import 'package:equatable/equatable.dart';
import 'package:nokhte/app/modules/presets/presets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

class CompanyPresetsEntity extends Equatable {
  final List<String> uids;
  final List<List<SessionTags>> tags;
  final List<PresetTypes> presets;
  final List<PresetArticleEntity> articles;
  final List<SessionScreenTypes> screenTypes;

  const CompanyPresetsEntity({
    required this.uids,
    required this.tags,
    required this.presets,
    required this.articles,
    required this.screenTypes,
  });

  factory CompanyPresetsEntity.initial() => const CompanyPresetsEntity(
        uids: [],
        tags: [],
        presets: [],
        articles: [],
        screenTypes: [],
      );

  @override
  List<Object> get props => [uids, tags, presets];
}
