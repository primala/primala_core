// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conveyer_belt_text_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConveyerBeltTextStore on _ConveyerBeltTextStoreBase, Store {
  Computed<int>? _$leftMostIndexComputed;

  @override
  int get leftMostIndex =>
      (_$leftMostIndexComputed ??= Computed<int>(() => super.leftMostIndex,
              name: '_ConveyerBeltTextStoreBase.leftMostIndex'))
          .value;
  Computed<int>? _$leftIndexComputed;

  @override
  int get leftIndex =>
      (_$leftIndexComputed ??= Computed<int>(() => super.leftIndex,
              name: '_ConveyerBeltTextStoreBase.leftIndex'))
          .value;
  Computed<int>? _$rightIndexComputed;

  @override
  int get rightIndex =>
      (_$rightIndexComputed ??= Computed<int>(() => super.rightIndex,
              name: '_ConveyerBeltTextStoreBase.rightIndex'))
          .value;
  Computed<int>? _$rightMostIndexComputed;

  @override
  int get rightMostIndex =>
      (_$rightMostIndexComputed ??= Computed<int>(() => super.rightMostIndex,
              name: '_ConveyerBeltTextStoreBase.rightMostIndex'))
          .value;
  Computed<int>? _$focusListCardinalLengthComputed;

  @override
  int get focusListCardinalLength => (_$focusListCardinalLengthComputed ??=
          Computed<int>(() => super.focusListCardinalLength,
              name: '_ConveyerBeltTextStoreBase.focusListCardinalLength'))
      .value;
  Computed<List<GeneralDateTimeReturnType>>? _$theFocusedListComputed;

  @override
  List<GeneralDateTimeReturnType> get theFocusedList =>
      (_$theFocusedListComputed ??= Computed<List<GeneralDateTimeReturnType>>(
              () => super.theFocusedList,
              name: '_ConveyerBeltTextStoreBase.theFocusedList'))
          .value;

  late final _$movieAtom =
      Atom(name: '_ConveyerBeltTextStoreBase.movie', context: context);

  @override
  MovieTween get movie {
    _$movieAtom.reportRead();
    return super.movie;
  }

  @override
  set movie(MovieTween value) {
    _$movieAtom.reportWrite(value, super.movie, () {
      super.movie = value;
    });
  }

  late final _$controlAtom =
      Atom(name: '_ConveyerBeltTextStoreBase.control', context: context);

  @override
  Control get control {
    _$controlAtom.reportRead();
    return super.control;
  }

  @override
  set control(Control value) {
    _$controlAtom.reportWrite(value, super.control, () {
      super.control = value;
    });
  }

  late final _$uiArrayAtom =
      Atom(name: '_ConveyerBeltTextStoreBase.uiArray', context: context);

  @override
  List<String> get uiArray {
    _$uiArrayAtom.reportRead();
    return super.uiArray;
  }

  @override
  set uiArray(List<String> value) {
    _$uiArrayAtom.reportWrite(value, super.uiArray, () {
      super.uiArray = value;
    });
  }

  late final _$returnEntityAtom =
      Atom(name: '_ConveyerBeltTextStoreBase.returnEntity', context: context);

  @override
  ReturnDateOrTimeEntity get returnEntity {
    _$returnEntityAtom.reportRead();
    return super.returnEntity;
  }

  @override
  set returnEntity(ReturnDateOrTimeEntity value) {
    _$returnEntityAtom.reportWrite(value, super.returnEntity, () {
      super.returnEntity = value;
    });
  }

  late final _$currentlySelectedIndexAtom = Atom(
      name: '_ConveyerBeltTextStoreBase.currentlySelectedIndex',
      context: context);

  @override
  int get currentlySelectedIndex {
    _$currentlySelectedIndexAtom.reportRead();
    return super.currentlySelectedIndex;
  }

  @override
  set currentlySelectedIndex(int value) {
    _$currentlySelectedIndexAtom
        .reportWrite(value, super.currentlySelectedIndex, () {
      super.currentlySelectedIndex = value;
    });
  }

  late final _$_ConveyerBeltTextStoreBaseActionController =
      ActionController(name: '_ConveyerBeltTextStoreBase', context: context);

  @override
  dynamic toggleListFocus() {
    final _$actionInfo = _$_ConveyerBeltTextStoreBaseActionController
        .startAction(name: '_ConveyerBeltTextStoreBase.toggleListFocus');
    try {
      return super.toggleListFocus();
    } finally {
      _$_ConveyerBeltTextStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDatesArray() {
    final _$actionInfo = _$_ConveyerBeltTextStoreBaseActionController
        .startAction(name: '_ConveyerBeltTextStoreBase.setDatesArray');
    try {
      return super.setDatesArray();
    } finally {
      _$_ConveyerBeltTextStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setTimesArray() {
    final _$actionInfo = _$_ConveyerBeltTextStoreBaseActionController
        .startAction(name: '_ConveyerBeltTextStoreBase.setTimesArray');
    try {
      return super.setTimesArray();
    } finally {
      _$_ConveyerBeltTextStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUIArray(List<GeneralDateTimeReturnType> inputArr) {
    final _$actionInfo = _$_ConveyerBeltTextStoreBaseActionController
        .startAction(name: '_ConveyerBeltTextStoreBase.setUIArray');
    try {
      return super.setUIArray(inputArr);
    } finally {
      _$_ConveyerBeltTextStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCurrentlySelectedIndex(int index) {
    final _$actionInfo =
        _$_ConveyerBeltTextStoreBaseActionController.startAction(
            name: '_ConveyerBeltTextStoreBase.setCurrentlySelectedIndex');
    try {
      return super.setCurrentlySelectedIndex(index);
    } finally {
      _$_ConveyerBeltTextStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
movie: ${movie},
control: ${control},
uiArray: ${uiArray},
returnEntity: ${returnEntity},
currentlySelectedIndex: ${currentlySelectedIndex},
leftMostIndex: ${leftMostIndex},
leftIndex: ${leftIndex},
rightIndex: ${rightIndex},
rightMostIndex: ${rightMostIndex},
focusListCardinalLength: ${focusListCardinalLength},
theFocusedList: ${theFocusedList}
    ''';
  }
}
