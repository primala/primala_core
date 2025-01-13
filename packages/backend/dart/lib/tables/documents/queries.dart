// ignore_for_file: constant_identifier_names

import 'package:nokhte_backend/tables/documents.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DocumentsQueries with DocumentUtils, DocumentConstants {
  final SupabaseClient supabase;

  DocumentsQueries({
    required this.supabase,
  });

  DateTime? getExpirationDate(DocumentType type) =>
      type == DocumentType.ephemeral
          ? DateTime.now().add(const Duration(days: 7))
          : null;

  Future<List> insertDocument(InsertDocumentParams params) async {
    return await supabase.from(TABLE).insert({
      TYPE: mapDocumentTypeToString(params.type),
      EXPIRATION_DATE: getExpirationDate(params.type),
      GROUP_ID: params.groupId,
      PARENT_DOCUMENT_ID: params.parentDocumentId
    }).select();
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

  Future<List> updateSpotlightContentId(
          UpdateSpotlightContentIdParams params) async =>
      await supabase
          .from(TABLE)
          .update({
            SPOTLIGHT_CONTENT_ID: params.contentId,
          })
          .eq(ID, params.documentId)
          .select();

  Future<List> deleteDocument(int documentId) async =>
      await supabase.from(TABLE).delete().eq(ID, documentId).select();
}
