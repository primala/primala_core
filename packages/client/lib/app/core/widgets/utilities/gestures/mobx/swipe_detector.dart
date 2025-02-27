// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:equatable/equatable.dart';
import 'package:nokhte/app/core/types/types.dart';
part 'swipe_detector.g.dart';

class SwipeDetector = _SwipeDetector with _$SwipeDetector;

abstract class _SwipeDetector extends Equatable with Store {
  @observable
  ObservableList<Offset> mostRecentCoordinates = ObservableList.of([]);

  @observable
  DragType dragType = DragType.initial;

  @observable
  GestureDirections directionsType = GestureDirections.initial;

  @observable
  bool resetTheDirectionType = false;

  @action
  setDirectionsType(GestureDirections newDirectionsType) =>
      directionsType = newDirectionsType;

  @observable
  HoldState holdState = HoldState.initial;

  @action
  setDragType(DragType newDragType) => dragType = newDragType;

  @action
  onUpdateCallback(
    Offset mostRecentOffset,
    DragType newDragType,
  ) {
    mostRecentCoordinates.add(mostRecentOffset);
    if (dragType != newDragType) {
      dragType = newDragType;
      resetTheDirectionType = true;
    }
    directionDetection();
  }

  @action
  directionDetection() {
    holdState = HoldState.holding;
    if (dragType == DragType.horizontal) {
      final firstVal = mostRecentCoordinates.first.dx;
      final lastVal = mostRecentCoordinates.last.dx;
      final directionsComparison =
          firstVal < lastVal ? GestureDirections.right : GestureDirections.left;
      if (resetTheDirectionType) {
        setDirectionsType(GestureDirections.initial);
        resetTheDirectionType = false;
      } else {
        setDirectionsType(directionsComparison);
      }
    } else if (dragType == DragType.vertical) {
      final firstVal = mostRecentCoordinates.first.dy;
      final lastVal = mostRecentCoordinates.last.dy;
      late GestureDirections directionsComparison;
      if ((firstVal - lastVal).abs() > minSwipeDistance) {
        directionsComparison =
            firstVal < lastVal ? GestureDirections.down : GestureDirections.up;
        if (resetTheDirectionType) {
          setDirectionsType(GestureDirections.initial);
          resetTheDirectionType = false;
        } else {
          setDirectionsType(directionsComparison);
        }
      }
    }
  }

  @observable
  double minSwipeDistance = 0;

  @action
  setMinDistance(double val) => minSwipeDistance = val;

  @observable
  bool hasAlreadyMadeGesture = false;

  @action
  toggleHasAlreadyMadeGesture() =>
      hasAlreadyMadeGesture = !hasAlreadyMadeGesture;

  @action
  onFinishedGestureCallback() {
    hasAlreadyMadeGesture = false;
    dragType = DragType.initial;
    holdState = HoldState.initial;
    mostRecentCoordinates.clear();
  }

  @override
  List<Object> get props => [];
}
