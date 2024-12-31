import 'package:flutter/material.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte_backend/tables/group_information.dart';

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
          final isAMember = group[GroupInformationQueries.GROUP_MEMBERS]
              .contains(collaborator.uid);
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
            groupMembers: group[GroupInformationQueries.GROUP_MEMBERS],
            groupName:
                formatTitleString(group[GroupInformationQueries.GROUP_NAME]),
            groupHandle:
                "@${formatTitleString(group[GroupInformationQueries.GROUP_HANDLE])}",
            groupUID: group[GroupInformationQueries.UID],
          ),
        );
      }
      return groups;
    }
  }
}
