import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:primala/app/core/constants/failure_constants.dart';
import 'package:primala/app/core/error/failure.dart';
import 'package:primala/app/modules/p2p_request_sender/domain/entities/p2p_request_sender_status_entity.dart';
import 'package:primala/app/modules/p2p_request_sender/domain/logic/send_a_request.dart';
import 'package:primala/app/modules/p2p_request_sender/presentation/mobx/getters/send_a_request_getter_store.dart';
import '../../../fixtures/p2p_request_sender_mock_gen.mocks.dart';

void main() {
  late MockMSendARequest mockLogic;
  late SendARequestGetterStore getterStore;
  late Either<Failure, P2PRequestSenderStatusEntity> tEitherReqStatusOrFailure;

  setUp(() {
    mockLogic = MockMSendARequest();
    getterStore = SendARequestGetterStore(sendLogic: mockLogic);
  });

  group("✅ Success Cases", () {
    setUp(() {
      tEitherReqStatusOrFailure =
          const Right(P2PRequestSenderStatusEntity(isSent: true));
    });
    test("should pass the entity w/ the right state", () async {
      when(mockLogic(const P2PSendReqParams(username: "test")))
          .thenAnswer((_) async => tEitherReqStatusOrFailure);
      final res = await getterStore('test');
      expect(res, tEitherReqStatusOrFailure);
    });
  });

  group("❌FAILURE Cases", () {
    setUp(() {
      tEitherReqStatusOrFailure = Left(FailureConstants.dbFailure);
    });

    test("should pass the entity w/ the right state", () async {
      when(mockLogic(const P2PSendReqParams(username: "test")))
          .thenAnswer((_) async => tEitherReqStatusOrFailure);
      final res = await getterStore('test');
      expect(res, tEitherReqStatusOrFailure);
    });
  });
}
