import 'package:flutter/material.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte_backend/tables/finished_sessions.dart';
import 'package:nokhte_backend/tables/group_information.dart';
import 'package:nokhte_backend/tables/session_queues.dart';

class GroupInformationModel extends GroupInformationEntity {
  const GroupInformationModel({
    required super.groupMembers,
    required super.groupName,
    required super.groupHandle,
    required super.groupUID,
    required super.sessions,
    required super.queues,
  });

  static String formatTitleString(String unformattedString) {
    return '${unformattedString.characters.first.toUpperCase()}${unformattedString.substring(1)}';
  }

  static List<GroupInformationModel> fromSupabase(List res) {
    if (res.isEmpty) {
      return const [];
    } else {
      final List<GroupInformationModel> groups = <GroupInformationModel>[];
      for (var group in res) {
        groups.add(
          GroupInformationModel(
            sessions: SessionArtifactModel.fromSupabase(
              group[FinishedSessionsQueries.TABLE],
            ),
            groupMembers: group[GroupInformationQueries.GROUP_MEMBERS],
            groupName:
                formatTitleString(group[GroupInformationQueries.GROUP_NAME]),
            groupHandle:
                "@${formatTitleString(group[GroupInformationQueries.GROUP_HANDLE])}",
            groupUID: group[GroupInformationQueries.UID],
            queues: QueueModel.fromSupabase(group[SessionQueuesQueries.TABLE]),
          ),
        );
      }
      return groups;
    }
  }
}
