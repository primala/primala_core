import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:primala/app/core/constants/failure_constants.dart';
import 'package:primala/app/core/error/failure.dart';
import 'package:primala/app/modules/p2p_request_sender/domain/entities/p2p_request_recipient_entity.dart';
import 'package:primala/app/modules/p2p_request_sender/domain/logic/validate_request.dart';
import 'package:primala/app/modules/p2p_request_sender/presentation/mobx/getters/validate_request_getter_store.dart';
import '../../../fixtures/p2p_request_sender_mock_gen.mocks.dart';

void main() {
  late MockMValidateRequest mockLogic;
  late ValidateRequestGetterStore getterStore;
  late Either<Failure, P2PRequestRecipientEntity> tEitherReqRecipientOrFailure;

  setUp(() {
    mockLogic = MockMValidateRequest();
    getterStore = ValidateRequestGetterStore(
      validateRequest: mockLogic,
    );
  });

  group("✅ Success Cases", () {
    setUp(() {
      tEitherReqRecipientOrFailure = const Right(P2PRequestRecipientEntity(
          exists: true, duplicateRecipient: false, duplicateSender: false));
    });
    test("should pass the entity w/ the right state", () async {
      when(mockLogic(const P2PReqRecipientParams(username: "test")))
          .thenAnswer((_) async => tEitherReqRecipientOrFailure);
      final res = await getterStore('test');
      expect(res, tEitherReqRecipientOrFailure);
    });
  });

  group("❌FAILURE Cases", () {
    setUp(() {
      tEitherReqRecipientOrFailure = Left(FailureConstants.dbFailure);
    });

    test("should pass the entity w/ the right state", () async {
      when(mockLogic(const P2PReqRecipientParams(username: "test")))
          .thenAnswer((_) async => tEitherReqRecipientOrFailure);
      final res = await getterStore('test');
      expect(res, tEitherReqRecipientOrFailure);
    });
  });
}
