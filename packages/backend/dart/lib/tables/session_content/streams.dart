import 'package:nokhte_backend/tables/session_content.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionContentStreams with SessionContentConstants {
  bool contentListeningStatus = false;
  final SupabaseClient supabase;

  SessionContentStreams({
    required this.supabase,
  });

  Future<bool> cancelContentListeningStream() async {
    final res = supabase.realtime.getChannels();
    if (res.isNotEmpty) {
      await res.first.unsubscribe();
    }
    contentListeningStatus = false;
    return contentListeningStatus;
  }

  Stream<List<ContentBlock>> listenToContent(String sessionUID) async* {
    print('what is the session uid $sessionUID');
    contentListeningStatus = true;

    final events = supabase
        .from(TABLE)
        .stream(
          primaryKey: ['id'],
        )
        .eq(
          SESSION_UID,
          sessionUID,
        )
        .order(
          LAST_EDITED_AT,
          ascending: true,
        );

    await for (var event in events) {
      if (!contentListeningStatus || sessionUID.isEmpty) {
        break;
      }
      yield ContentBlock.fromSupabase(event);
    }
  }
}
