import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';

class UpdateContentParams extends Equatable {
  final String content;
  final String uid;
  final ContentBlockType contentBlockType;

  UpdateContentParams({
    required this.content,
    required this.uid,
    required this.contentBlockType,
  });

  factory UpdateContentParams.initial() => UpdateContentParams(
        content: '',
        uid: '',
        contentBlockType: ContentBlockType.none,
      );

  @override
  List<Object> get props => [
        content,
        uid,
        contentBlockType,
      ];
}
