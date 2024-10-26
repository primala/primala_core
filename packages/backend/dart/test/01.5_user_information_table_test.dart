import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte_backend/tables/_real_time_disabled/company_presets/queries.dart';
import 'package:nokhte_backend/tables/_real_time_disabled/user_information/queries.dart';

import 'shared/shared.dart';

void main() {
  late UserInformationQueries user1Queries;
  late CompanyPresetsQueries companyPresetsQueries;
  final tSetup = CommonCollaborativeTestFunctions();

  setUp(() async {
    await tSetup.setUp();
    user1Queries = UserInformationQueries(supabase: tSetup.user1Supabase);
    companyPresetsQueries =
        CompanyPresetsQueries(supabase: tSetup.user1Supabase);
  });

  tearDownAll(
      () async => await tSetup.supabaseAdmin.from('user_information').update({
            "authorized_viewers": [],
          }).eq('uid', tSetup.secondUserUID));

  test("should be able to update their preferred preset uid", () async {
    final companyPresetsRes =
        await companyPresetsQueries.select(type: PresetTypes.collaborative);
    final presetUID = companyPresetsRes.first[CompanyPresetsQueries.UID];
    print("presetUID: $presetUID");
    final res = await user1Queries.updatePreferredPreset(presetUID);
    expect(res.first[user1Queries.PREFERRED_PRESET], presetUID);
    //
  });

  test("shoulnd't be able to read anything if nothing is shared", () async {
    final initialRes = await user1Queries.getCollaboratorRows();
    expect(initialRes, isEmpty);
  });
}
