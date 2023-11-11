import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nokhte/app/core/constants/failure_constants.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/modules/home/domain/entities/name_creation_status_entity.dart';
import 'package:nokhte/app/modules/home/presentation/mobx/getter/add_name_to_database_getter_store.dart';

import '../../../constants/entities/entities.dart';
import '../../../fixtures/home_stack_mock_gen.mocks.dart';

void main() {
  late MockMAddNameToDatabase mockLogic;
  late AddNameToDatabaseGetterStore getterStore;
  late Either<Failure, NameCreationStatusEntity> tEitherStatusOrFailure;

  setUp(() {
    mockLogic = MockMAddNameToDatabase();
    getterStore = AddNameToDatabaseGetterStore(
      addNameLogic: mockLogic,
    );
  });

  group("✅ Success Cases", () {
    setUp(() {
      tEitherStatusOrFailure =
          ConstantNameCreationStatusEntities.wrappedSuccessCase;
    });

    test("should pass the right entity w/ the right state", () async {
      when(mockLogic(NoParams()))
          .thenAnswer((realInvocation) async => tEitherStatusOrFailure);
      final res = await getterStore();
      expect(res, tEitherStatusOrFailure);
    });
  });

  group("❌ Failure Cases", () {
    setUp(() {
      tEitherStatusOrFailure = Left(FailureConstants.dbFailure);
    });

    test("should pass the right entity w/ the right state", () async {
      when(mockLogic(NoParams()))
          .thenAnswer((realInvocation) async => tEitherStatusOrFailure);
      final res = await getterStore();
      expect(res, tEitherStatusOrFailure);
    });
  });
}
