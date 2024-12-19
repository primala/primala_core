import 'package:nokhte_backend/tables/collaborator_relationships.dart';
import 'package:nokhte_backend/tables/user_information.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CollaboratorRelationshipsStream with CollaboratorRelationshipsConstants {
  final SupabaseClient supabase;
  bool collaboratorRelationshipsListeningStatus = false;
  final List<String> trackedCollaboratorIds = [];
  final UserInformationQueries userQueries;

  CollaboratorRelationshipsStream({
    required this.supabase,
  }) : userQueries = UserInformationQueries(supabase: supabase);

  Future<bool> cancelRelationshipsListeningStream() async {
    final res = supabase.realtime.getChannels();
    if (res.isNotEmpty) {
      await res.first.unsubscribe();
    }
    collaboratorRelationshipsListeningStatus = false;
    return collaboratorRelationshipsListeningStatus;
  }

  Stream<List<CollaboratorRelationshipEntity>>
      listenToCollaboratorRelationships() async* {
    final currentUserId = supabase.auth.currentUser?.id;
    List<CollaboratorRelationshipEntity> collaborators = [];

    // Initial fetch of all collaborator information
    final relationships = await supabase.from(TABLE).select().or(
        '$COLLABORATOR_ONE_UID.eq.$currentUserId,$COLLABORATOR_TWO_UID.eq.$currentUserId');

    for (final relationship in relationships) {
      final otherUserId = relationship[COLLABORATOR_ONE_UID] == currentUserId
          ? relationship[COLLABORATOR_TWO_UID]
          : relationship[COLLABORATOR_ONE_UID];

      if (!trackedCollaboratorIds.contains(otherUserId)) {
        trackedCollaboratorIds.add(otherUserId);
        final userInfo = await supabase
            .from('user_information')
            .select()
            .eq('uid', otherUserId)
            .single();

        collaborators.add(CollaboratorRelationshipEntity(
          uid: otherUserId,
          fullName: '${userInfo['first_name']} ${userInfo['last_name']}'.trim(),
        ));
      }
    }

    yield collaborators;

    await for (var event in supabase.from(TABLE).stream(primaryKey: ['id'])) {
      for (final relationship in event) {
        final otherUserId = relationship[COLLABORATOR_ONE_UID] == currentUserId
            ? relationship[COLLABORATOR_TWO_UID]
            : relationship[COLLABORATOR_ONE_UID];

        if (!trackedCollaboratorIds.contains(otherUserId)) {
          trackedCollaboratorIds.add(otherUserId);
          final userInfo = await supabase
              .from('user_information')
              .select()
              .eq('uid', otherUserId)
              .single();

          collaborators.add(
            CollaboratorRelationshipEntity(
              uid: otherUserId,
              fullName:
                  '${userInfo['first_name']} ${userInfo['last_name']}'.trim(),
            ),
          );

          yield collaborators;
        }
      }
    }
  }
}
