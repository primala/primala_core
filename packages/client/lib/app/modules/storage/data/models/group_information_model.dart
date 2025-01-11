import 'package:flutter/material.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte_backend/tables/groups.dart';

class GroupInformationModel extends GroupInformationEntity {
  const GroupInformationModel({
    required super.groupMembers,
    required super.groupName,
    required super.groupHandle,
    required super.groupUID,
    required super.collaborators,
  });

  static String formatTitleString(String unformattedString) {
    return '${unformattedString.characters.first.toUpperCase()}${unformattedString.substring(1)}';
  }

  static List<GroupInformationModel> fromSupabase(
    List sessionsResponse,
    List<CollaboratorModel> collaborators,
  ) {
    if (sessionsResponse.isEmpty) {
      return const [];
    } else {
      final List<GroupInformationModel> groups = <GroupInformationModel>[];
      for (var group in sessionsResponse) {
        final List<CollaboratorModel> temp = [];
        for (var collaborator in collaborators) {
          final isAMember =
              group[GroupsQueries.GROUP_MEMBERS].contains(collaborator.uid);
          temp.add(
            CollaboratorModel.fromGroupInformation(
              collaborator,
              isAMember,
            ),
          );
        }
        groups.add(
          GroupInformationModel(
            collaborators: temp,
            groupMembers: group[GroupsQueries.GROUP_MEMBERS],
            groupName: formatTitleString(group[GroupsQueries.GROUP_NAME]),
            groupHandle:
                "@${formatTitleString(group[GroupsQueries.GROUP_HANDLE])}",
            groupUID: group[GroupsQueries.UID],
          ),
        );
      }
      return groups;
    }
  }
}
