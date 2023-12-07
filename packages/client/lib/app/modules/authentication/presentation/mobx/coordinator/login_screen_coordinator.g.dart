// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_screen_coordinator.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginScreenCoordinator on _LoginScreenCoordinatorBase, Store {
  late final _$authProviderAtom =
      Atom(name: '_LoginScreenCoordinatorBase.authProvider', context: context);

  @override
  AuthProvider get authProvider {
    _$authProviderAtom.reportRead();
    return super.authProvider;
  }

  @override
  set authProvider(AuthProvider value) {
    _$authProviderAtom.reportWrite(value, super.authProvider, () {
      super.authProvider = value;
    });
  }

  late final _$hasNotMadeTheDotAtom = Atom(
      name: '_LoginScreenCoordinatorBase.hasNotMadeTheDot', context: context);

  @override
  bool get hasNotMadeTheDot {
    _$hasNotMadeTheDotAtom.reportRead();
    return super.hasNotMadeTheDot;
  }

  @override
  set hasNotMadeTheDot(bool value) {
    _$hasNotMadeTheDotAtom.reportWrite(value, super.hasNotMadeTheDot, () {
      super.hasNotMadeTheDot = value;
    });
  }

  late final _$centerScreenCoordinatesAtom = Atom(
      name: '_LoginScreenCoordinatorBase.centerScreenCoordinates',
      context: context);

  @override
  Offset get centerScreenCoordinates {
    _$centerScreenCoordinatesAtom.reportRead();
    return super.centerScreenCoordinates;
  }

  @override
  set centerScreenCoordinates(Offset value) {
    _$centerScreenCoordinatesAtom
        .reportWrite(value, super.centerScreenCoordinates, () {
      super.centerScreenCoordinates = value;
    });
  }

  late final _$logTheUserInAsyncAction =
      AsyncAction('_LoginScreenCoordinatorBase.logTheUserIn', context: context);

  @override
  Future logTheUserIn(AuthProvider authProvider) {
    return _$logTheUserInAsyncAction
        .run(() => super.logTheUserIn(authProvider));
  }

  late final _$_LoginScreenCoordinatorBaseActionController =
      ActionController(name: '_LoginScreenCoordinatorBase', context: context);

  @override
  dynamic toggleHasMadeTheDot() {
    final _$actionInfo = _$_LoginScreenCoordinatorBaseActionController
        .startAction(name: '_LoginScreenCoordinatorBase.toggleHasMadeTheDot');
    try {
      return super.toggleHasMadeTheDot();
    } finally {
      _$_LoginScreenCoordinatorBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCenterScreenCoordinates(Offset newCoordinates) {
    final _$actionInfo =
        _$_LoginScreenCoordinatorBaseActionController.startAction(
            name: '_LoginScreenCoordinatorBase.setCenterScreenCoordinates');
    try {
      return super.setCenterScreenCoordinates(newCoordinates);
    } finally {
      _$_LoginScreenCoordinatorBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic screenConstructor() {
    final _$actionInfo = _$_LoginScreenCoordinatorBaseActionController
        .startAction(name: '_LoginScreenCoordinatorBase.screenConstructor');
    try {
      return super.screenConstructor();
    } finally {
      _$_LoginScreenCoordinatorBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
authProvider: ${authProvider},
hasNotMadeTheDot: ${hasNotMadeTheDot},
centerScreenCoordinates: ${centerScreenCoordinates}
    ''';
  }
}
