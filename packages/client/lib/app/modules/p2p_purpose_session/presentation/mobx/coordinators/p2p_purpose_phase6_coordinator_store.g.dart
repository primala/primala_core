// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'p2p_purpose_phase6_coordinator_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$P2PPurposePhase6CoordinatorStore
    on _P2PPurposePhase6CoordinatorStoreBase, Store {
  late final _$directionAtom = Atom(
      name: '_P2PPurposePhase6CoordinatorStoreBase.direction',
      context: context);

  @override
  double get direction {
    _$directionAtom.reportRead();
    return super.direction;
  }

  @override
  set direction(double value) {
    _$directionAtom.reportWrite(value, super.direction, () {
      super.direction = value;
    });
  }

  late final _$_P2PPurposePhase6CoordinatorStoreBaseActionController =
      ActionController(
          name: '_P2PPurposePhase6CoordinatorStoreBase', context: context);

  @override
  dynamic setDirection(double newValue) {
    final _$actionInfo =
        _$_P2PPurposePhase6CoordinatorStoreBaseActionController.startAction(
            name: '_P2PPurposePhase6CoordinatorStoreBase.setDirection');
    try {
      return super.setDirection(newValue);
    } finally {
      _$_P2PPurposePhase6CoordinatorStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
direction: ${direction}
    ''';
  }
}
