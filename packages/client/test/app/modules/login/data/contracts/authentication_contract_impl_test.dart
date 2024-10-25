import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nokhte/app/core/constants/failure_constants.dart';
import 'package:nokhte/app/core/error/exceptions.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/modules/login/login.dart';
import '../../fixtures/authentication_stack_mock_gen.mocks.dart';
import '../../../_module_helpers/shared_mocks_gen.mocks.dart';
import 'package:dartz/dartz.dart';

void main() {
  late LoginContractImpl authContract;
  late MockLoginRemoteSource mockRemoteSource;
  late MockNetworkInfo mockNetworkInfo;
  late AuthProviderModel tAuthProviderModel;

  setUp(() {
    mockRemoteSource = MockLoginRemoteSource();
    mockNetworkInfo = MockNetworkInfo();
    authContract = LoginContractImpl(
      remoteSource: mockRemoteSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(AuthProvider authProvider, Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        if (authProvider == AuthProvider.apple) {
          tAuthProviderModel = const AuthProviderModel(
              authProvider: AuthProvider.apple, authProviderStatus: true);
        } else {
          tAuthProviderModel = const AuthProviderModel(
              authProvider: AuthProvider.google, authProviderStatus: true);
        }
      });
      body();
    });
  }

  void runTestsOffline(AuthProvider authProvider, Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group("Method No. 1: googleSignIn", () {
    test("should check if the device is online", () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteSource.signInWithGoogle()).thenAnswer((_) async =>
          const AuthProviderModel(
              authProvider: AuthProvider.google, authProviderStatus: true));
      await authContract.googleSignIn(const NoParams());
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(AuthProvider.google, () {
      test("Should Run The Appropriate Conditional Code for being online",
          () async {
        when(mockRemoteSource.signInWithGoogle())
            .thenAnswer((_) async => tAuthProviderModel);
        final result = await authContract.googleSignIn(const NoParams());
        expect(result, Right<Failure, AuthProviderModel>(tAuthProviderModel));
        verify(mockRemoteSource.signInWithGoogle());
      });

      test("Should fail gracefully when thrown an Authentication Failure",
          () async {
        when(mockRemoteSource.signInWithGoogle())
            .thenThrow(FailureConstants.authFailure);
        final result = await authContract.googleSignIn(const NoParams());
        expect(result, Left(FailureConstants.authFailure));
      });
    });
    runTestsOffline(AuthProvider.google, () {
      test(
        "Should Run The Appropriate Conditional Code for being offline",
        () async {
          final result = await authContract.googleSignIn(const NoParams());

          expect(result, Left(FailureConstants.internetConnectionFailure));
        },
      );
    });
  });

  group("Method No. 2: appleSignIn", () {
    test("should check if the device is online", () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteSource.signInWithApple()).thenAnswer((_) async =>
          const AuthProviderModel(
              authProvider: AuthProvider.apple, authProviderStatus: true));
      await authContract.appleSignIn(const NoParams());
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(AuthProvider.apple, () {
      test("Should Run The Appropriate Conditional Code for being online",
          () async {
        when(mockRemoteSource.signInWithApple())
            .thenAnswer((_) async => tAuthProviderModel);
        final result = await authContract.appleSignIn(const NoParams());
        expect(
          result,
          Right<Failure, AuthProviderModel>(tAuthProviderModel),
        );
        verify(mockRemoteSource.signInWithApple());
      });

      test("Should fail gracefully when thrown an Authentication Failure",
          () async {
        when(mockRemoteSource.signInWithApple()).thenThrow(
          AuthenticationException(
            message: 'Authentication Error',
            exceptionCode: 'AUTHENTICATION_ERROR',
          ),
        );
        final result = await authContract.appleSignIn(const NoParams());
        expect(
          result,
          Left(FailureConstants.authFailure),
        );
      });
    });
    runTestsOffline(AuthProvider.apple, () {
      test(
        "Should Run The Appropriate Conditional Code for being offline",
        () async {
          final result = await authContract.appleSignIn(const NoParams());

          expect(result, Left(FailureConstants.internetConnectionFailure));
        },
      );
    });
  });
  // group("Method No. 3: getAuthState", () {
  //   test("Properly Calls & Returns Auth State from the Remote Source",
  //       () async {
  //     when(mockRemoteSource.getAuthState()).thenAnswer(
  //         (_) => LoginStateModel(isAuthenticated: Stream.value(true)));
  //     final result = authContract.getAuthState(NoParams());
  //     expect(result.isAuthenticated, emitsInOrder([true]));
  //   });
  // });
}
