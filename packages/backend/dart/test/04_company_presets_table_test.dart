// ignore_for_file: file_names
import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte_backend/tables/_real_time_disabled/company_presets/queries.dart';

import 'shared/shared.dart';

void main() {
  late CompanyPresetsQueries user1Queries;
  final tSetup = CommonCollaborativeTestFunctions();

  setUpAll(() async {
    await tSetup.setUp();
    user1Queries = CompanyPresetsQueries(supabase: tSetup.user1Supabase);
  });

  const consultativeTags = [
    'hold_to_speak',
    'strict_seating',
    'mono_focal_notes'
  ];
  const collaborativeTags = [
    'tap_to_speak',
    'flexible_seating',
    'multi_focal_notes'
  ];
  const soloTags = [
    'hold_to_speak',
    'tap_to_speak',
    'no_seating',
    'deactivated_notes',
    'multi_focal_notes'
  ];

  test("select: PresetTypes.consultative", () async {
    final res = await user1Queries.select(type: PresetTypes.consultative);
    print('res: $res');
    expect(res.first[CompanyPresetsQueries.PHONE_TYPE], 'group_hybrid');
    expect(res.first[CompanyPresetsQueries.TAGS], consultativeTags);
    expect(
      res.first[CompanyPresetsQueries.NAME],
      CompanyPresetsUtils.mapTypeToPresetType(PresetTypes.consultative),
    );
  });

  test("select: PresetTypes.collaborative", () async {
    final res = await user1Queries.select(type: PresetTypes.collaborative);
    expect(res.first[CompanyPresetsQueries.PHONE_TYPE], 'solo_hybrid');
    expect(res.first[CompanyPresetsQueries.TAGS], collaborativeTags);
    expect(
      res.first[CompanyPresetsQueries.NAME],
      CompanyPresetsUtils.mapTypeToPresetType(PresetTypes.collaborative),
    );
  });

  test("select: PresetTypes.solo", () async {
    final res = await user1Queries.select(type: PresetTypes.solo);
    expect(res.first[CompanyPresetsQueries.PHONE_TYPE], 'polymorphic_solo');
    expect(res.first[CompanyPresetsQueries.TAGS], soloTags);
    expect(
      res.first[CompanyPresetsQueries.NAME],
      CompanyPresetsUtils.mapTypeToPresetType(PresetTypes.solo),
    );
  });
}
