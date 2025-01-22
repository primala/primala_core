import 'package:flutter/material.dart';
import 'types.dart';

typedef SwipedCallback = void Function(SwipeDirection direction);

typedef ConfirmSwipeCallback = Future<bool?> Function(SwipeDirection direction);

typedef BackgroundBuilder = Widget Function(BuildContext context,
    SwipeDirection direction, AnimationController progress);
