import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:primala/app/core/constants/failure_constants.dart';
import 'package:primala/app/core/error/failure.dart';
import 'package:primala/app/modules/p2p_scheduling_sender/domain/entities/p2p_scheduling_request_status_entity.dart';
import 'package:primala/app/modules/p2p_scheduling_sender/presentation/mobx/getters/send_scheduling_request_getter_store.dart';
import '../../../constants/param/send_param_entities.dart';
import '../../../constants/return/send/send_scheduling_request_status_entities.dart';
import '../../../fixtures/p2p_scheduling_sender_mock_gen.mocks.dart';

void main() {
  late MockMSendSchedulingRequest mockLogic;
  late SendSchedulingRequestGetterStore getterStore;
  late Either<Failure, P2PSchedulingRequestStatusEntity> tEitherStatusOrFailure;

  setUp(() {
    mockLogic = MockMSendSchedulingRequest();
    getterStore = SendSchedulingRequestGetterStore(
      sendSchedulingRequestLogic: mockLogic,
    );
  });

  group("✅ Success Cases", () {
    setUp(() {
      tEitherStatusOrFailure =
          const Right(P2PSchedulingRequestStatusEntity(isSent: true));
    });

    test("should pass the right entity w/ the right state", () async {
      when(mockLogic(ConstantSendParamEntities.sendScheduleParamEntity))
          .thenAnswer(
        (_) async =>
            ConstantSendSchedulingRequestStatusEntities.wrappedSuccessCase,
      );
      final res =
          await getterStore(ConstantSendParamEntities.sendScheduleParamEntity);
      expect(res, tEitherStatusOrFailure);
    });
  });
  group("❌ Failure Cases", () {
    setUp(() {
      tEitherStatusOrFailure = Left(FailureConstants.dbFailure);
    });

    test('should pass a failure correctly', () async {
      when(mockLogic(ConstantSendParamEntities.sendScheduleParamEntity))
          .thenAnswer(
        (_) async => tEitherStatusOrFailure,
      );
      final res =
          await getterStore(ConstantSendParamEntities.sendScheduleParamEntity);
      expect(res, tEitherStatusOrFailure);
    });
  });
}
