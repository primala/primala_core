// * Testing & Mocking Libs
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:primala/app/core/constants/failure_constants.dart';
import 'package:primala/app/modules/p2p_scheduling_sender/domain/entities/send_scheduling_request_param_entity.dart';
import '../../constants/param/send_param_entities.dart';
import '../../constants/return/send/send_scheduling_request_status_entities.dart';
import '../../constants/sample_data.dart';
import '../../fixtures/p2p_scheduling_sender_mock_gen.mocks.dart';
import 'package:primala/app/modules/p2p_scheduling_sender/domain/logic/send_scheduling_request.dart';

void main() {
  late MockMP2PSchedulingSenderContract mockContract;
  late SendSchedulingRequest logic;

  setUp(() {
    mockContract = MockMP2PSchedulingSenderContract();
    logic = SendSchedulingRequest(contract: mockContract);
  });

  test("✅ should pass the Status Entity from Contract ==> Logic", () async {
    when(mockContract.sendSchedulingRequest(
            schedulingInfoEntity:
                ConstantSendParamEntities.sendScheduleParamEntity))
        .thenAnswer((_) async =>
            ConstantSendSchedulingRequestStatusEntities.wrappedSuccessCase);

    final result =
        await logic(ConstantSendParamEntities.sendScheduleParamEntity);

    expect(
        result, ConstantSendSchedulingRequestStatusEntities.wrappedSuccessCase);
    verify(mockContract.sendSchedulingRequest(
      schedulingInfoEntity: ConstantSendParamEntities.sendScheduleParamEntity,
    ));
    verifyNoMoreInteractions(mockContract);
  });

  test("✅ should pass A Failure from Contract ==> Logic", () async {
    when(mockContract.sendSchedulingRequest(
            schedulingInfoEntity:
                ConstantSendParamEntities.sendScheduleParamEntity))
        .thenAnswer((_) async => Left(FailureConstants.dbFailure));
    final result =
        await logic(ConstantSendParamEntities.sendScheduleParamEntity);
    expect(result, Left(FailureConstants.dbFailure));
    verify(mockContract.sendSchedulingRequest(
      schedulingInfoEntity: ConstantSendParamEntities.sendScheduleParamEntity,
    ));
    verifyNoMoreInteractions(mockContract);
  });

  test("toJSON returns a valid Back-end Compliant JSON Object", () async {
    final expectedJSON = SendSchedulingRequestParamEntity(
      timeRangeList:
          ConstantSendParamEntities.sendScheduleParamEntity.timeRangeList,
      receiverUID:
          ConstantSendParamEntities.sendScheduleParamEntity.receiverUID,
    ).timeRangesToJson();

    expect(expectedJSON, SampleData.jsonTimeRanges);
  });
}
