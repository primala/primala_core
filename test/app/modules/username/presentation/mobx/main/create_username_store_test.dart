// * Testing & Mocking Libs
// ignore_for_file: must_be_immutable

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:primala/app/core/mobx/store_state.dart';
import 'package:primala/app/modules/username/domain/entities/username_status_entity.dart';
import 'package:primala/app/modules/username/domain/logic/create_username.dart';
import 'package:primala/app/modules/username/presentation/mobx/main/create_username_store.dart';
// * Failure constants
import 'package:primala/app/core/constants/failure_constants.dart';
// * Mocks
import '../../../fixtures/username_stack_mock_gen.mocks.dart';

void main() {
  late MockMCreateUsernameGetterStore mockGetterStore;
  late CreateUsernameStore createUsernameStore;

  setUp(() {
    mockGetterStore = MockMCreateUsernameGetterStore();
    createUsernameStore =
        CreateUsernameStore(createUsernameGetterStore: mockGetterStore);
  });

  test("On instantiation all values are set properly", () {
    expect(createUsernameStore.state, StoreState.initial);
    expect(createUsernameStore.errorMessage, "");
  });

  group('mapFailureToMessage', () {
    test("should map the Network Connection error accordingly", () {
      final result = createUsernameStore
          .mapFailureToMessage(FailureConstants.internetConnectionFailure);

      expect(result, FailureConstants.internetConnectionFailureMsg);
    });
    test("should map any other error accordingly", () {
      final result =
          createUsernameStore.mapFailureToMessage(FailureConstants.dbFailure);

      expect(result, FailureConstants.genericFailureMsg);
    });
  });

  group("Error State Updater", () {
    test("should update error state w/ any error that gets passed to it", () {
      // act
      createUsernameStore.stateOrErrorUpdater(Left(FailureConstants.dbFailure));
      // assert
      expect(
          createUsernameStore.errorMessage, FailureConstants.genericFailureMsg);
    });
  });

  group("@action createUsername", () {
    test("Success Case", () async {
      //arrange
      when(mockGetterStore("tester")).thenAnswer(
          (_) async => const Right(UsernameStatusEntity(isCreated: true)));
      // act
      await createUsernameStore(const CreateUserParams(username: 'tester'));
      //assert
      expect(createUsernameStore.usernameIsCreated, true);
      expect(createUsernameStore.errorMessage, "");
    });

    test("Failure Case", () async {
      // arrange
      when(mockGetterStore("tester"))
          .thenAnswer((_) async => Left(FailureConstants.dbFailure));
      // act
      await createUsernameStore(const CreateUserParams(username: 'tester'));
      //assert
      expect(
          createUsernameStore.errorMessage, FailureConstants.genericFailureMsg);
      expect(createUsernameStore.usernameIsCreated, false);
    });
  });
}
