// Mocks generated by Mockito 5.4.2 from annotations
// in nokhte/test/app/core/widgets/wifi_disconnect_overlay/wifi_disconnect_mocks.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i2;

import 'package:connectivity_plus/connectivity_plus.dart' as _i6;
import 'package:mobx/mobx.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:nokhte/app/core/modules/connectivity/logic/get_on_connectivity_changed.dart'
    as _i3;
import 'package:nokhte/app/core/modules/connectivity/mobx/get_on_connectivity_changed_store.dart'
    as _i5;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeStreamSubscription_0<T> extends _i1.SmartFake
    implements _i2.StreamSubscription<T> {
  _FakeStreamSubscription_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGetOnConnectivityChanged_1 extends _i1.SmartFake
    implements _i3.GetOnConnectivityChanged {
  _FakeGetOnConnectivityChanged_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeObservableStream_2<T> extends _i1.SmartFake
    implements _i4.ObservableStream<T> {
  _FakeObservableStream_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeReactiveContext_3 extends _i1.SmartFake
    implements _i4.ReactiveContext {
  _FakeReactiveContext_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GetOnConnectivityChangedStore].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetOnConnectivityChangedStore extends _i1.Mock
    implements _i5.GetOnConnectivityChangedStore {
  MockGetOnConnectivityChangedStore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.StreamSubscription<_i6.ConnectivityResult> get streamSub =>
      (super.noSuchMethod(
        Invocation.getter(#streamSub),
        returnValue: _FakeStreamSubscription_0<_i6.ConnectivityResult>(
          this,
          Invocation.getter(#streamSub),
        ),
      ) as _i2.StreamSubscription<_i6.ConnectivityResult>);

  @override
  set streamSub(_i2.StreamSubscription<_i6.ConnectivityResult>? _streamSub) =>
      super.noSuchMethod(
        Invocation.setter(
          #streamSub,
          _streamSub,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i3.GetOnConnectivityChanged get logic => (super.noSuchMethod(
        Invocation.getter(#logic),
        returnValue: _FakeGetOnConnectivityChanged_1(
          this,
          Invocation.getter(#logic),
        ),
      ) as _i3.GetOnConnectivityChanged);

  @override
  _i4.ObservableStream<_i6.ConnectivityResult> get connectivityStream =>
      (super.noSuchMethod(
        Invocation.getter(#connectivityStream),
        returnValue: _FakeObservableStream_2<_i6.ConnectivityResult>(
          this,
          Invocation.getter(#connectivityStream),
        ),
      ) as _i4.ObservableStream<_i6.ConnectivityResult>);

  @override
  set connectivityStream(_i4.ObservableStream<_i6.ConnectivityResult>? value) =>
      super.noSuchMethod(
        Invocation.setter(
          #connectivityStream,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get isConnected => (super.noSuchMethod(
        Invocation.getter(#isConnected),
        returnValue: false,
      ) as bool);

  @override
  set isConnected(bool? value) => super.noSuchMethod(
        Invocation.setter(
          #isConnected,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i6.ConnectivityResult get mostRecentResult => (super.noSuchMethod(
        Invocation.getter(#mostRecentResult),
        returnValue: _i6.ConnectivityResult.bluetooth,
      ) as _i6.ConnectivityResult);

  @override
  set mostRecentResult(_i6.ConnectivityResult? value) => super.noSuchMethod(
        Invocation.setter(
          #mostRecentResult,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  List<Object> get props => (super.noSuchMethod(
        Invocation.getter(#props),
        returnValue: <Object>[],
      ) as List<Object>);

  @override
  _i4.ReactiveContext get context => (super.noSuchMethod(
        Invocation.getter(#context),
        returnValue: _FakeReactiveContext_3(
          this,
          Invocation.getter(#context),
        ),
      ) as _i4.ReactiveContext);

  @override
  dynamic setMostRecentResult(_i6.ConnectivityResult? newResult) =>
      super.noSuchMethod(Invocation.method(
        #setMostRecentResult,
        [newResult],
      ));
}
