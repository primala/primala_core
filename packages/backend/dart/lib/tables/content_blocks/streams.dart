import 'dart:async';
import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:nokhte_backend/tables/sessions/utilities/session_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContentBlocksStreams with ContentBlocksConstants, SessionsUtils {
  bool contentListeningStatus = false;
  final SupabaseClient supabase;
  final ContentBlocks _contentList = [];

  ContentBlocksStreams({
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

  Stream<ContentBlocks> listenToDocumentContent(int documentId) async* {
    contentListeningStatus = true;
    ContentBlocks previousYield = [];

    final events = supabase
        .from(TABLE)
        .stream(
          primaryKey: [ID],
        )
        .eq(
          DOCUMENT_ID,
          documentId,
        )
        .order(
          LAST_EDITED_AT,
          ascending: true,
        );

    await for (var event in events) {
      if (!contentListeningStatus || documentId == -1) {
        break;
      }

      _contentList.clear();

      final parentMap = <int, int?>{};
      final depthCache = <int, int>{};

      for (var item in event) {
        parentMap[item[ID]] = item[PARENT_ID];
      }

      int calculateDepth(int contentId) {
        if (depthCache.containsKey(contentId)) {
          return depthCache[contentId]!;
        }

        final parentId = parentMap[contentId];
        if (parentId == null) {
          return 0;
        }

        final depth = 1 + calculateDepth(parentId);
        depthCache[contentId] = depth;
        return depth;
      }

      final itemsMap = {
        for (var e in event)
          e[ID]: ContentBlockEntity.fromSupabase(
            e,
            calculateDepth(e[ID]),
          )
      };

      final childrenMap = <int, List<Map<String, dynamic>>>{};
      for (var item in event) {
        final parentId = item[PARENT_ID];
        if (parentId != null) {
          childrenMap.putIfAbsent(parentId, () => []).add(item);
        }
      }

      // print(' what are the children map values ${childrenMap.values}');
      for (var children in childrenMap.values) {
        children.sort((a, b) => DateTime.parse(a[LAST_EDITED_AT])
            .compareTo(DateTime.parse(b[LAST_EDITED_AT])));
      }

      void addItemAndChildren(int contentId) {
        if (!itemsMap.containsKey(contentId)) return;

        _contentList.add(itemsMap[contentId]!);

        final children = childrenMap[contentId] ?? [];
        for (var child in children) {
          addItemAndChildren(child[ID]);
        }
      }

      final rootItems = event.where((e) => e[PARENT_ID] == null).toList()
        ..sort((a, b) => DateTime.parse(a[LAST_EDITED_AT])
            .compareTo(DateTime.parse(b[LAST_EDITED_AT])));

      for (var rootItem in rootItems) {
        addItemAndChildren(rootItem[ID]);
      }

      if (!areListsEqual<ContentBlockEntity>(_contentList, previousYield)) {
        previousYield = List.from(_contentList);
        yield _contentList;
      }
    }
  }
}
