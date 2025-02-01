// ignore_for_file: file_names

import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:nokhte_backend/tables/documents.dart';

import 'shared/shared.dart';

void main() {
  late DocumentsQueries documentsQueries;
  final tSetup = CommonCollaborativeTestFunctions();

  int documentId = 0;

  setUpAll(() async {
    await tSetup.setUp(createGroup: true);
    documentsQueries = DocumentsQueries(supabase: tSetup.user1Supabase);
  });

  tearDownAll(() async {
    await tSetup.teardown();
  });

  test("should be able to create a document", () async {
    final res = await documentsQueries.insertDocument(
      InsertDocumentParams(
        groupId: tSetup.groupId,
        type: DocumentType.evergreen,
        documentTitle: 'oh my god is that a black card?',
        contentBlockType: ContentBlockType.question,
        spotlightMessage:
            'I turned and replied why yes but I prefer the term african american express',
      ),
    );
    documentId = res['id'];
    expect(res, isNotEmpty);
    expect(
      res['type'],
      equals(
        documentsQueries.mapDocumentTypeToString(
          DocumentType.evergreen,
        ),
      ),
    );
    expect(res['expiration_date'], isNull);
    expect(res['group_id'], equals(tSetup.groupId));
  });

  test("should be able to update the document type", () async {
    final res = await documentsQueries.updateType(
      UpdateDocumentTypeParams(
        documentId: documentId,
        type: DocumentType.ephemeral,
      ),
    );

    expect(res, isNotEmpty);
    expect(
      res.first['type'],
      equals(
        documentsQueries.mapDocumentTypeToString(
          DocumentType.ephemeral,
        ),
      ),
    );
    expect(res.first['expiration_date'], isNotNull);
    expect(res.first['group_id'], equals(tSetup.groupId));
  });
  test("should be able to update the title", () async {
    final res = await documentsQueries.updateTitle(
      UpdateDocumentTitleParams(
        documentId: documentId,
        title: 'New Title',
      ),
    );

    expect(res, isNotEmpty);
    expect(res['title'], equals('New Title'));
    expect(res['group_id'], equals(tSetup.groupId));
  });

  test("should be able to delete the document", () async {
    final res = await documentsQueries.deleteDocument(documentId);

    expect(res, isNotEmpty);
    expect(res['id'], equals(documentId));
    expect(res['group_id'], equals(tSetup.groupId));
    final res2 = await documentsQueries.selectByGroup(tSetup.groupId);
    expect(res2, isEmpty);
  });
}
