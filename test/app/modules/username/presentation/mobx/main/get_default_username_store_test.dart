// * Testing & Mocking Libs
// ignore_for_file: must_be_immutable
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:primala/app/core/interfaces/logic.dart';
import 'package:primala/app/core/mobx/store_state.dart';
import 'package:primala/app/modules/username/domain/entities/default_username_entity.dart';
import 'package:primala/app/modules/username/presentation/mobx/main/get_default_username_store.dart';
import 'package:primala/app/core/constants/failure_constants.dart';
import '../../../fixtures/username_stack_mock_gen.mocks.dart';

void main() {
  late MockMGetDefaultUsernameGetterStore mockGetterStore;
  late GetDefaultUsernameStore defaultUsernameStore;

  setUp(() {
    mockGetterStore = MockMGetDefaultUsernameGetterStore();
    defaultUsernameStore = GetDefaultUsernameStore(
      getDefaultUsernameGetterStore: mockGetterStore,
    );
  });

  test("On instantiation all values are set properly", () {
    expect(defaultUsernameStore.state, StoreState.initial);
    expect(defaultUsernameStore.errorMessage, "");
  });

  group('mapFailureToMessage', () {
    test("should map the Network Connection error accordingly", () {
      final result = defaultUsernameStore
          .mapFailureToMessage(FailureConstants.internetConnectionFailure);

      expect(result, FailureConstants.internetConnectionFailureMsg);
    });
    test("should map any other error accordingly", () {
      final result =
          defaultUsernameStore.mapFailureToMessage(FailureConstants.dbFailure);

      expect(result, FailureConstants.genericFailureMsg);
    });
  });

  group("Error State Updater", () {
    test("should update error state w/ any error that gets passed to it", () {
      // act
      defaultUsernameStore
          .stateOrErrorUpdater(Left(FailureConstants.dbFailure));
      // assert
      expect(defaultUsernameStore.errorMessage,
          FailureConstants.genericFailureMsg);
    });
  });

  group("@action createUsername", () {
    test("Success Case", () async {
      //arrange
      when(mockGetterStore()).thenAnswer((_) async =>
          const Right(DefaultUsernameEntity(defaultUsername: "tester")));
      // act
      await defaultUsernameStore(NoParams());
      //assert
      expect(defaultUsernameStore.defaultUsername, "tester");
      expect(defaultUsernameStore.errorMessage, "");
    });

    test("Failure Case", () async {
      // arrange
      when(mockGetterStore())
          .thenAnswer((_) async => Left(FailureConstants.dbFailure));
      // act
      await defaultUsernameStore(NoParams());
      //assert
      expect(defaultUsernameStore.errorMessage,
          FailureConstants.genericFailureMsg);
      expect(defaultUsernameStore.defaultUsername, "");
    });
  });
}
