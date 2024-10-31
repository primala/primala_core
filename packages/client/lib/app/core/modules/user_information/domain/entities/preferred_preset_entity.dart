import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

class PreferredPresetEntity extends Equatable {
  final String name;
  final List<SessionTags> tags;
  final String presetUID;
  final String userUID;

  const PreferredPresetEntity({
    required this.name,
    required this.tags,
    required this.presetUID,
    required this.userUID,
  });

  factory PreferredPresetEntity.initial() => const PreferredPresetEntity(
        name: '',
        tags: [],
        presetUID: '',
        userUID: '',
      );

  @override
  List<Object> get props => [name, tags];
}
