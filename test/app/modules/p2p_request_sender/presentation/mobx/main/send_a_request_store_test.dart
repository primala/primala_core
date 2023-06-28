// * Testing & Mocking Libs
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:primala/app/core/constants/failure_constants.dart';
import 'package:primala/app/core/mobx/store_state.dart';
import 'package:primala/app/modules/p2p_request_sender/domain/logic/send_a_request.dart';
import 'package:primala/app/modules/p2p_request_sender/presentation/mobx/main/send_a_request_store.dart';
import '../../../constants/entities.dart';
import '../../../fixtures/p2p_request_sender_mock_gen.mocks.dart';

void main() {
  late MockMSendARequestGetterStore mockGetterStore;
  late SendARequestStore sendARequestStore;
  const tParams = P2PSendReqParams(username: "test");

  setUp(() {
    mockGetterStore = MockMSendARequestGetterStore();
    sendARequestStore = SendARequestStore(
      sendARequestGetterStore: mockGetterStore,
    );
  });

  group("stateOrErrorUpdater", () {
    test("✅ SUCCESS CASE: should update accordingly if state is passed",
        () async {
      //arrange
      // act
      sendARequestStore.stateOrErrorUpdater(
          Right(ConstantEntities.successfulP2PRequestStatusEntity));
      // assert
      expect(sendARequestStore.isSent, true);
      expect(sendARequestStore.errorMessage, "");
    });
    test("❌ FAILURE CASE: should update accordingly if error is passed",
        () async {
      // arrange

      // act
      sendARequestStore.stateOrErrorUpdater(Left(FailureConstants.dbFailure));
      // assert
      expect(sendARequestStore.isSent, false);
      expect(
          sendARequestStore.errorMessage, FailureConstants.genericFailureMsg);
      expect(sendARequestStore.state, StoreState.initial);
    });
  });

  group("call", () {
    test("✅ SUCCESS CASE: should update accordingly if state is passed",
        () async {
      //arrange
      expect(sendARequestStore.state, StoreState.initial);
      when(mockGetterStore(tParams.username)).thenAnswer(
        (_) async => Right(ConstantEntities.successfulP2PRequestStatusEntity),
      );
      // act
      await sendARequestStore(tParams);
      // assert
      expect(sendARequestStore.isSent, true);
      expect(sendARequestStore.errorMessage, "");
      expect(sendARequestStore.state, StoreState.loaded);
    });
    test("❌ FAILURE CASE: should update accordingly if error is passed",
        () async {
      // arrange

      when(mockGetterStore(tParams.username)).thenAnswer(
        (_) async => Left(FailureConstants.dbFailure),
      );
      // act
      await sendARequestStore(tParams);
      // assert
      expect(sendARequestStore.isSent, false);
      expect(
          sendARequestStore.errorMessage, FailureConstants.genericFailureMsg);
      expect(sendARequestStore.state, StoreState.initial);
    });
  });
}
