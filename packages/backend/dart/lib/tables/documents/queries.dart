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

  DateTime? getExpirationDate(DocumentType type) =>
      type == DocumentType.ephemeral
          ? DateTime.now().add(const Duration(days: 7))
          : null;

  Future<Map> insertDocument(InsertDocumentParams params) async {
    final res = await supabase
        .from(TABLE)
        .insert({
          TYPE: mapDocumentTypeToString(params.type),
          EXPIRATION_DATE: getExpirationDate(params.type),
          TITLE: params.documentTitle,
          GROUP_ID: params.groupId,
          PARENT_DOCUMENT_ID: params.parentDocumentId
        })
        .select()
        .single();
    final docId = res[ID];
    final contentRes = await contentBlocks.addContent(
      AddContentParams(
        content: params.spotlightMessage,
        documentId: docId,
        contentBlockType: params.contentBlockType,
      ),
    );
    return await updateSpotlightContentId(UpdateSpotlightContentIdParams(
      documentId: docId,
      contentId: contentRes[ID],
    ));
  }

  Future<List> selectByGroup(int groupId) async =>
      await supabase.from(TABLE).select().eq(GROUP_ID, groupId);

  Future<List> updateTitle(UpdateDocumentTitleParams params) async =>
      await supabase
          .from(TABLE)
          .update({TITLE: params.title})
          .eq(ID, params.documentId)
          .select();

  Future<List> updateType(UpdateDocumentTypeParams params) async {
    return await supabase
        .from(TABLE)
        .update({
          TYPE: mapDocumentTypeToString(params.type),
          EXPIRATION_DATE: getExpirationDate(params.type),
        })
        .eq(ID, params.documentId)
        .select();
  }

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
