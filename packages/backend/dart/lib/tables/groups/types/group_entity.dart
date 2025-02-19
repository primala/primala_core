import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/groups.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:nokhte_backend/utils/profile_gradients_utils.dart';

typedef GroupEntities = List<GroupEntity>;

class GroupEntity extends Equatable {
  final int id;
  final String name;
  final ProfileGradient profileGradient;
  final bool isAdmin;

  const GroupEntity({
    required this.id,
    required this.name,
    required this.isAdmin,
    required this.profileGradient,
  });

  factory GroupEntity.initial() => GroupEntity(
        id: 0,
        name: '',
        isAdmin: false,
        profileGradient: ProfileGradient.none,
      );

  GroupEntity copyWith(ProfileGradient gradient, GroupEntity group) =>
      GroupEntity(
        id: group.id,
        name: group.name,
        isAdmin: group.isAdmin,
        profileGradient: gradient,
      );

  factory GroupEntity.fromSupabase(Map groupResponse) {
    if (groupResponse.isEmpty) {
      return GroupEntity.initial();
    } else {
      return GroupEntity(
        id: groupResponse[GroupsQueries.ID],
        name: groupResponse[GroupsQueries.GROUP_NAME],
        isAdmin: groupResponse[GroupsQueries.IS_ADMIN],
        profileGradient: ProfileGradientUtils.mapStringToProfileGradient(
          groupResponse[GroupsQueries.GRADIENT],
        ),
      );
    }
  }

  @override
  List<Object> get props => [id, name, isAdmin, profileGradient];
}
