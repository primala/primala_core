// * Testing & Mocking Libs
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
// * Core
import 'package:primala/app/core/error/failure.dart';
import 'package:primala/app/core/mobx/store_state.dart';
// * Entities
import 'package:primala/app/modules/username/domain/entities/username_status_entity.dart';
// * Logic
import 'package:primala/app/modules/username/domain/logic/create_username.dart';
// * Mobx Stores
import 'package:primala/app/modules/username/presentation/mobx/getters/create_username_getter_store.dart';
// * local mocks
import '../../../fixtures/username_stack_mock_gen.mocks.dart';
// * Failure Constants
import 'package:primala/app/core/constants/failure_constants.dart';

void main() {
  // declare vars
  late MockMCreateUsername mockCreateUsername;
  late CreateUsernameGetterStore createUsernameGetterStore;
  late Either<Failure, UsernameStatusEntity> tEitherUsernameStatusOrFailure;

  setUp(() {
    mockCreateUsername = MockMCreateUsername();
    createUsernameGetterStore =
        CreateUsernameGetterStore(createLogic: mockCreateUsername);
  });

  test("should set StoreState to Initial", () {
    expect(createUsernameGetterStore.state, StoreState.initial);
  });

  group("✅ SUCCESS Cases", () {
    setUp(() {
      tEitherUsernameStatusOrFailure =
          const Right(UsernameStatusEntity(isCreated: true));
    });
    test("should pass the right entity w/ the right state", () async {
      //arrange
      when(mockCreateUsername(const CreateUserParams(username: "tester")))
          .thenAnswer((realInvocation) async => tEitherUsernameStatusOrFailure);
      //act
      final res = await createUsernameGetterStore('tester');
      //assert
      expect(res, tEitherUsernameStatusOrFailure);
    });
  });
  group("❌ FAILURE Cases", () {
    setUp(() {
      tEitherUsernameStatusOrFailure = Left(FailureConstants.dbFailure);
    });
    test("should pass the right entity w/ the right state", () async {
      //arrange
      when(mockCreateUsername(const CreateUserParams(username: "tester")))
          .thenAnswer((realInvocation) async => tEitherUsernameStatusOrFailure);
      //act
      final res = await createUsernameGetterStore('tester');
      //assert
      expect(res, tEitherUsernameStatusOrFailure);
    });
  });
}
