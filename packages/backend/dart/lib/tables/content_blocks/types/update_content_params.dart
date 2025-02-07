import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';

class UpdateContentParams extends Equatable {
  final String content;
  final int contentId;
  final ContentBlockType contentBlockType;

  UpdateContentParams({
    required this.content,
    required this.contentId,
    required this.contentBlockType,
  });

  factory UpdateContentParams.initial() => UpdateContentParams(
        content: '',
        contentId: -1,
        contentBlockType: ContentBlockType.none,
      );

  @override
  List<Object> get props => [
        content,
        contentId,
        contentBlockType,
      ];
}
