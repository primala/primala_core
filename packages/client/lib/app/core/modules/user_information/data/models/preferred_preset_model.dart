import 'package:nokhte/app/core/modules/user_information/domain/domain.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
import 'package:nokhte_backend/tables/user_information.dart';

class PreferredPresetModel extends PreferredPresetEntity {
  const PreferredPresetModel({
    required super.name,
    required super.tags,
    required super.presetUID,
    required super.userUID,
  });

  factory PreferredPresetModel.fromSupabase({
    required List companyPresetRes,
    required List userInformationRes,
  }) {
    if (companyPresetRes.isEmpty) {
      return const PreferredPresetModel(
        name: '',
        tags: [],
        presetUID: '',
        userUID: '',
      );
    } else {
      if (userInformationRes
              .first[UserInformationConstants.S_PREFERRED_PRESET] ==
          null) {
        return PreferredPresetModel(
          name: '',
          tags: const [],
          presetUID: '',
          userUID: userInformationRes.first[UserInformationConstants.S_UID],
        );
      } else {
        return PreferredPresetModel(
          name: companyPresetRes.first[CompanyPresetsQueries.NAME],
          tags: CompanyPresetsUtils.mapTagsToEnum(
            companyPresetRes.first[CompanyPresetsQueries.TAGS],
          ),
          presetUID: companyPresetRes.first[CompanyPresetsQueries.UID],
          userUID: userInformationRes.first[UserInformationConstants.S_UID],
        );
      }
    }
  }
}
