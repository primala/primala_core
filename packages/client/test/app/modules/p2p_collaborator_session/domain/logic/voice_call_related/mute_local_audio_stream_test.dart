// * Testing & Mocking Libs
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:primala/app/core/constants/failure_constants.dart';
import 'package:primala/app/core/interfaces/logic.dart';
import 'package:primala/app/modules/p2p_purpose_session/domain/logic/logic.dart';
import '../../../constants/entities/entities.dart';
import '../../../fixtures/p2p_purpose_session_stack_mock_gen.mocks.dart';

void main() {
  late MockMP2PPurposeSessionVoiceCallContract mockContract;
  late MuteLocalAudioStream logic;

  setUp(() {
    mockContract = MockMP2PPurposeSessionVoiceCallContract();
    logic = MuteLocalAudioStream(contract: mockContract);
  });

  test("✅ should pass the Status Entity from Contract ==> Logic", () async {
    when(mockContract.muteLocalAudioStream()).thenAnswer(
      (_) async => ConstantLocalAudioStreamStatusEntity.wrappedMutedCase,
    );

    final result = await logic(NoParams());

    expect(result, ConstantLocalAudioStreamStatusEntity.wrappedMutedCase);
    verify(mockContract.muteLocalAudioStream());
    verifyNoMoreInteractions(mockContract);
  });

  test("✅ should pass A Failure from Contract ==> Logic", () async {
    when(mockContract.muteLocalAudioStream()).thenAnswer(
      (_) async => Left(FailureConstants.dbFailure),
    );

    final result = await logic(NoParams());

    expect(result, Left(FailureConstants.dbFailure));
    verify(mockContract.muteLocalAudioStream());
    verifyNoMoreInteractions(mockContract);
  });
}
