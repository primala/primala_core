import 'package:faker/faker.dart';
import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/documents.dart';

typedef DocumentEntities = List<DocumentEntity>;

class DocumentEntity extends Equatable {
  final int id;
  final int spotlightContentId;
  final String title;

  DocumentEntity({
    required this.id,
    required this.spotlightContentId,
    required this.title,
  });

  @override
  List<Object> get props => [
        id,
        spotlightContentId,
        title,
      ];

  factory DocumentEntity.fromSupabaseSingle(Map<String, dynamic> doc) {
    return DocumentEntity(
      id: doc[DocumentConstants.S_ID],
      spotlightContentId: doc[DocumentConstants.S_SPOTLIGHT_CONTENT_ID],
      title: doc[DocumentConstants.S_TITLE],
    );
  }

  factory DocumentEntity.initial() => DocumentEntity(
        id: -1,
        spotlightContentId: -1,
        title: '',
      );

  static DocumentEntities fromSupabaseMultiple(List res) {
    List<DocumentEntity> temp = [];
    for (var doc in res) {
      print('what is the doc $doc');
      temp.add(DocumentEntity.fromSupabaseSingle(doc));
    }
    return temp;
  }

  static DocumentEntities generateFakeDocuments(int count) {
    final faker = Faker();

    return List.generate(count, (index) {
      return DocumentEntity(
        id: index + 1,
        spotlightContentId: faker.randomGenerator.integer(100, min: 1),
        title: faker.lorem.sentence(),
      );
    });
  }
}
