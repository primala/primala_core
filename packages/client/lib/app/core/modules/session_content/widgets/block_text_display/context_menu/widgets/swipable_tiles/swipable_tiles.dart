// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'swipable_tiles.dart';
export 'widgets/widgets.dart';
export 'types/types.dart';
export 'constants/constants.dart';

class SwipeableTile extends StatefulWidget {
  final double horizontalPadding;
  final double verticalPadding;
  final bool isCard;
  final double borderRadius;
  final Color color;

  final HitTestBehavior behavior;

  final BackgroundBuilder backgroundBuilder;

  final double swipeThreshold;

  final SwipeDirection direction;

  final Duration? resizeDuration;

  final Duration movementDuration;

  final SwipedCallback onSwiped;

  final ConfirmSwipeCallback? confirmSwipe;

  final Widget child;

  final bool swipeToTrigger;

  final bool isElevated;

  final double? swipeWidth;

  const SwipeableTile({
    required Key key,
    required this.child,
    required this.backgroundBuilder,
    required this.color,
    required this.onSwiped,
    this.swipeWidth,
    this.swipeThreshold = 0.4,
    this.confirmSwipe,
    this.borderRadius = 8.0,
    this.direction = SwipeDirection.endToStart,
    this.resizeDuration = const Duration(milliseconds: 300),
    this.movementDuration = const Duration(milliseconds: 200),
    this.behavior = HitTestBehavior.opaque,
    this.isElevated = false,
  })  : isCard = false,
        swipeToTrigger = false,
        horizontalPadding = 0,
        verticalPadding = 1,
        assert(swipeThreshold > 0.0 && swipeThreshold < 1.0),
        super(key: key);

  @override
  _SwipeableTileState createState() => _SwipeableTileState();
}

