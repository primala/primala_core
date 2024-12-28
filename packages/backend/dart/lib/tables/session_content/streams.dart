import 'package:nokhte_backend/tables/session_content.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionContentStreams with SessionContentConstants {
  bool contentListeningStatus = false;
  final SupabaseClient supabase;
  final Map<String, SessionContentEntity> _contentCache = {};

  SessionContentStreams({
    required this.supabase,
  });

  Future<bool> cancelContentListeningStream() async {
    final res = supabase.realtime.getChannels();
    if (res.isNotEmpty) {
      await res.first.unsubscribe();
    }
    _contentCache.clear();
    contentListeningStatus = false;
    return contentListeningStatus;
  }

  Stream<SessionContentList> listenToContent(String sessionUID) async* {
    print('listening to content for session: $sessionUID');
    contentListeningStatus = true;
    SessionContentList previousYield = [];

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

      final temp = <SessionContentEntity>[];
      if (event.isNotEmpty) {
        for (var item in event) {
          final contentUid = item['uid'];

          final existingContent = _contentCache[contentUid];
          if (existingContent == null ||
              existingContent.content != item['content'] ||
              existingContent.blockType !=
                  SessionContentUtils.mapStringToContentBlockType(
                      item['type'])) {
            final contentEntity =
                SessionContentEntity.fromSupabase(item, _contentCache);
            _contentCache[contentUid] = contentEntity;
          }

          temp.add(_contentCache[contentUid]!);
        }

        _contentCache.removeWhere(
            (key, value) => !event.any((item) => item['uid'] == key));

        if (!SessionContentUtils.areContentListsEqual(temp, previousYield)) {
          previousYield = List.from(temp);
          yield temp;
        }
      } else {
        if (previousYield.isNotEmpty) {
          previousYield = [];
          _contentCache.clear();
          yield [];
        }
      }
    }
  }
}
