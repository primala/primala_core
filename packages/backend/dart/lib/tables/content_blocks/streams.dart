import 'dart:async';
import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:nokhte_backend/tables/sessions/utilities/utilities.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionContentStreams with SessionContentConstants, SessionsUtils {
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
          primaryKey: [UID],
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
        parentMap[item[UID].toString()] = item[PARENT_UID]?.toString();
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
          e[UID].toString(): SessionContentEntity.fromSupabase(
            e,
            calculateDepth(e[UID].toString()),
          )
      };

      final childrenMap = <String, List<Map<String, dynamic>>>{};
      for (var item in event) {
        final parentUid = item[PARENT_UID]?.toString();
        if (parentUid != null) {
          childrenMap.putIfAbsent(parentUid, () => []).add(item);
        }
      }

      // print(' what are the children map values ${childrenMap.values}');
      for (var children in childrenMap.values) {
        children.sort((a, b) => DateTime.parse(a[LAST_EDITED_AT])
            .compareTo(DateTime.parse(b[LAST_EDITED_AT])));
      }

      void addItemAndChildren(String uid) {
        if (!itemsMap.containsKey(uid)) return;

        _contentList.add(itemsMap[uid]!);

        final children = childrenMap[uid] ?? [];
        for (var child in children) {
          addItemAndChildren(child[UID].toString());
        }
      }

      final rootItems = event.where((e) => e[PARENT_UID] == null).toList()
        ..sort((a, b) => DateTime.parse(a[LAST_EDITED_AT])
            .compareTo(DateTime.parse(b[LAST_EDITED_AT])));

      for (var rootItem in rootItems) {
        addItemAndChildren(rootItem[UID].toString());
      }

      if (!areListsEqual<SessionContentEntity>(_contentList, previousYield)) {
        previousYield = List.from(_contentList);
        yield _contentList;
      }
    }
  }
}
