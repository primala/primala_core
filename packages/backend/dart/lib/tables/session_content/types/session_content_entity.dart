import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/session_content.dart';

typedef SessionContentList = List<SessionContentEntity>;

class SessionContentEntity extends Equatable {
  final String uid;
  final String content;
  final ContentBlockType blockType;
  final SessionContentEntity? child;

  const SessionContentEntity({
    required this.uid,
    required this.content,
    required this.blockType,
    this.child,
  });

  factory SessionContentEntity.initial() => const SessionContentEntity(
        uid: '',
        content: '',
        blockType: ContentBlockType.none,
      );

  factory SessionContentEntity.fromSupabase(Map<String, dynamic> data,
      Map<String, SessionContentEntity> contentCache) {
    return SessionContentEntity(
      uid: data[SessionContentConstants.S_UID],
      content: data[SessionContentConstants.S_CONTENT],
      blockType: SessionContentUtils.mapStringToContentBlockType(
        data[SessionContentConstants.S_TYPE],
      ),
      child: data[SessionContentConstants.S_PARENT_UID] != null
          ? contentCache[data[SessionContentConstants.S_PARENT_UID]]
          : null,
    );
  }

  @override
  List<Object> get props => [
        uid,
        content,
        blockType,
        child ?? SessionContentEntity.initial(),
      ];
}
