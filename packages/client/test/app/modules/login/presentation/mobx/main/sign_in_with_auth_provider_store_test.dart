import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/modules/login/login.dart';
import 'package:dartz/dartz.dart';
import '../../../fixtures/authentication_stack_mock_gen.mocks.dart';
import 'package:nokhte/app/core/constants/failure_constants.dart';

void main() {
  late MockSignInWithApple mockSignInWithApple;
  late MockSignInWithGoogle mockSignInWithGoogle;
  late SignInWithAuthProviderStore testStore;
  const Either<Failure, AuthProviderEntity> tAppleEntity = Right(
      AuthProviderEntity(
          authProvider: AuthProvider.apple, authProviderStatus: true));
  const Either<Failure, AuthProviderEntity> tGoogleEntity = Right(
      AuthProviderEntity(
          authProvider: AuthProvider.google, authProviderStatus: true));

  setUp(() {
    mockSignInWithApple = MockSignInWithApple();
    mockSignInWithGoogle = MockSignInWithGoogle();
    testStore = SignInWithAuthProviderStore(
      signInWithApple: mockSignInWithApple,
      signInWithGoogle: mockSignInWithGoogle,
    );
  });

  mockAppleReturnSuccessEntity() => when(mockSignInWithApple(const NoParams()))
      .thenAnswer((realInvocation) async => tAppleEntity);

  mockGoogleReturnSuccessEntity() =>
      when(mockSignInWithGoogle(const NoParams()))
          .thenAnswer((realInvocation) async => tGoogleEntity);

  mockAppleFailure() => when(mockSignInWithApple(const NoParams()))
      .thenAnswer((realInvocation) async => Left(FailureConstants.authFailure));

  mockGoogleFailure() => when(mockSignInWithGoogle(const NoParams()))
      .thenAnswer((realInvocation) async => Left(FailureConstants.authFailure));

  group("initial values", () {
    test("authProviderRequestStatus", () {
      expect(testStore.authProviderRequestStatus, false);
    });
  });

  group("actions", () {
    test("routeAuthProvider success apple request", () async {
      mockAppleReturnSuccessEntity();
      final res = await testStore.routeAuthProviderRequest(AuthProvider.apple);
      expect(res, tAppleEntity);
    });
    test("routeAuthProvider failure apple request", () async {
      mockAppleFailure();
      final res = await testStore.routeAuthProviderRequest(AuthProvider.apple);
      expect(res, Left(FailureConstants.authFailure));
    });
    test("routeAuthProvider success google request", () async {
      mockGoogleReturnSuccessEntity();
      final res = await testStore.routeAuthProviderRequest(AuthProvider.google);
      expect(res, tGoogleEntity);
    });
    test("routeAuthProvider failure apple request", () async {
      mockGoogleFailure();
      final res = await testStore.routeAuthProviderRequest(AuthProvider.google);
      expect(res, Left(FailureConstants.authFailure));
    });

    test("call is passed an apple failure", () async {
      mockAppleFailure();
      await testStore(AuthProvider.apple);
      expect(testStore.errorMessage, FailureConstants.genericFailureMsg);
    });

    test("call is passed an apple entity", () async {
      when(mockSignInWithApple(const NoParams())).thenAnswer(
          (realInvocation) async => const Right(AuthProviderEntity(
              authProvider: AuthProvider.apple, authProviderStatus: true)));
      await testStore(AuthProvider.apple);
      expect(testStore.authProviderRequestStatus, true);
      verify(mockSignInWithApple(const NoParams()));
    });
  });
}
