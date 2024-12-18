// ignore_for_file: constant_identifier_names
import 'package:supabase_flutter/supabase_flutter.dart';

class CollaboratorRelationshipsQueries {
  static const TABLE = 'collaborator_relationships';
  static const ID = 'id';
  static const COLLABORATOR_ONE_UID = 'collaborator_one_uid';
  static const COLLABORATOR_TWO_UID = 'collaborator_two_uid';
  static const CREATED_AT = 'created_at';
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

  Future<List> delete({
    required int id,
  }) async =>
      await supabase.from(TABLE).delete().eq(ID, id).select();
}
