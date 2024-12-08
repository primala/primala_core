// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:nokhte/app/modules/session/logic/domain/domain.dart';
import 'package:nokhte_backend/tables/static_active_sessions.dart';
import 'package:nokhte_backend/tables/user_metadata.dart';
import 'package:nokhte_backend/types/types.dart';

class StaticSessionMetadataModel extends StaticSessionMetadataEntity {
  const StaticSessionMetadataModel({
    required super.namesAndUIDs,
    required super.userIndex,
    required super.createdAt,
    required super.presetUID,
    required super.leaderUID,
  });

  factory StaticSessionMetadataModel.fromSupabase(
    List sessionRes,
    List metadataRes,
  ) {
    if (sessionRes.isEmpty) {
      return const StaticSessionMetadataModel(
        userIndex: 0,
        namesAndUIDs: [],
        createdAt: ConstDateTime.fromMillisecondsSinceEpoch(0),
        presetUID: '',
        leaderUID: '',
      );
    } else {
      final m = UserMetadataConstants();
      final UID = m.UID;
      const LEADER_UID = StaticActiveSessionsConstants.S_LEADER_UID;
      const CREATED_AT = StaticActiveSessionsConstants.S_CREATED_AT;
      const COLLABORATOR_UIDS =
          StaticActiveSessionsConstants.S_COLLABORATOR_UIDS;
      const COLLABORATOR_NAMES =
          StaticActiveSessionsConstants.S_COLLABORATOR_NAMES;
      const PRESET_UID = StaticActiveSessionsConstants.S_PRESET_UID;
      final leaderUID = sessionRes.first[LEADER_UID];
      final createdAt = DateTime.parse(sessionRes.first[CREATED_AT]);
      final orderedCollaboratorUIDs = sessionRes.first[COLLABORATOR_UIDS];
      final userIndex = orderedCollaboratorUIDs.indexOf(metadataRes.first[UID]);
      final presetUID = sessionRes.first[PRESET_UID];
      final names = sessionRes.first[COLLABORATOR_NAMES];
      final namesAndUIDs = <NameAndUID>[];
      for (int i = 0; i < orderedCollaboratorUIDs.length; i++) {
        namesAndUIDs.add(
          NameAndUID(
            uid: orderedCollaboratorUIDs[i],
            name: names[i],
          ),
        );
      }

      return StaticSessionMetadataModel(
        namesAndUIDs: namesAndUIDs,
        leaderUID: leaderUID,
        presetUID: presetUID,
        createdAt: createdAt,
        userIndex: userIndex,
      );
    }
  }
}
