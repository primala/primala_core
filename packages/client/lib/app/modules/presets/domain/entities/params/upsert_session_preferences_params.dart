import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

class UpsertSessionPreferencesParams extends Equatable {
  final PresetTypes type;
  final List<SessionTags> newTags;

  const UpsertSessionPreferencesParams({
    required this.type,
    this.newTags = const [],
  });

  @override
  List get props => [type, newTags];
}
