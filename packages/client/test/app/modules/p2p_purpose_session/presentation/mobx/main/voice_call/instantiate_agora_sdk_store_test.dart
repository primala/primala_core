// * Testing & Mocking Libs
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:primala/app/core/constants/failure_constants.dart';
import 'package:primala/app/core/interfaces/logic.dart';
import 'package:primala/app/modules/p2p_purpose_session/presentation/mobx/mobx.dart';

import '../../../../constants/entities/entities.dart';
import '../../../../fixtures/p2p_purpose_session_stack_mock_gen.mocks.dart';

void main() {
  late MockMInstantiateAgoraSdkGetterStore mockGetterStore;
  late InstantiateAgoraSdkStore instantiateAgoraSdkStore;
  final tParams = NoParams();

  setUp(() {
    mockGetterStore = MockMInstantiateAgoraSdkGetterStore();
    instantiateAgoraSdkStore = InstantiateAgoraSdkStore(
      getterStore: mockGetterStore,
    );
  });

  group("stateOrErrorUpdater", () {
    test("✅ Success Case: should update accordingly if state is passed", () {
      instantiateAgoraSdkStore.stateOrErrorUpdater(
        ConstantAgoraSdkStatusEntity.wrappedSuccessCase,
      );
      expect(
        instantiateAgoraSdkStore.isInstantiated,
        true,
      );
    });
    test("❌ Success Case: should update accordingly if failure is passed", () {
      instantiateAgoraSdkStore.stateOrErrorUpdater(
        Left(FailureConstants.dbFailure),
      );
      expect(instantiateAgoraSdkStore.isInstantiated, false);
      expect(instantiateAgoraSdkStore.errorMessage,
          FailureConstants.genericFailureMsg);
    });
  });
  group("call", () {
    test("✅ Success Case: should update accordingly if state is passed",
        () async {
      when(mockGetterStore()).thenAnswer(
        (_) async => ConstantAgoraSdkStatusEntity.wrappedNotSuccessCase,
      );
      await instantiateAgoraSdkStore(tParams);
      expect(
        instantiateAgoraSdkStore.isInstantiated,
        false,
      );
      expect(instantiateAgoraSdkStore.errorMessage, "");
    });
    test("❌ Success Case: should update accordingly if failure is passed",
        () async {
      when(mockGetterStore()).thenAnswer(
        (_) async => Left(FailureConstants.dbFailure),
      );
      await instantiateAgoraSdkStore(tParams);
      expect(instantiateAgoraSdkStore.isInstantiated, false);
      expect(instantiateAgoraSdkStore.errorMessage,
          FailureConstants.genericFailureMsg);
    });
  });
}
