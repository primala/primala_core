// * Testing & Mocking Libs
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:primala/app/core/constants/failure_constants.dart';
import '../../constants/param/respond_param_entity.dart';
import '../../constants/return/respond/response_status_entities.dart';
import '../../fixtures/p2p_scheduling_recipient_mock_gen.mocks.dart';
import 'package:primala/app/modules/p2p_scheduling_recipient/domain/logic/respond_to_scheduling_request.dart';

void main() {
  late MockMP2PSchedulingRecipientContract mockContract;
  late RespondToSchedulingRequest logic;

  setUp(() {
    mockContract = MockMP2PSchedulingRecipientContract();
    logic = RespondToSchedulingRequest(contract: mockContract);
  });
  test("✅ should pass the Status Entity from Contract ==> Logic", () async {
    when(mockContract
            .respondToSchedulingRequest(ConstantRespondParamEntities.entity))
        .thenAnswer(
      (_) async => ConstantResponseStatusEntities.wrappedSuccessCase,
    );

    final result = await logic(ConstantRespondParamEntities.entity);

    expect(result, ConstantResponseStatusEntities.wrappedSuccessCase);
    verify(mockContract
        .respondToSchedulingRequest(ConstantRespondParamEntities.entity));
    verifyNoMoreInteractions(mockContract);
  });

  test("✅ should pass A Failure from Contract ==> Logic", () async {
    when(mockContract
            .respondToSchedulingRequest(ConstantRespondParamEntities.entity))
        .thenAnswer((_) async => Left(FailureConstants.dbFailure));

    final result = await logic(ConstantRespondParamEntities.entity);

    expect(result, Left(FailureConstants.dbFailure));
    verify(mockContract
        .respondToSchedulingRequest(ConstantRespondParamEntities.entity));
    verifyNoMoreInteractions(mockContract);
  });
}
