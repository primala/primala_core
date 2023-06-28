import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:primala/app/core/constants/failure_constants.dart';
import 'package:primala/app/core/mobx/store_state.dart';
import 'package:primala/app/modules/p2p_scheduling_sender/presentation/mobx/main/send_scheduling_request_store.dart';
import '../../../constants/param/send_param_entities.dart';
import '../../../constants/return/send/send_scheduling_request_status_entities.dart';
import '../../../fixtures/p2p_scheduling_sender_mock_gen.mocks.dart';

void main() {
  late MockMSendSchedulingRequestGetterStore mockGetterStore;
  late SendSchedulingRequestStore sendSchedulingRequestStore;
  setUp(() {
    mockGetterStore = MockMSendSchedulingRequestGetterStore();
    sendSchedulingRequestStore = SendSchedulingRequestStore(
      sendSchedulingRequestGetterStore: mockGetterStore,
    );
  });

  group('stateOrErrorUpdater', () {
    test("✅ Success Case: should update accordingly if state is passed", () {
      sendSchedulingRequestStore.stateOrErrorUpdater(
        ConstantSendSchedulingRequestStatusEntities.wrappedSuccessCase,
      );
      expect(sendSchedulingRequestStore.isSent, true);
      expect(sendSchedulingRequestStore.errorMessage, "");
    });

    test("❌ Failure Case: should update accordingly if Failure is passed", () {
      sendSchedulingRequestStore
          .stateOrErrorUpdater(Left(FailureConstants.dbFailure));
      expect(sendSchedulingRequestStore.isSent, false);
      expect(sendSchedulingRequestStore.errorMessage,
          FailureConstants.genericFailureMsg);
      expect(sendSchedulingRequestStore.state, StoreState.initial);
    });
  });
  group('call', () {
    test("✅ Success Case: should update accordingly if state is passed",
        () async {
      when(mockGetterStore(ConstantSendParamEntities.sendScheduleParamEntity))
          .thenAnswer(
        (_) async =>
            ConstantSendSchedulingRequestStatusEntities.wrappedSuccessCase,
      );
      await sendSchedulingRequestStore(
          ConstantSendParamEntities.sendScheduleParamEntity);

      expect(sendSchedulingRequestStore.isSent, true);
      expect(sendSchedulingRequestStore.errorMessage, "");
    });

    test("❌ Failure Case: should update accordingly if Failure is passed",
        () async {
      when(mockGetterStore(ConstantSendParamEntities.sendScheduleParamEntity))
          .thenAnswer(
        (_) async => Left(FailureConstants.dbFailure),
      );
      await sendSchedulingRequestStore(
          ConstantSendParamEntities.sendScheduleParamEntity);
      expect(sendSchedulingRequestStore.isSent, false);
      expect(sendSchedulingRequestStore.errorMessage,
          FailureConstants.genericFailureMsg);
      expect(sendSchedulingRequestStore.state, StoreState.initial);
    });
  });
}
