// * Testing & Mocking Libs
import 'package:clock/clock.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:primala/app/core/constants/failure_constants.dart';
import 'package:primala/app/core/interfaces/logic.dart';
import 'package:primala/app/modules/p2p_request_recipient/domain/logic/load_the_requests.dart';
import '../../constants/utc_dates.dart';
import '../../fixtures/p2p_request_recipient_stack_mock_gen.mocks.dart';
import '../../constants/entities.dart';

void main() {
  late MockMP2PRequestRecipientContract mockContract;
  late LoadTheRequests loadRequestsLogic;
  late Clock fakeDate;

  setUp(() {
    fakeDate = Clock.fixed(DateTime.parse(UTCDates.startingTime));
    mockContract = MockMP2PRequestRecipientContract();
    loadRequestsLogic =
        LoadTheRequests(contract: mockContract, presentMoment: fakeDate.now());
  });

  group("call", () {
    test("✅ displays proper times for all conditions and formats them properly",
        () async {
      when(mockContract.loadTheRequests()).thenAnswer((_) async => Right(
            ConstantEntities.successfulP2PRecipientRequestEntity,
          ));
      final res = await loadRequestsLogic(NoParams());
      expect(res,
          Right(ConstantEntities.formattedSuccessfulP2PRecipientRequestEntity));
    });

    test("❌ Routes An Error Accordingly", () async {
      when(mockContract.loadTheRequests()).thenAnswer((_) async => Left(
            FailureConstants.dbFailure,
          ));
      final res = await loadRequestsLogic(NoParams());
      // print(res);

      // expect('hi', 'hi');
      expect(res, Left(FailureConstants.dbFailure));
    });
  });
}
