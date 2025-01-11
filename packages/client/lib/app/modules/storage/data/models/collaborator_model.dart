import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte_backend/tables/users.dart';

class CollaboratorModel extends CollaboratorEntity {
  const CollaboratorModel({
    required super.uid,
    required super.name,
    super.isAMember = false,
  });

  static List<CollaboratorModel> fromSupabase(List collaboratorResponse) {
    if (collaboratorResponse.isEmpty) {
      return const [];
    } else {
      final List<CollaboratorModel> groups = <CollaboratorModel>[];
      for (var group in collaboratorResponse) {
        groups.add(
          CollaboratorModel(
            uid: group[UsersConstants.S_UID],
            name:
                '${group[UsersConstants.S_FIRST_NAME]} ${group[UsersConstants.S_LAST_NAME]}',
          ),
        );
      }
      return groups;
    }
  }

  factory CollaboratorModel.fromGroupInformation(
    CollaboratorModel existingModel,
    bool isAMember,
  ) {
    return CollaboratorModel(
      uid: existingModel.uid,
      name: existingModel.name,
      isAMember: isAMember,
    );
  }
}
