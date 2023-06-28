// * Testing & Mocking Libs
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:primala/app/core/constants/failure_constants.dart';
// * Contract Impl
import 'package:primala/app/modules/p2p_scheduling_recipient/data/contracts/p2p_scheduling_recipient_contract_impl.dart';
// * Entities
import '../../../_module_helpers/shared_mocks_gen.mocks.dart'
    show MockMNetworkInfo;
// * Mocks
import '../../constants/param/respond_param_entity.dart';
import '../../constants/return/respond/response_status_models.dart';
import '../../constants/sample_data.dart';
import '../../../p2p_scheduling_sender/constants/sample_data.dart' as sd;
import '../../fixtures/p2p_scheduling_recipient_mock_gen.mocks.dart';

void main() {
  late P2PSchedulingRecipientContractImpl schedulingContract;
  late MockMP2PSchedulingRecipientRemoteSourceImpl mockRemoteSource;
  late MockMNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteSource = MockMP2PSchedulingRecipientRemoteSourceImpl();
    mockNetworkInfo = MockMNetworkInfo();
    schedulingContract = P2PSchedulingRecipientContractImpl(
      networkInfo: mockNetworkInfo,
      remoteSource: mockRemoteSource,
    );
  });

  group("device is online", () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    group("respondToSchedulingRequest", () {
      test("✅ Successfully returns right entity w/ successful request",
          () async {
        // arrange
        when(
          mockRemoteSource.respondToSchedulingRequest(
              sd.SampleData.randomUID, sd.SampleData.june19th10AMtimestampz),
        ).thenAnswer((_) async => [SampleData.successRespondRes]);
        // act
        final res = await schedulingContract
            .respondToSchedulingRequest(ConstantRespondParamEntities.entity);
        // assert
        expect(res, ConstantResponseStatusModels.wrappedSuccessCase);
      });
      test("✅ Successfully returns right entity w/ unsuccessful request",
          () async {
        // arrange
        when(
          mockRemoteSource.respondToSchedulingRequest(
              sd.SampleData.randomUID, sd.SampleData.june19th10AMtimestampz),
        ).thenAnswer((_) async => []);
        // act
        final res = await schedulingContract
            .respondToSchedulingRequest(ConstantRespondParamEntities.entity);
        // assert
        // assert
        expect(res, ConstantResponseStatusModels.wrappedNotSuccessCase);
      });
    });
  });
  group("device is offline", () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });
    test(
        '❌ respondToSchedulingRequest should send the internet connection failure',
        () async {
      final res = await schedulingContract
          .respondToSchedulingRequest(ConstantRespondParamEntities.entity);
      expect(res, Left(FailureConstants.internetConnectionFailure));
    });
  });
}
