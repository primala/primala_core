// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/session_content.dart';

typedef SessionContentList = List<SessionContentEntity>;

class SessionContentEntity extends Equatable {
  final String uid;
  final String content;
  final ContentBlockType blockType;
  final int numberOfParents;
  final DateTime lastEditedAt;

  SessionContentEntity({
    required this.uid,
    required this.content,
    required this.blockType,
    required this.numberOfParents,
    required this.lastEditedAt,
  });

  factory SessionContentEntity.fromSupabase(
      Map<String, dynamic> record, int numberOfParents) {
    return SessionContentEntity(
      uid: record['uid'],
      content: record['content'],
      blockType:
          SessionContentUtils.mapStringToContentBlockType(record['type']),
      numberOfParents: numberOfParents,
      lastEditedAt: DateTime.parse(record['last_edited_at']),
    );
  }

  @override
  List<Object> get props =>
      [uid, content, blockType, numberOfParents, lastEditedAt];
}
