import 'package:equatable/equatable.dart';

class UpdateDocumentTitleParams extends Equatable {
  final int documentId;
  final String title;

  UpdateDocumentTitleParams({
    required this.documentId,
    required this.title,
  });

  @override
  List<Object> get props => [documentId, title];
}
