// * testing lib
import 'package:flutter_test/flutter_test.dart';
// * mocking lib
import 'package:mockito/mockito.dart';
import 'package:primala/app/core/constants/failure_constants.dart';
import 'package:primala/app/core/modules/collaborative_doc/data/data.dart';
import 'package:primala_backend/working_collaborative_documents.dart';
// * primala core imports
// * mock import
import '../../constants/models/models.dart';
import '../../constants/responses/responses.dart';
import '../../fixtures/collaborative_doc_mock_gen.mocks.dart';
import '../../../../../modules/_module_helpers/shared_mocks_gen.mocks.dart'
    show MockMNetworkInfo;
// * functional programming
import 'package:dartz/dartz.dart';

void main() {
  late CollaborativeDocContractImpl collaborativeDocContract;
  late MockMCollaborativeDocRemoteSource mockRemoteSource;
  late MockMNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteSource = MockMCollaborativeDocRemoteSource();
    mockNetworkInfo = MockMNetworkInfo();
    collaborativeDocContract = CollaborativeDocContractImpl(
      remoteSource: mockRemoteSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group("Method No. 1: getCollaborativeDocContent", () {
    group("is Online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test("when online and non-empty should return a model", () async {
        // arrange
        when(mockRemoteSource.getCollaborativeDocContent()).thenAnswer(
            (realInvocation) => DocContentResonse.successfulResponse);
        // act
        final res = await collaborativeDocContract.getCollaborativeDocContent();
        // assert
        res.fold((failure) {}, (contentEntity) {
          contentEntity.docContent.listen((value) {
            expect(value.content, "content");
            expect(value.lastEditedBy, "lastEditedBy");
            expect(value.currentUserUID, 'lastEditedBy');
          });
          // expect(contentEntity.docContent, emits("content"));
        });
      });
      test("when online and empty should return a model", () async {
        // arrange
        when(mockRemoteSource.getCollaborativeDocContent()).thenAnswer(
            (realInvocation) => DocContentResonse.notSuccessfulResponse);
        // act
        final res = await collaborativeDocContract.getCollaborativeDocContent();
        // assert
        res.fold((failure) {}, (contentEntity) {
          contentEntity.docContent.listen((value) {
            expect(value.content, "");
            expect(value.lastEditedBy, "");
            expect(value.currentUserUID, '');
          });
        });
      });
    });
    group("is not Online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test("When offline should return an internet connection error", () async {
        final res = await collaborativeDocContract.getCollaborativeDocContent();
        expect(res, Left(FailureConstants.internetConnectionFailure));
      });
    });
  });

  group("Method No. 2: getCollaboratorDocInfo", () {
    group("is Online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test("when online and non-empty should return a model", () async {
        // arrange
        when(mockRemoteSource.getCollaboratorDocInfo()).thenAnswer(
            (realInvocation) =>
                Stream.value(CollaboratorDocInfo(delta: 1, isPresent: true)));
        // act
        final res = await collaborativeDocContract.getCollaboratorDocInfo();
        // assert
        res.fold((failure) {}, (docInfoEntity) {
          docInfoEntity.collaboratorDocInfo.listen((event) {
            expect(event.delta, 1);
            expect(event.isPresent, true);
          });
        });
      });
    });
    group("is not Online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test("When offline should return an internet connection error", () async {
        final res = await collaborativeDocContract.getCollaboratorDocInfo();
        expect(res, Left(FailureConstants.internetConnectionFailure));
      });
    });
  });
  group("Method No. 3: createCollaborativeDoc", () {
    group("is Online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test("when online and non-empty should return a model", () async {
        // arrange
        when(mockRemoteSource.createCollaborativeDoc(docType: 'purpose'))
            .thenAnswer((realInvocation) async => [{}]);
        // act
        final res = await collaborativeDocContract.createCollaborativeDoc(
            docType: 'purpose');
        // assert
        expect(res,
            ConstantCollaborativeDocCreationStatusModel.wrappedSuccessCase);
      });
      test("when online and empty should return a model", () async {
        // arrange
        when(mockRemoteSource.createCollaborativeDoc(docType: 'purpose'))
            .thenAnswer((realInvocation) async => []);
        // act
        final res = await collaborativeDocContract.createCollaborativeDoc(
            docType: 'purpose');
        // assert
        expect(res,
            ConstantCollaborativeDocCreationStatusModel.wrappedNotSuccessCase);
      });
    });
    group("is not Online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test("When offline should return an internet connection error", () async {
        final res = await collaborativeDocContract.createCollaborativeDoc(
            docType: 'purpose');
        expect(res, Left(FailureConstants.internetConnectionFailure));
      });
    });
  });
  group("Method No. 4: updateCollaborativeDoc", () {
    group("is Online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test("when online and non-empty should return a model", () async {
        // arrange
        when(mockRemoteSource.updateCollaborativeDoc(newContent: 'newContent'))
            .thenAnswer((realInvocation) async => [{}]);
        // act
        final res = await collaborativeDocContract.updateCollaborativeDoc(
            newContent: 'newContent');
        // assert
        expect(
            res, ConstantCollaborativeDocUpdateStatusModel.wrappedSuccessCase);
      });
    });
    group("is not Online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test("When offline should return an internet connection error", () async {
        final res = await collaborativeDocContract.updateCollaborativeDoc(
            newContent: 'newContent');
        expect(res, Left(FailureConstants.internetConnectionFailure));
      });
    });
  });
  group("Method No. 5: updateUserDelta", () {
    group("is Online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test("when online and non-empty should return a model", () async {
        // arrange
        when(mockRemoteSource.updateUserDelta(updatedDelta: 1))
            .thenAnswer((realInvocation) async => [{}]);
        // act
        final res = await collaborativeDocContract.updateUserDelta(newDelta: 1);
        // assert
        expect(res,
            ConstantCollaborativeDocDeltaUpdaterStatusModel.wrappedSuccessCase);
      });
    });
    group("is not Online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test("When offline should return an internet connection error", () async {
        final res = await collaborativeDocContract.updateUserDelta(newDelta: 1);
        expect(res, Left(FailureConstants.internetConnectionFailure));
      });
    });
  });
  group("Method No. 6: updateUserPresence", () {
    group("is Online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test("when online and non-empty should return a model", () async {
        // arrange
        when(mockRemoteSource.updateUserPresence(updatedUserPresence: false))
            .thenAnswer((realInvocation) async => [{}]);
        // act
        final res = await collaborativeDocContract.updateUserPresence(
          newPresence: false,
        );
        // assert
        expect(
          res,
          ConstantCollaborativeDocPresenceUpdaterStatusModel.wrappedSuccessCase,
        );
      });
    });
    group("is not Online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test("When offline should return an internet connection error", () async {
        final res = await collaborativeDocContract.updateCollaborativeDoc(
            newContent: 'newContent');
        expect(res, Left(FailureConstants.internetConnectionFailure));
      });
    });
  });
}
