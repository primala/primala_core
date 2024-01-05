// Mocks generated by Mockito 5.4.4 from annotations
// in nokhte/test/app/core/widgets/explanatory_model_widgets/explanatory_model_widgets_mock_gen.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:mobx/mobx.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:nokhte/app/core/types/types.dart' as _i5;
import 'package:nokhte/app/core/widgets/explanatory_model_widgets/individual_widgets/accompanying_text/stack/presentation/mobx/accompanying_text_store.dart'
    as _i7;
import 'package:nokhte/app/core/widgets/explanatory_model_widgets/individual_widgets/gradient_circles/dumb_gradient_circle/stack/presentation/mobx/dumb_gradient_circle_store.dart'
    as _i4;
import 'package:nokhte/app/core/widgets/explanatory_model_widgets/individual_widgets/gradient_circles/smart_gradient_circle/stack/presentation/mobx/smart_gradient_circle_store.dart'
    as _i6;
import 'package:simple_animations/simple_animations.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeMovieTween_0 extends _i1.SmartFake implements _i2.MovieTween {
  _FakeMovieTween_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeReactiveContext_1 extends _i1.SmartFake
    implements _i3.ReactiveContext {
  _FakeReactiveContext_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [DumbGradientCircleStore].
///
/// See the documentation for Mockito's code generation for more information.
class MockDumbGradientCircleStore extends _i1.Mock
    implements _i4.DumbGradientCircleStore {
  @override
  bool get callsOnCompleteTwice => (super.noSuchMethod(
        Invocation.getter(#callsOnCompleteTwice),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  _i2.MovieTween get movie => (super.noSuchMethod(
        Invocation.getter(#movie),
        returnValue: _FakeMovieTween_0(
          this,
          Invocation.getter(#movie),
        ),
        returnValueForMissingStub: _FakeMovieTween_0(
          this,
          Invocation.getter(#movie),
        ),
      ) as _i2.MovieTween);

  @override
  set movie(_i2.MovieTween? value) => super.noSuchMethod(
        Invocation.setter(
          #movie,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.Control get control => (super.noSuchMethod(
        Invocation.getter(#control),
        returnValue: _i2.Control.stop,
        returnValueForMissingStub: _i2.Control.stop,
      ) as _i2.Control);

  @override
  set control(_i2.Control? value) => super.noSuchMethod(
        Invocation.setter(
          #control,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.Control get pastControl => (super.noSuchMethod(
        Invocation.getter(#pastControl),
        returnValue: _i2.Control.stop,
        returnValueForMissingStub: _i2.Control.stop,
      ) as _i2.Control);

  @override
  set pastControl(_i2.Control? value) => super.noSuchMethod(
        Invocation.setter(
          #pastControl,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get showWidget => (super.noSuchMethod(
        Invocation.getter(#showWidget),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  set showWidget(bool? value) => super.noSuchMethod(
        Invocation.setter(
          #showWidget,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.MovieStatus get movieStatus => (super.noSuchMethod(
        Invocation.getter(#movieStatus),
        returnValue: _i5.MovieStatus.idle,
        returnValueForMissingStub: _i5.MovieStatus.idle,
      ) as _i5.MovieStatus);

  @override
  set movieStatus(_i5.MovieStatus? value) => super.noSuchMethod(
        Invocation.setter(
          #movieStatus,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get hasFadedIn => (super.noSuchMethod(
        Invocation.getter(#hasFadedIn),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  set hasFadedIn(bool? value) => super.noSuchMethod(
        Invocation.setter(
          #hasFadedIn,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  int get tapCount => (super.noSuchMethod(
        Invocation.getter(#tapCount),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as int);

  @override
  set tapCount(int? value) => super.noSuchMethod(
        Invocation.setter(
          #tapCount,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  List<Object> get props => (super.noSuchMethod(
        Invocation.getter(#props),
        returnValue: <Object>[],
        returnValueForMissingStub: <Object>[],
      ) as List<Object>);

  @override
  _i3.ReactiveContext get context => (super.noSuchMethod(
        Invocation.getter(#context),
        returnValue: _FakeReactiveContext_1(
          this,
          Invocation.getter(#context),
        ),
        returnValueForMissingStub: _FakeReactiveContext_1(
          this,
          Invocation.getter(#context),
        ),
      ) as _i3.ReactiveContext);

  @override
  dynamic setPastControl(_i2.Control? newControl) => super.noSuchMethod(
        Invocation.method(
          #setPastControl,
          [newControl],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void setMovie(_i2.MovieTween? newMovie) => super.noSuchMethod(
        Invocation.method(
          #setMovie,
          [newMovie],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void setControl(_i2.Control? newControl) => super.noSuchMethod(
        Invocation.method(
          #setControl,
          [newControl],
        ),
        returnValueForMissingStub: null,
      );

  @override
  dynamic setMovieStatus(_i5.MovieStatus? newMovieStatus) => super.noSuchMethod(
        Invocation.method(
          #setMovieStatus,
          [newMovieStatus],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [SmartGradientCircleStore].
///
/// See the documentation for Mockito's code generation for more information.
class MockSmartGradientCircleStore extends _i1.Mock
    implements _i6.SmartGradientCircleStore {
  @override
  bool get callsOnCompleteTwice => (super.noSuchMethod(
        Invocation.getter(#callsOnCompleteTwice),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  _i2.MovieTween get movie => (super.noSuchMethod(
        Invocation.getter(#movie),
        returnValue: _FakeMovieTween_0(
          this,
          Invocation.getter(#movie),
        ),
        returnValueForMissingStub: _FakeMovieTween_0(
          this,
          Invocation.getter(#movie),
        ),
      ) as _i2.MovieTween);

  @override
  set movie(_i2.MovieTween? value) => super.noSuchMethod(
        Invocation.setter(
          #movie,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.Control get control => (super.noSuchMethod(
        Invocation.getter(#control),
        returnValue: _i2.Control.stop,
        returnValueForMissingStub: _i2.Control.stop,
      ) as _i2.Control);

  @override
  set control(_i2.Control? value) => super.noSuchMethod(
        Invocation.setter(
          #control,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.Control get pastControl => (super.noSuchMethod(
        Invocation.getter(#pastControl),
        returnValue: _i2.Control.stop,
        returnValueForMissingStub: _i2.Control.stop,
      ) as _i2.Control);

  @override
  set pastControl(_i2.Control? value) => super.noSuchMethod(
        Invocation.setter(
          #pastControl,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get showWidget => (super.noSuchMethod(
        Invocation.getter(#showWidget),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  set showWidget(bool? value) => super.noSuchMethod(
        Invocation.setter(
          #showWidget,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.MovieStatus get movieStatus => (super.noSuchMethod(
        Invocation.getter(#movieStatus),
        returnValue: _i5.MovieStatus.idle,
        returnValueForMissingStub: _i5.MovieStatus.idle,
      ) as _i5.MovieStatus);

  @override
  set movieStatus(_i5.MovieStatus? value) => super.noSuchMethod(
        Invocation.setter(
          #movieStatus,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get hasFadedIn => (super.noSuchMethod(
        Invocation.getter(#hasFadedIn),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  set hasFadedIn(bool? value) => super.noSuchMethod(
        Invocation.setter(
          #hasFadedIn,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  int get tapCount => (super.noSuchMethod(
        Invocation.getter(#tapCount),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as int);

  @override
  set tapCount(int? value) => super.noSuchMethod(
        Invocation.setter(
          #tapCount,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  List<Object> get props => (super.noSuchMethod(
        Invocation.getter(#props),
        returnValue: <Object>[],
        returnValueForMissingStub: <Object>[],
      ) as List<Object>);

  @override
  _i3.ReactiveContext get context => (super.noSuchMethod(
        Invocation.getter(#context),
        returnValue: _FakeReactiveContext_1(
          this,
          Invocation.getter(#context),
        ),
        returnValueForMissingStub: _FakeReactiveContext_1(
          this,
          Invocation.getter(#context),
        ),
      ) as _i3.ReactiveContext);

  @override
  dynamic setPastControl(_i2.Control? newControl) => super.noSuchMethod(
        Invocation.method(
          #setPastControl,
          [newControl],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void setMovie(_i2.MovieTween? newMovie) => super.noSuchMethod(
        Invocation.method(
          #setMovie,
          [newMovie],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void setControl(_i2.Control? newControl) => super.noSuchMethod(
        Invocation.method(
          #setControl,
          [newControl],
        ),
        returnValueForMissingStub: null,
      );

  @override
  dynamic setMovieStatus(_i5.MovieStatus? newMovieStatus) => super.noSuchMethod(
        Invocation.method(
          #setMovieStatus,
          [newMovieStatus],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [AccompanyingTextStore].
///
/// See the documentation for Mockito's code generation for more information.
class MockAccompanyingTextStore extends _i1.Mock
    implements _i7.AccompanyingTextStore {
  @override
  bool get callsOnCompleteTwice => (super.noSuchMethod(
        Invocation.getter(#callsOnCompleteTwice),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  _i2.MovieTween get movie => (super.noSuchMethod(
        Invocation.getter(#movie),
        returnValue: _FakeMovieTween_0(
          this,
          Invocation.getter(#movie),
        ),
        returnValueForMissingStub: _FakeMovieTween_0(
          this,
          Invocation.getter(#movie),
        ),
      ) as _i2.MovieTween);

  @override
  set movie(_i2.MovieTween? value) => super.noSuchMethod(
        Invocation.setter(
          #movie,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.Control get control => (super.noSuchMethod(
        Invocation.getter(#control),
        returnValue: _i2.Control.stop,
        returnValueForMissingStub: _i2.Control.stop,
      ) as _i2.Control);

  @override
  set control(_i2.Control? value) => super.noSuchMethod(
        Invocation.setter(
          #control,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.Control get pastControl => (super.noSuchMethod(
        Invocation.getter(#pastControl),
        returnValue: _i2.Control.stop,
        returnValueForMissingStub: _i2.Control.stop,
      ) as _i2.Control);

  @override
  set pastControl(_i2.Control? value) => super.noSuchMethod(
        Invocation.setter(
          #pastControl,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get showWidget => (super.noSuchMethod(
        Invocation.getter(#showWidget),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  set showWidget(bool? value) => super.noSuchMethod(
        Invocation.setter(
          #showWidget,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.MovieStatus get movieStatus => (super.noSuchMethod(
        Invocation.getter(#movieStatus),
        returnValue: _i5.MovieStatus.idle,
        returnValueForMissingStub: _i5.MovieStatus.idle,
      ) as _i5.MovieStatus);

  @override
  set movieStatus(_i5.MovieStatus? value) => super.noSuchMethod(
        Invocation.setter(
          #movieStatus,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get hasFadedIn => (super.noSuchMethod(
        Invocation.getter(#hasFadedIn),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  set hasFadedIn(bool? value) => super.noSuchMethod(
        Invocation.setter(
          #hasFadedIn,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  int get tapCount => (super.noSuchMethod(
        Invocation.getter(#tapCount),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as int);

  @override
  set tapCount(int? value) => super.noSuchMethod(
        Invocation.setter(
          #tapCount,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  List<Object> get props => (super.noSuchMethod(
        Invocation.getter(#props),
        returnValue: <Object>[],
        returnValueForMissingStub: <Object>[],
      ) as List<Object>);

  @override
  _i3.ReactiveContext get context => (super.noSuchMethod(
        Invocation.getter(#context),
        returnValue: _FakeReactiveContext_1(
          this,
          Invocation.getter(#context),
        ),
        returnValueForMissingStub: _FakeReactiveContext_1(
          this,
          Invocation.getter(#context),
        ),
      ) as _i3.ReactiveContext);

  @override
  dynamic setPastControl(_i2.Control? newControl) => super.noSuchMethod(
        Invocation.method(
          #setPastControl,
          [newControl],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void setMovie(_i2.MovieTween? newMovie) => super.noSuchMethod(
        Invocation.method(
          #setMovie,
          [newMovie],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void setControl(_i2.Control? newControl) => super.noSuchMethod(
        Invocation.method(
          #setControl,
          [newControl],
        ),
        returnValueForMissingStub: null,
      );

  @override
  dynamic setMovieStatus(_i5.MovieStatus? newMovieStatus) => super.noSuchMethod(
        Invocation.method(
          #setMovieStatus,
          [newMovieStatus],
        ),
        returnValueForMissingStub: null,
      );
}
