import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/modules/login/login.dart';
import '../../../fixtures/authentication_stack_mock_gen.mocks.dart';

void main() {
  group("initial values", () {
    test("authState", () {
      final mockGetAuthState = MockGetLoginState();
      when(mockGetAuthState(const NoParams()))
          .thenAnswer((_) => Stream.value(true));
      final authStateStore = GetLoginStateStore(logic: mockGetAuthState);
      expect(authStateStore.authState, emitsInOrder([true]));
    });
  });
}
