// * Testing & Mocking Libs
// ignore_for_file: must_be_immutable
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:primala/app/core/interfaces/logic.dart';
import 'package:primala/app/core/mobx/store_state.dart';
import 'package:primala/app/modules/username/domain/entities/username_status_entity.dart';
import 'package:primala/app/modules/username/presentation/mobx/main/check_if_username_is_created_store.dart';
// * Failure Constants
import 'package:primala/app/core/constants/failure_constants.dart';
// * Mocks
import '../../../fixtures/username_stack_mock_gen.mocks.dart';

void main() {
  late MockMCheckIfUsernameIsCreatedGetterStore mockGetterStore;
  late CheckIfUsernameIsCreatedStore checkUsernameStore;

  setUp(() {
    mockGetterStore = MockMCheckIfUsernameIsCreatedGetterStore();
    checkUsernameStore = CheckIfUsernameIsCreatedStore(
        checkUsernameGetterStore: mockGetterStore);
  });

  test("On instantiation all values are set properly", () {
    expect(checkUsernameStore.state, StoreState.initial);
    expect(checkUsernameStore.errorMessage, "");
  });

  group("stateOrErrorUpdater", () {
    test("should update error state w/ any error that gets passed to it", () {
      // act
      checkUsernameStore.stateOrErrorUpdater(Left(FailureConstants.dbFailure));
      // assert
      expect(
          checkUsernameStore.errorMessage, FailureConstants.genericFailureMsg);
    });
  });

  group("@action createUsername", () {
    test("Success Case", () async {
      //arrange
      when(mockGetterStore()).thenAnswer(
          (_) async => const Right(UsernameStatusEntity(isCreated: true)));
      // act
      await checkUsernameStore(NoParams());
      //assert
      expect(checkUsernameStore.usernameIsCreated, true);
      expect(checkUsernameStore.errorMessage, "");
    });

    test("Failure Case", () async {
      // arrange
      when(mockGetterStore())
          .thenAnswer((_) async => Left(FailureConstants.dbFailure));
      // act
      await checkUsernameStore(NoParams());
      //assert
      expect(
          checkUsernameStore.errorMessage, FailureConstants.genericFailureMsg);
      expect(checkUsernameStore.usernameIsCreated, false);
    });
  });
}
