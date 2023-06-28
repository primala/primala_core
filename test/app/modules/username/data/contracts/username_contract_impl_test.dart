// * Testing & Mocking Libs
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:primala/app/core/constants/failure_constants.dart';
import 'package:primala/app/core/error/failure.dart';
// * Contract Impl
import 'package:primala/app/modules/username/data/contracts/username_contract_impl.dart';
import 'package:primala/app/modules/username/domain/entities/username_status_entity.dart';
// * Mocks
import '../../../_module_helpers/shared_mocks_gen.mocks.dart'
    show MockMNetworkInfo;
import '../../fixtures/username_stack_mock_gen.mocks.dart';
import '../constants/username_data_constants.dart';
import '../constants/username_model_constants.dart';

void main() {
  late UsernameContractImpl usernameContract;
  late MockMRemoteSource mockRemoteSource;
  late MockMNetworkInfo mockNetworkInfo;
  final tSuccessUsernameStatusModel =
      UsernameModelConstants.successUsernameStatusModel;
  final tNotSuccessUsernameStatusModel =
      UsernameModelConstants.notSuccessUsernameStatusModel;
  final tDefaultUsernameModel = UsernameModelConstants.defaultUsernameModel;
  final tNetworkConnectionFailure = Left<Failure, UsernameStatusEntity>(
      FailureConstants.internetConnectionFailure);

  setUp(() {
    mockRemoteSource = MockMRemoteSource();
    mockNetworkInfo = MockMNetworkInfo();
    usernameContract = UsernameContractImpl(
      remoteSource: mockRemoteSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });
    group('`createUsername`', () {
      test("✅ Success: when passed a non-empty object returns proper model",
          () async {
        // arrange
        when(mockRemoteSource.createUsername(UsernameDataConstants.username))
            .thenAnswer(
                (_) async => UsernameDataConstants.usernameQueryResponse);
        // act
        final res = await usernameContract
            .createUsername(UsernameDataConstants.username);

        expect(res, tSuccessUsernameStatusModel);
      });
      test("✅ Success: when passed a empty object returns proper model",
          () async {
        // arrange
        when(mockRemoteSource.createUsername(UsernameDataConstants.username))
            .thenAnswer((_) async => []);
        // act
        final res = await usernameContract
            .createUsername(UsernameDataConstants.username);

        expect(res, tNotSuccessUsernameStatusModel);
      });
    });

    group("`getDefaultUsername`", () {
      test("✅ When passed any email should serve proper model", () async {
        // arrange
        when(mockRemoteSource.getDefaultUsername()).thenAnswer(
            (realInvocation) async => UsernameDataConstants.userEmail);
        // act
        final res = await usernameContract.getDefaultUsername();
        // assert
        expect(res, tDefaultUsernameModel);
      });
    });

    group("`checkIfUsernameIsCreated`", () {
      test("✅ When user has a username it returns the proper model", () async {
        // arrange
        when(mockRemoteSource.checkIfUsernameIsCreated()).thenAnswer(
            (_) async => UsernameDataConstants.usernameQueryResponse);
        // act
        final res = await usernameContract.checkIfUsernameIsCreated();
        //assert
        expect(res, tSuccessUsernameStatusModel);
      });

      test("✅ When user doesn't have a username it returns the proper model",
          () async {
        when(mockRemoteSource.checkIfUsernameIsCreated())
            .thenAnswer((_) async => []);
        // act
        final res = await usernameContract.checkIfUsernameIsCreated();
        //assert
        expect(res, tNotSuccessUsernameStatusModel);
      });
    });
  });
  group('device is offline', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });
    test("❌ createUsername should send an internet connection error", () async {
      final res =
          await usernameContract.createUsername(UsernameDataConstants.username);

      expect(res, tNetworkConnectionFailure);
    });
    test("❌ checkIfUsernameIsCreated should send an internet connection error",
        () async {
      final res = await usernameContract.checkIfUsernameIsCreated();

      expect(res, tNetworkConnectionFailure);
    });
  });
}
