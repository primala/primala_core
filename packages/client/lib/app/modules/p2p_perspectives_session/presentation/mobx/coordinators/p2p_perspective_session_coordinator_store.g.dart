// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'p2p_perspective_session_coordinator_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$P2PPerspectiveSessionCoordinatorStore
    on _P2PPerspectiveSessionCoordinatorStoreBase, Store {
  late final _$previousWordAtom = Atom(
      name: '_P2PPerspectiveSessionCoordinatorStoreBase.previousWord',
      context: context);

  @override
  String get previousWord {
    _$previousWordAtom.reportRead();
    return super.previousWord;
  }

  @override
  set previousWord(String value) {
    _$previousWordAtom.reportWrite(value, super.previousWord, () {
      super.previousWord = value;
    });
  }

  late final _$screenConstructorAsyncAction = AsyncAction(
      '_P2PPerspectiveSessionCoordinatorStoreBase.screenConstructor',
      context: context);

  @override
  Future screenConstructor() {
    return _$screenConstructorAsyncAction.run(() => super.screenConstructor());
  }

  late final _$_P2PPerspectiveSessionCoordinatorStoreBaseActionController =
      ActionController(
          name: '_P2PPerspectiveSessionCoordinatorStoreBase', context: context);

  @override
  dynamic onSwipeUp() {
    final _$actionInfo =
        _$_P2PPerspectiveSessionCoordinatorStoreBaseActionController
            .startAction(
                name: '_P2PPerspectiveSessionCoordinatorStoreBase.onSwipeUp');
    try {
      return super.onSwipeUp();
    } finally {
      _$_P2PPerspectiveSessionCoordinatorStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
previousWord: ${previousWord}
    ''';
  }
}
