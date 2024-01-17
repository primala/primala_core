import 'package:nokhte/app/core/modules/collaborator_presence/domain/domain.dart';
import 'package:nokhte_backend/tables/existing_collaborations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CollaboratorPresenceRemoteSource {
  Future<List> updateOnlineStatus(UpdateOnlineStatusParams params);
  Future<List> updateOnCallStatus(UpdateOnCallStatusParams params);
  Future<List> updateMeetingIdAndToken(UpdateMeetingIdAndTokenParams params);
  Future<List> updateTimerStatus(bool params);
  Future<List> setUserAsCurrentTalker();
  Future<void> clearTheCurrentTalker();
  Stream<CollaborationSessionMetadata> getSessionMetadata();
}

class CollaboratorPresenceRemoteSourceImpl
    implements CollaboratorPresenceRemoteSource {
  final SupabaseClient supabase;
  final ExistingCollaborationsQueries queries;
  final ExistingCollaborationsStream stream;

  CollaboratorPresenceRemoteSourceImpl({
    required this.supabase,
  })  : queries = ExistingCollaborationsQueries(supabase: supabase),
        stream = ExistingCollaborationsStream(supabase: supabase);

  @override
  updateOnCallStatus(UpdateOnCallStatusParams params) async =>
      queries.updateOnCallStatus(
        params.newStatus,
        shouldEditCollaboratorsInfo: params.shouldUpdateCollaboratorsIndex,
      );

  @override
  updateOnlineStatus(UpdateOnlineStatusParams params) async =>
      queries.updateOnlineStatus(
        params.newStatus,
        shouldEditCollaboratorsInfo: params.shouldUpdateCollaboratorsIndex,
      );

  @override
  updateTimerStatus(bool params) async =>
      queries.updateTimerRunningStatus(params);

  @override
  Future<void> clearTheCurrentTalker() async =>
      await queries.clearTheCurrentTalker();

  @override
  Future<List> setUserAsCurrentTalker() async =>
      await queries.setUserAsTheCurrentTalker();

  @override
  Stream<CollaborationSessionMetadata> getSessionMetadata() =>
      stream.getSessionMetadata();

  @override
  Future<List> updateMeetingIdAndToken(params) async {
    await queries.ensureActiveCollaboratorInfo();
    switch (params) {
      case UpdateMeetingIdAndTokenParams.refresh:
        if (queries.collaboratorInfo.theUsersCollaboratorNumber ==
            "collaborator_two") {
          return await queries.updateMeetingIdAndToken();
        } else {
          return [];
        }
      case UpdateMeetingIdAndTokenParams.clearOut:
        return await queries.updateMeetingIdAndToken(shouldClearOut: true);
    }
  }
}
