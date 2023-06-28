import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:primala/app/core/constants/failure_constants.dart';
import 'package:primala/app/core/interfaces/logic.dart';
import 'package:primala/app/core/mobx/store_state.dart';
import 'package:primala/app/modules/p2p_request_recipient/presentation/mobx/main/load_the_requests_store.dart';

import '../../../constants/entities.dart';
import '../../../fixtures/p2p_request_recipient_stack_mock_gen.mocks.dart';

void main() {
  late MockMLoadtheRequestsGetterStore mockGetterStore;
  late LoadTheRequestsStore loadRequestsStore;

  setUp(() {
    mockGetterStore = MockMLoadtheRequestsGetterStore();
    loadRequestsStore = LoadTheRequestsStore(
      loadTheRequestsGetterStore: mockGetterStore,
    );
  });

  group("stateOrErrorUpdater", () {
    test("✅ Success Case: should update state accoridngly if state is passed",
        () {
      loadRequestsStore.stateOrErrorUpdater(
        Right(ConstantEntities.formattedSuccessfulP2PRecipientRequestEntity),
      );
      expect(loadRequestsStore.requests,
          ConstantEntities.formattedSuccessfulP2PRecipientRequestEntity);
    });

    test("❌ Should update accordingly if error is passed", () {
      loadRequestsStore.stateOrErrorUpdater(Left(FailureConstants.dbFailure));
      expect(
          loadRequestsStore.errorMessage, FailureConstants.genericFailureMsg);
    });
  });
  group("call", () {
    test("✅ should update state accordingly when state is passed", () async {
      expect(loadRequestsStore.state, StoreState.initial);
      when(mockGetterStore()).thenAnswer(
        (realInvocation) async => Right(
          ConstantEntities.formattedSuccessfulP2PRecipientRequestEntity,
        ),
      );
      await loadRequestsStore(NoParams());

      expect(loadRequestsStore.requests,
          ConstantEntities.formattedSuccessfulP2PRecipientRequestEntity);
      expect(loadRequestsStore.errorMessage, "");
    });
    test("❌ should update state accordingly when error is passed", () async {
      expect(loadRequestsStore.state, StoreState.initial);
      when(mockGetterStore()).thenAnswer(
        (realInvocation) async => Left(FailureConstants.dbFailure),
      );
      await loadRequestsStore(NoParams());

      expect(
          loadRequestsStore.errorMessage, FailureConstants.genericFailureMsg);
    });
  });
}
