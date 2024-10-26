// ignore_for_file: library_private_types_in_public_api, must_be_immutable, type_literal_in_constant_pattern
import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/modules/login/login.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
part 'sign_in_with_auth_provider_store.g.dart';

class SignInWithAuthProviderStore = _SignInWithAuthProviderStoreBase
    with _$SignInWithAuthProviderStore;

abstract class _SignInWithAuthProviderStoreBase
    with Store, BaseMobxLogic<AuthProvider, AuthProviderEntity> {
  final SignInWithApple signInWithApple;
  final SignInWithGoogle signInWithGoogle;

  _SignInWithAuthProviderStoreBase({
    required this.signInWithApple,
    required this.signInWithGoogle,
  }) {
    initBaseLogicActions();
  }

  @observable
  bool authProviderRequestStatus = false;

  @action
  Future<Either<Failure, AuthProviderEntity>> routeAuthProviderRequest(
      AuthProvider authProvider) async {
    switch (authProvider) {
      case AuthProvider.apple:
        return await signInWithApple(const NoParams());
      case AuthProvider.google:
        return await signInWithGoogle(const NoParams());
    }
  }

  @override
  @action
  Future<void> call(AuthProvider authProvider) async {
    setState(StoreState.loading);
    Either<Failure, AuthProviderEntity> res =
        await routeAuthProviderRequest(authProvider);
    res.fold((failure) {
      setErrorMessage(mapFailureToMessage(failure));
      setState(StoreState.initial);
    }, (authProviderEntity) {
      authProviderRequestStatus = authProviderEntity.authProviderStatus;
      setState(StoreState.loaded);
    });
  }
}
