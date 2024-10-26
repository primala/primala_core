// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:ui';

import 'package:mobx/mobx.dart';
import 'package:equatable/equatable.dart';
import 'package:nokhte/app/core/extensions/extensions.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
part 'tap_detector.g.dart';

class TapDetector = _TapDetector with _$TapDetector;

abstract class _TapDetector extends Equatable with Store {
  @observable
  double screenHeight = -1;

  @action
  setScreenHeight(double value) => screenHeight = value;

  @computed
  GesturePlacement get currentTapPlacement =>
      currentTapPosition.dy.isLessThan(screenHeight.half())
          ? GesturePlacement.topHalf
          : GesturePlacement.bottomHalf;

  @observable
  int tapCount = 0;

  @observable
  int doubleTapCount = 0;

  @observable
  Offset currentTapPosition = Offset.zero;

  @action
  onTapDown(Offset newOffset) => currentTapPosition = newOffset;

  @action
  onTap() => tapCount++;

  @action
  onDoubleTap() => doubleTapCount++;

  @override
  List<Object> get props => [];
}
