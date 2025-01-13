import 'package:equatable/equatable.dart';

class UpdateParentParams extends Equatable {
  final int parentId;
  final int contentId;

  UpdateParentParams({
    required this.parentId,
    required this.contentId,
  });

  factory UpdateParentParams.initial() => UpdateParentParams(
        contentId: -1,
        parentId: -1,
      );

  @override
  List<Object> get props => [parentId, contentId];
}
