import 'package:equatable/equatable.dart';

class ToggleArchiveParams extends Equatable {
  final int documentId;
  final bool shouldArchive;

  const ToggleArchiveParams({
    required this.documentId,
    required this.shouldArchive,
  });

  @override
  List<Object> get props => [documentId, shouldArchive];
}
