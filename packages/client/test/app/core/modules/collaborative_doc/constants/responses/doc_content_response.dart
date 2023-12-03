import 'package:nokhte_backend/tables/working_collaborative_documents.dart';

class DocContentResonse {
  static Stream<DocInfoContent> get successfulResponse => Stream.value(
        DocInfoContent(
          usersContent: "content",
          collaboratorsContent: "content",
          lastEditWasTheUser: true,
          currentUserUID: "lastEditedBy",
          collaboratorsCommitDesireStatus: true,
          documentCommitStatus: true,
          userCommitDesireStatus: true,
        ),
      );
  static Stream<DocInfoContent> get notSuccessfulResponse => Stream.value(
        DocInfoContent(
          usersContent: "",
          collaboratorsContent: "",
          lastEditWasTheUser: false,
          currentUserUID: "",
          collaboratorsCommitDesireStatus: false,
          documentCommitStatus: false,
          userCommitDesireStatus: false,
        ),
      );
}
