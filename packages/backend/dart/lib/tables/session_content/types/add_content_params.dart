import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/session_content.dart';

class AddContentParams extends Equatable {
  final String content;
  final String? parentUID;
  final ContentBlockType contentBlockType;

  AddContentParams({
    required this.content,
    required this.parentUID,
    required this.contentBlockType,
  });

  @override
  List<Object> get props => [
        content,
        parentUID ?? '',
        contentBlockType,
      ];
}
