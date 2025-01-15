// ignore_for_file: file_names

import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte_backend/tables/documents.dart';
import 'package:nokhte_backend/tables/documents/queries.dart';

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
      ),
    );
    documentId = res.first['id'];
    expect(res, isNotEmpty);
    expect(
      res.first['type'],
      equals(
        documentsQueries.mapDocumentTypeToString(
          DocumentType.evergreen,
        ),
      ),
    );
    expect(res.first['expiration_date'], isNull);
    expect(res.first['group_id'], equals(tSetup.groupId));
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
    expect(res.first['title'], equals('New Title'));
    expect(res.first['group_id'], equals(tSetup.groupId));
  });

  test("should be able to delete the document", () async {
    final res = await documentsQueries.deleteDocument(documentId);

    expect(res, isNotEmpty);
    expect(res.first['id'], equals(documentId));
    expect(res.first['group_id'], equals(tSetup.groupId));
    final res2 = await documentsQueries.selectByGroup(tSetup.groupId);
    expect(res2, isEmpty);
  });
}
