// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gesture_cross_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$GestureCrossStore on _GestureCrossStoreBase, Store {
  late final _$showWidgetAtom =
      Atom(name: '_GestureCrossStoreBase.showWidget', context: context);

  @override
  bool get showWidget {
    _$showWidgetAtom.reportRead();
    return super.showWidget;
  }

  @override
  set showWidget(bool value) {
    _$showWidgetAtom.reportWrite(value, super.showWidget, () {
      super.showWidget = value;
    });
  }

  late final _$_GestureCrossStoreBaseActionController =
      ActionController(name: '_GestureCrossStoreBase', context: context);

  @override
  dynamic startTheAnimation() {
    final _$actionInfo = _$_GestureCrossStoreBaseActionController.startAction(
        name: '_GestureCrossStoreBase.startTheAnimation');
    try {
      return super.startTheAnimation();
    } finally {
      _$_GestureCrossStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic animationRenderingCallback(int i, Offset z) {
    final _$actionInfo = _$_GestureCrossStoreBaseActionController.startAction(
        name: '_GestureCrossStoreBase.animationRenderingCallback');
    try {
      return super.animationRenderingCallback(i, z);
    } finally {
      _$_GestureCrossStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
showWidget: ${showWidget}
    ''';
  }
}
