// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';

typedef ContentBlockList = List<ContentBlockEntity>;

class ContentBlockEntity extends Equatable {
  final int id;
  final String content;
  final ContentBlockType blockType;
  final int numberOfParents;
  final DateTime lastEditedAt;

  ContentBlockEntity({
    required this.id,
    required this.content,
    required this.blockType,
    required this.numberOfParents,
    required this.lastEditedAt,
  });

  factory ContentBlockEntity.fromSupabase(
      Map<String, dynamic> record, int numberOfParents) {
    return ContentBlockEntity(
      id: record['id'],
      content: record['content'],
      blockType:
          SessionContentUtils.mapStringToContentBlockType(record['type']),
      numberOfParents: numberOfParents,
      lastEditedAt: DateTime.parse(record['last_edited_at']),
    );
  }

  factory ContentBlockEntity.initial() => ContentBlockEntity(
        id: 0,
        content: '',
        blockType: ContentBlockType.none,
        numberOfParents: 0,
        lastEditedAt: DateTime.now(),
      );

  @override
  List<Object> get props =>
      [id, content, blockType, numberOfParents, lastEditedAt];
}
