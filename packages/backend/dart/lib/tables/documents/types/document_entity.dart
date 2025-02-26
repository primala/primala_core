import 'package:faker/faker.dart';
import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/documents.dart';

typedef DocumentEntities = List<DocumentEntity>;

class DocumentEntity extends Equatable {
  final int id;
  final int spotlightContentId;
  final String title;
  final bool isArchived;

  DocumentEntity({
    required this.id,
    required this.spotlightContentId,
    required this.title,
    required this.isArchived,
  });

  @override
  List<Object> get props => [
        id,
        spotlightContentId,
        title,
        isArchived,
      ];

  factory DocumentEntity.fromSupabaseSingle(Map<String, dynamic> doc) {
    return DocumentEntity(
      id: doc[DocumentConstants.S_ID],
      spotlightContentId: doc[DocumentConstants.S_SPOTLIGHT_CONTENT_ID] ?? -1,
      title: doc[DocumentConstants.S_TITLE],
      isArchived: doc[DocumentConstants.S_IS_ARCHIVED],
    );
  }

  factory DocumentEntity.initial() => DocumentEntity(
        id: -1,
        spotlightContentId: -1,
        isArchived: false,
        title: '',
      );

  static DocumentEntities fromSupabaseMultiple(List res) {
    List<DocumentEntity> temp = [];
    for (var doc in res) {
      temp.add(DocumentEntity.fromSupabaseSingle(doc));
    }
    return temp;
  }

  static DocumentEntities generateFakeDocuments(int count) {
    final faker = Faker();

    return List.generate(count, (index) {
      return DocumentEntity(
        isArchived: false,
        id: index + 1,
        spotlightContentId: faker.randomGenerator.integer(100, min: 1),
        title: faker.lorem.sentence(),
      );
    });
  }
}
