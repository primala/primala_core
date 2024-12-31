import 'dart:async';
import 'package:nokhte_backend/tables/session_content.dart';
import 'package:nokhte_backend/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionContentStreams with SessionContentConstants, SessionUtils {
  bool contentListeningStatus = false;
  final SupabaseClient supabase;
  final SessionContentList _contentList = [];

  SessionContentStreams({
    required this.supabase,
  });

  Future<bool> cancelContentListeningStream() async {
    final res = supabase.realtime.getChannels();
    if (res.isNotEmpty) {
      await res.first.unsubscribe();
    }
    _contentList.clear();
    contentListeningStatus = false;
    return contentListeningStatus;
  }

  Stream<List<SessionContentEntity>> listenToContent(String sessionUID) async* {
    contentListeningStatus = true;
    List<SessionContentEntity> previousYield = [];

    final events = supabase
        .from(TABLE)
        .stream(
          primaryKey: ['uid'],
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

      _contentList.clear();

      final parentMap = <String, String?>{};
      final depthCache = <String, int>{};

      for (var item in event) {
        parentMap[item['uid'].toString()] = item['parent_uid']?.toString();
      }

      int calculateDepth(String uid) {
        if (depthCache.containsKey(uid)) {
          return depthCache[uid]!;
        }

        final parentUid = parentMap[uid];
        if (parentUid == null) {
          return 0;
        }

        final depth = 1 + calculateDepth(parentUid);
        depthCache[uid] = depth;
        return depth;
      }

      final itemsMap = {
        for (var e in event)
          e['uid'].toString(): SessionContentEntity.fromSupabase(
            e,
            calculateDepth(e['uid'].toString()),
          )
      };

      final childrenMap = <String, List<Map<String, dynamic>>>{};
      for (var item in event) {
        final parentUid = item['parent_uid']?.toString();
        if (parentUid != null) {
          childrenMap.putIfAbsent(parentUid, () => []).add(item);
        }
      }

      for (var children in childrenMap.values) {
        children.sort((a, b) => DateTime.parse(a['last _edited_at'])
            .compareTo(DateTime.parse(b['last_edited_at'])));
      }

      void addItemAndChildren(String uid) {
        if (!itemsMap.containsKey(uid)) return;

        _contentList.add(itemsMap[uid]!);

        final children = childrenMap[uid] ?? [];
        for (var child in children) {
          addItemAndChildren(child['uid'].toString());
        }
      }

      final rootItems = event.where((e) => e['parent_uid'] == null).toList()
        ..sort((a, b) => DateTime.parse(a['last_edited_at'])
            .compareTo(DateTime.parse(b['last_edited_at'])));

      for (var rootItem in rootItems) {
        addItemAndChildren(rootItem['uid'].toString());
      }

      if (!areListsEqual<SessionContentEntity>(_contentList, previousYield)) {
        previousYield = List.from(_contentList);
        yield _contentList;
      }
    }
  }
}