class _SwipeableTileState extends State<SwipeableTile>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin,
        SwipeableTileConstants {
  AnimationController? _moveController;
  late Animation<Offset> _moveAnimation;

  AnimationController? _resizeController;
  Animation<double>? _resizeAnimation;

  double _dragExtent = 0.0;
  bool _dragUnderway = false;
  Size? _sizePriorToCollapse;

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(
        duration: widget.movementDuration, vsync: this, upperBound: .1)
      ..addStatusListener(_handleDismissStatusChanged);

    _updateMoveAnimation();
  }

  @override
  bool get wantKeepAlive =>
      _moveController?.isAnimating == true ||
      _resizeController?.isAnimating == true;

  SwipeDirection _extentToDirection(double extent) {
    if (extent == 0.0) return SwipeDirection.none;
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        return extent < 0
            ? SwipeDirection.startToEnd
            : SwipeDirection.endToStart;
      case TextDirection.ltr:
        return extent > 0
            ? SwipeDirection.startToEnd
            : SwipeDirection.endToStart;
    }
  }

  SwipeDirection get _swipeDirection => _extentToDirection(_dragExtent);

  bool get _isActive {
    return _dragUnderway || _moveController!.isAnimating;
  }

  double get _overallDragAxisExtent {
    final Size size = context.size!;
    return widget.swipeWidth ?? size.width;
  }

  void _handleDragStart(DragStartDetails details) {
    _dragUnderway = true;
    if (_moveController!.isAnimating) {
      _dragExtent =
          _moveController!.value * _overallDragAxisExtent * _dragExtent.sign;
      _moveController!.stop();
    } else {
      _dragExtent = 0.0;
      _moveController!.value = 0.0;
    }
    setState(() {
      _updateMoveAnimation();
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isActive || _moveController!.isAnimating) return;

    final double delta = details.primaryDelta!;
    final double oldDragExtent = _dragExtent;
    switch (widget.direction) {
      case SwipeDirection.horizontal:
        _dragExtent += delta;
        break;

      case SwipeDirection.endToStart:
        switch (Directionality.of(context)) {
          case TextDirection.rtl:
            if (_dragExtent + delta > 0) _dragExtent += delta;
            break;
          case TextDirection.ltr:
            if (_dragExtent + delta < 0) _dragExtent += (delta);
            break;
        }
        break;

      case SwipeDirection.startToEnd:
        switch (Directionality.of(context)) {
          case TextDirection.rtl:
            if (_dragExtent + delta < 0) _dragExtent += delta;
            break;
          case TextDirection.ltr:
            if (_dragExtent + delta > 0) _dragExtent += (delta);
            break;
        }
        break;

      case SwipeDirection.none:
        _dragExtent = 0;
        break;
    }
    if (oldDragExtent.sign != _dragExtent.sign) {
      setState(() {
        _updateMoveAnimation();
      });
    }

    if (!_moveController!.isAnimating) {
      _moveController!.value = _dragExtent.abs() / _overallDragAxisExtent;
    }
  }

  void _updateMoveAnimation() {
    _moveAnimation = _moveController!.drive(
      Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(1, 0),
      ),
    );
  }

  FlingGestureKind _describeFlingGesture(Velocity velocity) {
    if (_dragExtent == 0.0) {
      return FlingGestureKind.none;
    }
    final double vx = velocity.pixelsPerSecond.dx;
    final double vy = velocity.pixelsPerSecond.dy;
    SwipeDirection flingDirection;
    if (vx.abs() - vy.abs() < kMinFlingVelocityDelta ||
        vx.abs() < kMinFlingVelocity) return FlingGestureKind.none;
    assert(vx != 0.0);
    flingDirection = _extentToDirection(vx);

    if (flingDirection == _swipeDirection) return FlingGestureKind.forward;
    return FlingGestureKind.reverse;
  }

  Future<void> _handleDragEnd(DragEndDetails details) async {
    if (!_isActive || _moveController!.isAnimating) return;
    _dragUnderway = false;
    if (_moveController!.isCompleted &&
        await _confirmStartResizeAnimation() == true) {
      if (widget.swipeToTrigger) {
        _handleSwipeToTriggerAnimation();
      } else {
        _startResizeAnimation();
      }

      return;
    }
    final double flingVelocity = details.velocity.pixelsPerSecond.dx;

    switch (_describeFlingGesture(details.velocity)) {
      case FlingGestureKind.forward:
        assert(_dragExtent != 0.0);
        assert(!_moveController!.isDismissed);
        if ((widget.swipeThreshold) >= 1.0) {
          _moveController!.reverse();
          break;
        }
        _dragExtent = flingVelocity.sign;
        _moveController!
            .fling(velocity: flingVelocity.abs() * kFlingVelocityScale);
        break;
      case FlingGestureKind.reverse:
        assert(_dragExtent != 0.0);
        assert(!_moveController!.isDismissed);
        _dragExtent = flingVelocity.sign;
        _moveController!
            .fling(velocity: -flingVelocity.abs() * kFlingVelocityScale);
        break;
      case FlingGestureKind.none:
        if (!_moveController!.isDismissed) {
          if (_moveController!.value > (widget.swipeThreshold)) {
            if (widget.swipeToTrigger) {
              _moveController!.reverse();
            } else {
              _moveController!.forward();
            }
          } else {
            _moveController!.reverse();
          }
        }
        break;
    }
  }

  Future<void> _handleDismissStatusChanged(AnimationStatus status) async {
    if (status == AnimationStatus.completed && !_dragUnderway) {
      if (widget.swipeToTrigger) {
        _handleSwipeToTriggerAnimation();
      } else if (status == AnimationStatus.completed && !_dragUnderway) {
        if (await _confirmStartResizeAnimation() == true) {
          _startResizeAnimation();
        } else {
          _moveController!.reverse();
        }
      }
    }

    updateKeepAlive();
  }

  Future<bool?> _confirmStartResizeAnimation() async {
    if (widget.confirmSwipe != null) {
      final SwipeDirection direction = _swipeDirection;
      return widget.confirmSwipe!(direction);
    }
    return true;
  }

  void _handleSwipeToTriggerAnimation() async {
    await _moveController!.reverse();
    final SwipeDirection direction = _swipeDirection;
    widget.onSwiped(direction);
  }

  void _startResizeAnimation() {
    assert(_moveController != null);
    assert(_moveController!.isCompleted);
    assert(_resizeController == null);
    assert(_sizePriorToCollapse == null);
    _resizeController =
        AnimationController(duration: widget.resizeDuration, vsync: this)
          ..addListener(_handleResizeProgressChanged)
          ..addStatusListener((AnimationStatus status) => updateKeepAlive());
    _resizeController!.forward();
    setState(() {
      _sizePriorToCollapse = context.size;
      _resizeAnimation = _resizeController!
          .drive(
            CurveTween(
              curve: kResizeTimeCurve,
            ),
          )
          .drive(
            Tween<double>(
              begin: 1.0,
              end: 0.0,
            ),
          );
    });
  }

  void _handleResizeProgressChanged() {
    if (_resizeController!.isCompleted) {
      widget.onSwiped.call(_swipeDirection);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Widget buildBackground =
        widget.backgroundBuilder(context, _swipeDirection, _moveController!);
    final SwipeDirection direction = widget.direction;
    final EdgeInsetsGeometry padding = EdgeInsets.symmetric(
      horizontal: widget.horizontalPadding,
      vertical: widget.verticalPadding,
    );
    final bool isCard = widget.isCard;
    final double borderRadius = widget.borderRadius;
    final Color color = widget.color;
    final bool isElevated = widget.isElevated;

    assert(debugCheckHasDirectionality(context));

    if (_resizeAnimation != null) {
      assert(() {
        if (_resizeAnimation!.status != AnimationStatus.forward) {
          assert(_resizeAnimation!.status == AnimationStatus.completed);
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary(
                'A swiped SwipeableTile widget is still part of the tree.'),
            ErrorHint(
              'Make sure to implement the onSwiped handler and to immediately remove the SwipeableTile '
              'widget from the application once that handler has fired.',
            ),
          ]);
        }
        return true;
      }());

      return SizeTransition(
        sizeFactor: _resizeAnimation!,
        axis: Axis.vertical,
        child: Container(
          padding: padding,
          width: _sizePriorToCollapse!.width,
          height: _sizePriorToCollapse!.height,
          child: ClipRRect(
            borderRadius: isCard
                ? BorderRadius.circular(borderRadius)
                : BorderRadius.zero,
            child: buildBackground,
          ),
        ),
      );
    }

    return GestureDetector(
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      behavior: widget.behavior,
      child: NormalTile(
        moveAnimation: _moveAnimation,
        controller: _moveController!,
        background: buildBackground,
        direction: direction,
        padding: padding,
        borderRadius: borderRadius,
        color: color,
        isElevated: isElevated,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _moveController!.dispose();
    _resizeController?.dispose();
    super.dispose();
  }
}
