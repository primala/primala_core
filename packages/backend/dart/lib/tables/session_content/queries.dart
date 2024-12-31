import 'package:nokhte_backend/tables/session_content.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionContentQueries with SessionContentConstants {
  String sessionUID = '';
  final SupabaseClient supabase;

  SessionContentQueries({
    required this.supabase,
  });

  setSessionUID(String value) => sessionUID = value;

  Future<List> addContent(AddContentParams params) async {
    print(
        'what is the parameters: ${params.parentUID} sessionUID: $sessionUID');
    if (sessionUID.isEmpty) return [];
    return await supabase.from(TABLE).insert({
      SESSION_UID: sessionUID,
      CONTENT: params.content,
      TYPE: SessionContentUtils.mapContentBlockTypeToString(
        params.contentBlockType,
      ),
      PARENT_UID: params.parentUID.isEmpty ? null : params.parentUID,
    }).select();
  }

  // Future<List> moveContent() async {}

  // Future<List> editContent() async {}
}
