// ignore_for_file: file_names

import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
import 'package:nokhte_backend/tables/company_presets_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'shared/shared.dart';

void main() {
  late CompanyPresetsPreferencesQueries user1Queries;
  late CompanyPresetsQueries companyPresetQueries;
  final tSetup = CommonCollaborativeTestFunctions();

  setUp(() async {
    await tSetup.setUp();
    user1Queries =
        CompanyPresetsPreferencesQueries(supabase: tSetup.user1Supabase);
    companyPresetQueries =
        CompanyPresetsQueries(supabase: tSetup.user1Supabase);
  });

  tearDownAll(() async => await tSetup.supabaseAdmin
      .from(CompanyPresetsPreferencesQueries.TABLE)
      .delete()
      .eq(CompanyPresetsPreferencesQueries.OWNER_UID, tSetup.firstUserUID));

  test("should be able to insert a preferences row (for a solo session)",
      () async {
    final res = await user1Queries.insert();
    final presetUID =
        (await companyPresetQueries.select(type: PresetTypes.solo))
            .first[CompanyPresetsQueries.UID];
    expect(res, isNotEmpty);
    expect(
      res.first[CompanyPresetsPreferencesQueries.TAGS],
      CompanyPresetsPreferencesQueries.mapTypeToChosenDefaultStringTags(
          PresetTypes.solo),
    );
    expect(
        res.first[CompanyPresetsPreferencesQueries.COMPANY_PRESET], presetUID);
  });

  test("should not be able to insert a duplicate row", () async {
    try {
      await user1Queries.insert();
    } catch (e) {
      expect(e, isA<PostgrestException>());
    }
  });

  test('''upsert should not change anything if
      1. no tags are passed
      2. the row is already created
   ''', () async {
    final res = await user1Queries.upsert();
    expect(res, isEmpty);
  });

  test('''upsert should update change anything if
      1. tags are passed
      2. the row is already created
   ''', () async {
    final tags = [
      SessionTags.holdToSpeak,

      SessionTags.deactivatedNotes,
    ];
    final res = await user1Queries.upsert(newTags: tags);

    expect(
      res.first[CompanyPresetsPreferencesQueries.TAGS],
      CompanyPresetsUtils.mapEnumsToTags(tags),
    );
  });

  test("should be able to update their preferences (for a solo session)",
      () async {
    final tags = [
      SessionTags.holdToSpeak,

      SessionTags.multiFocalNotes
    ];
    final res = await user1Queries.update(newTags: tags);
    expect(
      res.first[CompanyPresetsPreferencesQueries.TAGS],
      CompanyPresetsUtils.mapEnumsToTags(tags),
    );
  });

  test("should not be able to update tags to be empty", () async {
    try {
      await user1Queries.update(newTags: []);
    } catch (e) {
      expect(e, isA<PostgrestException>());
    }
  });

  test(
      "should not be able to insert tags that are not a subset of the company preset",
      () async {
    final tags = [
      SessionTags.holdToSpeak,
      SessionTags.flexibleSeating,
      SessionTags.multiFocalNotes
    ];
    try {
      await user1Queries.update(newTags: tags);
    } catch (e) {
      expect(e, isA<PostgrestException>());
    }
  });
}
