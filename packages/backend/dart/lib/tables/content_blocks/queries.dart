import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionContentQueries with SessionContentConstants {
  // String sessionUID = '';
  // final SupabaseClient supabase;

  // SessionContentQueries({
  //   required this.supabase,
  // });

  // setSessionUID(String value) => sessionUID = value;

  // Future<List> addContent(AddContentParams params) async {
  //   if (sessionUID.isEmpty) return [];
  //   return await supabase.from(TABLE).insert({
  //     SESSION_UID: sessionUID,
  //     CONTENT: params.content,
  //     TYPE: SessionContentUtils.mapContentBlockTypeToString(
  //       params.contentBlockType,
  //     ),
  //     PARENT_UID: params.parentUID.isEmpty ? null : params.parentUID,
  //   }).select();
  // }

  // Future<List> deleteContent(String params) async {
  //   if (sessionUID.isEmpty) return [];
  //   return await supabase.from(TABLE).delete().eq(UID, params).select();
  // }

  // Future<List> updateContent(UpdateContentParams params) async {
  //   if (sessionUID.isEmpty) return [];
  //   return await supabase
  //       .from(TABLE)
  //       .update({
  //         CONTENT: params.content,
  //         TYPE: SessionContentUtils.mapContentBlockTypeToString(
  //           params.contentBlockType,
  //         ),
  //         LAST_EDITED_AT: DateTime.now().toUtc().toIso8601String(),
  //       })
  //       .eq(UID, params.uid)
  //       .select();
  // }

  // Future<List> updateParent(UpdateParentParams params) async {
  //   if (sessionUID.isEmpty) return [];
  //   return await supabase
  //       .from(TABLE)
  //       .update({
  //         PARENT_UID: params.parentUID.isEmpty ? null : params.parentUID,
  //         LAST_EDITED_AT: DateTime.now().toUtc().toIso8601String(),
  //       })
  //       .eq(UID, params.uid)
  //       .select();
  // }
}
