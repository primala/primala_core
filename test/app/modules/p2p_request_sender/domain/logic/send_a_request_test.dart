// * Testing & Mocking Libs
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:primala/app/core/constants/failure_constants.dart';
import 'package:primala/app/modules/p2p_request_sender/domain/logic/send_a_request.dart';

import '../../fixtures/p2p_request_sender_mock_gen.mocks.dart';
import '../../constants/entities.dart';

void main() {
  late MockMP2PRequestSenderContract mockContract;
  late SendARequest sendARequestLogic;
  final dbFailure = FailureConstants.dbFailure;

  setUp(() {
    mockContract = MockMP2PRequestSenderContract();
    sendARequestLogic = SendARequest(contract: mockContract);
  });
  test("✅ should pass the Status Entity from Contract ==> Logic", () async {
    when(mockContract.sendARequest('test')).thenAnswer(
      (_) async => Right(ConstantEntities.successfulP2PRequestStatusEntity),
    );
    final result =
        await sendARequestLogic(const P2PSendReqParams(username: 'test'));
    expect(result, Right(ConstantEntities.successfulP2PRequestStatusEntity));
    verify(mockContract.sendARequest('test'));
    verifyNoMoreInteractions(mockContract);
  });
  test("✅ should pass A Failure from Contract ==> Logic", () async {
    when(mockContract.sendARequest('test')).thenAnswer(
      (_) async => Left(dbFailure),
    );
    final result =
        await sendARequestLogic(const P2PSendReqParams(username: 'test'));
    expect(result, Left(dbFailure));
    verify(mockContract.sendARequest('test'));
    verifyNoMoreInteractions(mockContract);
  });
}
