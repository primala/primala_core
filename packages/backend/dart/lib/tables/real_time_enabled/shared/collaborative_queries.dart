import 'package:nokhte_backend/tables/real_time_enabled/existing_collaborations/types/types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CollaborativeQueries {
  final SupabaseClient supabase;
  String currentUserUID = '';
  CollaboratorInfo collaboratorInfo = CollaboratorInfo(
    theCollaboratorsNumber: '',
    theCollaboratorsUID: '',
    theUsersCollaboratorNumber: '',
    theUsersUID: '',
  );

  CollaborativeQueries({
    required this.supabase,
  }) : currentUserUID = supabase.auth.currentUser?.id ?? '';

  Future<void> figureOutActiveCollaboratorInfo() async {
    collaboratorInfo = await computeActiveCollaboratorInfo();
  }

  Future<CollaboratorInfo> computeActiveCollaboratorInfo() async {
    final res = await fetchActiveCollaboratorsUIDAndNumber();
    return res[1] == 1
        ? CollaboratorInfo(
            theCollaboratorsNumber: 'collaborator_one',
            theCollaboratorsUID: res[0],
            theUsersCollaboratorNumber: 'collaborator_two',
            theUsersUID: currentUserUID,
          )
        : CollaboratorInfo(
            theCollaboratorsNumber: 'collaborator_two',
            theCollaboratorsUID: res[0],
            theUsersCollaboratorNumber: 'collaborator_one',
            theUsersUID: currentUserUID,
          );
  }

  Future<List<dynamic>> fetchActiveCollaborationInfo() async {
    return await supabase
        .from("existing_collaborations")
        .select()
        .or('collaborator_one.eq.$currentUserUID,collaborator_two.eq.$currentUserUID')
        .eq('is_currently_active', true);
  }

  Future<List> fetchActiveCollaboratorsUIDAndNumber() async {
    final collabRes = await fetchActiveCollaborationInfo();
    final collaboratorOne = collabRes[0]["collaborator_one"];
    final collaboratorTwo = collabRes[0]["collaborator_two"];
    return collaboratorOne == currentUserUID
        ? [collaboratorTwo, 2]
        : [collaboratorOne, 1];
  }

  Future<List<dynamic>> fetchAllCollaborationInfo() async {
    return await supabase.from("existing_collaborations").select().or(
        'collaborator_one.eq.$currentUserUID,collaborator_two.eq.$currentUserUID');
  }
}
