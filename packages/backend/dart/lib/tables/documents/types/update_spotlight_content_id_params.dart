import 'package:equatable/equatable.dart';

class UpdateSpotlightContentIdParams extends Equatable {
  final int documentId;
  final int contentId;
  UpdateSpotlightContentIdParams({
    required this.documentId,
    required this.contentId,
  });

  @override
  List<Object> get props => [documentId, contentId];
}
