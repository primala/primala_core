import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContentBlocksQueries with SessionContentConstants {
  int documentId = -1;
  int groupId = -1;
  final SupabaseClient supabase;
  final UsersQueries usersQueries;

  ContentBlocksQueries({
    required this.supabase,
  }) : usersQueries = UsersQueries(supabase: supabase);

  setDocumentId(int value) => documentId = value;
  // setGroupId(int value) => groupId = value;

  getGroupId() async {
    if (groupId != -1) return;
    groupId = await usersQueries.getActiveGroup();
  }

  Future<List> addContent(AddContentParams params) async {
    await getGroupId();
    if (documentId == -1 || groupId == -1) return [];
    return await supabase.from(TABLE).insert({
      DOCUMENT_ID: documentId,
      GROUP_ID: groupId,
      CONTENT: params.content,
      TYPE: SessionContentUtils.mapContentBlockTypeToString(
        params.contentBlockType,
      ),
      PARENT_ID: params.parentId == -1 ? null : params.parentId,
    }).select();
  }

  Future<List> deleteContent(int contentId) async {
    await getGroupId();
    if (documentId == -1 || groupId == -1) return [];
    return await supabase.from(TABLE).delete().eq(ID, contentId).select();
  }

  Future<List> updateContent(UpdateContentParams params) async {
    await getGroupId();
    if (documentId == -1 || groupId == -1) return [];
    return await supabase
        .from(TABLE)
        .update({
          CONTENT: params.content,
          TYPE: SessionContentUtils.mapContentBlockTypeToString(
            params.contentBlockType,
          ),
          LAST_EDITED_AT: DateTime.now().toUtc().toIso8601String(),
        })
        .eq(ID, params.contentId)
        .select();
  }

  Future<List> updateParent(UpdateParentParams params) async {
    await getGroupId();
    if (documentId == -1 || groupId == -1) return [];
    return await supabase
        .from(TABLE)
        .update({
          PARENT_ID: params.parentId == -1 ? null : params.parentId,
          LAST_EDITED_AT: DateTime.now().toUtc().toIso8601String(),
        })
        .eq(ID, params.contentId)
        .select();
  }
}
