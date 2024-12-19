// ignore_for_file: constant_identifier_names
import 'package:nokhte_backend/tables/collaborator_relationships/collaborator_relationships.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CollaboratorRelationshipsQueries with CollaboratorRelationshipsConstants {
  final SupabaseClient supabase;

  CollaboratorRelationshipsQueries({
    required this.supabase,
  });

  Future<List> insert({
    required String collaboratorTwoUid,
  }) async =>
      await supabase.from(TABLE).insert({
        COLLABORATOR_ONE_UID: supabase.auth.currentUser?.id ?? '',
        COLLABORATOR_TWO_UID: collaboratorTwoUid,
      }).select();

  Future<List> select() async => await supabase.from(TABLE).select();

  Future<List> delete({
    required String uid,
  }) async =>
      await supabase.from(TABLE).delete().eq(UID, uid).select();
}
