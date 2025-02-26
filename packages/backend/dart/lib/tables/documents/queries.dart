// ignore_for_file: constant_identifier_names

import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:nokhte_backend/tables/documents.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DocumentsQueries with DocumentUtils, DocumentConstants {
  final SupabaseClient supabase;
  final ContentBlocksQueries contentBlocks;

  DocumentsQueries({
    required this.supabase,
  }) : contentBlocks = ContentBlocksQueries(supabase: supabase);

  Future<Map> insertDocument(InsertDocumentParams params) async {
    final res = await supabase
        .from(TABLE)
        .insert({
          TITLE: params.documentTitle,
          GROUP_ID: params.groupId,
        })
        .select()
        .single();
    final docId = res[ID];
    final contentRes = await contentBlocks.addContent(
      AddContentParams(
        content: params.spotlightMessage,
        groupId: params.groupId,
        documentId: docId,
        contentBlockType: params.contentBlockType,
      ),
    );
    return await updateSpotlightContentId(UpdateSpotlightContentIdParams(
      documentId: docId,
      contentId: contentRes[ID],
    ));
  }

  Future<Map> toggleArchive(ToggleArchiveParams params) async => await supabase
      .from(TABLE)
      .update({IS_ARCHIVED: params.shouldArchive})
      .eq(ID, params.documentId)
      .select()
      .single();

  Future<List> selectByGroup(
    int groupId, {
    bool includeArchived = false,
  }) async =>
      await supabase.from(TABLE).select().eq(GROUP_ID, groupId).eq(
            IS_ARCHIVED,
            includeArchived,
          );

  Future<Map> updateTitle(UpdateDocumentTitleParams params) async =>
      await supabase
          .from(TABLE)
          .update({TITLE: params.title})
          .eq(ID, params.documentId)
          .select()
          .single();

  Future<Map> updateSpotlightContentId(
          UpdateSpotlightContentIdParams params) async =>
      await supabase
          .from(TABLE)
          .update({
            SPOTLIGHT_CONTENT_ID: params.contentId,
          })
          .eq(ID, params.documentId)
          .select()
          .single();

  Future<Map> deleteDocument(int documentId) async =>
      await supabase.from(TABLE).delete().eq(ID, documentId).select().single();
}
