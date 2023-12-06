// Mocks generated by Mockito 5.4.2 from annotations
// in nokhte/test/app/core/modules/voice_call/fixtures/voice_call_mock_gen.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i12;

import 'package:agora_rtc_engine/agora_rtc_engine.dart' as _i5;
import 'package:dartz/dartz.dart' as _i7;
import 'package:http/http.dart' as _i6;
import 'package:mobx/mobx.dart' as _i10;
import 'package:mockito/mockito.dart' as _i1;
import 'package:nokhte/app/core/error/failure.dart' as _i13;
import 'package:nokhte/app/core/interfaces/logic.dart' as _i14;
import 'package:nokhte/app/core/mobx/base_future_store.dart' as _i9;
import 'package:nokhte/app/core/mobx/store_state.dart' as _i15;
import 'package:nokhte/app/core/modules/voice_call/domain/domain.dart' as _i8;
import 'package:nokhte/app/core/modules/voice_call/mobx/mobx.dart' as _i4;
import 'package:nokhte/app/core/types/types.dart' as _i16;
import 'package:nokhte_backend/tables/existing_collaborations.dart' as _i3;
import 'package:supabase_flutter/supabase_flutter.dart' as _i2;

import 'voice_call_mock_gen.dart' as _i11;

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

class _FakeSupabaseClient_0 extends _i1.SmartFake
    implements _i2.SupabaseClient {
  _FakeSupabaseClient_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeExistingCollaborationsQueries_1 extends _i1.SmartFake
    implements _i3.ExistingCollaborationsQueries {
  _FakeExistingCollaborationsQueries_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAgoraCallbacksStore_2 extends _i1.SmartFake
    implements _i4.AgoraCallbacksStore {
  _FakeAgoraCallbacksStore_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeRtcEngine_3 extends _i1.SmartFake implements _i5.RtcEngine {
  _FakeRtcEngine_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeResponse_4 extends _i1.SmartFake implements _i6.Response {
  _FakeResponse_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEither_5<L, R> extends _i1.SmartFake implements _i7.Either<L, R> {
  _FakeEither_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeVoiceCallContract_6 extends _i1.SmartFake
    implements _i8.VoiceCallContract {
  _FakeVoiceCallContract_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGetAgoraToken_7 extends _i1.SmartFake implements _i8.GetAgoraToken {
  _FakeGetAgoraToken_7(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBaseFutureStore_8<T> extends _i1.SmartFake
    implements _i9.BaseFutureStore<T> {
  _FakeBaseFutureStore_8(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeReactiveContext_9 extends _i1.SmartFake
    implements _i10.ReactiveContext {
  _FakeReactiveContext_9(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGetChannelId_10 extends _i1.SmartFake implements _i8.GetChannelId {
  _FakeGetChannelId_10(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeInstantiateAgoraSdk_11 extends _i1.SmartFake
    implements _i8.InstantiateAgoraSdk {
  _FakeInstantiateAgoraSdk_11(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeJoinCall_12 extends _i1.SmartFake implements _i8.JoinCall {
  _FakeJoinCall_12(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLeaveCall_13 extends _i1.SmartFake implements _i8.LeaveCall {
  _FakeLeaveCall_13(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeMuteLocalAudio_14 extends _i1.SmartFake
    implements _i8.MuteLocalAudio {
  _FakeMuteLocalAudio_14(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUnmuteLocalAudio_15 extends _i1.SmartFake
    implements _i8.UnmuteLocalAudio {
  _FakeUnmuteLocalAudio_15(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [MVoiceCallRemoteSourceImpl].
///
/// See the documentation for Mockito's code generation for more information.
class MockMVoiceCallRemoteSourceImpl extends _i1.Mock
    implements _i11.MVoiceCallRemoteSourceImpl {
  MockMVoiceCallRemoteSourceImpl() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.SupabaseClient get supabase => (super.noSuchMethod(
        Invocation.getter(#supabase),
        returnValue: _FakeSupabaseClient_0(
          this,
          Invocation.getter(#supabase),
        ),
      ) as _i2.SupabaseClient);

  @override
  _i3.ExistingCollaborationsQueries get existingCollaborationsQueries =>
      (super.noSuchMethod(
        Invocation.getter(#existingCollaborationsQueries),
        returnValue: _FakeExistingCollaborationsQueries_1(
          this,
          Invocation.getter(#existingCollaborationsQueries),
        ),
      ) as _i3.ExistingCollaborationsQueries);

  @override
  _i4.AgoraCallbacksStore get agoraCallbacksStore => (super.noSuchMethod(
        Invocation.getter(#agoraCallbacksStore),
        returnValue: _FakeAgoraCallbacksStore_2(
          this,
          Invocation.getter(#agoraCallbacksStore),
        ),
      ) as _i4.AgoraCallbacksStore);

  @override
  String get currentUserUID => (super.noSuchMethod(
        Invocation.getter(#currentUserUID),
        returnValue: '',
      ) as String);

  @override
  int get currentAgoraUID => (super.noSuchMethod(
        Invocation.getter(#currentAgoraUID),
        returnValue: 0,
      ) as int);

  @override
  _i5.RtcEngine get agoraEngine => (super.noSuchMethod(
        Invocation.getter(#agoraEngine),
        returnValue: _FakeRtcEngine_3(
          this,
          Invocation.getter(#agoraEngine),
        ),
      ) as _i5.RtcEngine);

  @override
  _i12.Future<_i6.Response> getAgoraToken({required String? channelName}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAgoraToken,
          [],
          {#channelName: channelName},
        ),
        returnValue: _i12.Future<_i6.Response>.value(_FakeResponse_4(
          this,
          Invocation.method(
            #getAgoraToken,
            [],
            {#channelName: channelName},
          ),
        )),
      ) as _i12.Future<_i6.Response>);

  @override
  _i12.Future<void> joinCall({
    required String? token,
    required String? channelId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #joinCall,
          [],
          {
            #token: token,
            #channelId: channelId,
          },
        ),
        returnValue: _i12.Future<void>.value(),
        returnValueForMissingStub: _i12.Future<void>.value(),
      ) as _i12.Future<void>);

  @override
  _i12.Future<void> leaveCall() => (super.noSuchMethod(
        Invocation.method(
          #leaveCall,
          [],
        ),
        returnValue: _i12.Future<void>.value(),
        returnValueForMissingStub: _i12.Future<void>.value(),
      ) as _i12.Future<void>);

  @override
  _i12.Future<void> instantiateAgoraSDK() => (super.noSuchMethod(
        Invocation.method(
          #instantiateAgoraSDK,
          [],
        ),
        returnValue: _i12.Future<void>.value(),
        returnValueForMissingStub: _i12.Future<void>.value(),
      ) as _i12.Future<void>);

  @override
  _i12.Future<List<dynamic>> getCollaboratorInfo() => (super.noSuchMethod(
        Invocation.method(
          #getCollaboratorInfo,
          [],
        ),
        returnValue: _i12.Future<List<dynamic>>.value(<dynamic>[]),
      ) as _i12.Future<List<dynamic>>);

  @override
  _i12.Future<dynamic> muteLocalAudio() => (super.noSuchMethod(
        Invocation.method(
          #muteLocalAudio,
          [],
        ),
        returnValue: _i12.Future<dynamic>.value(),
      ) as _i12.Future<dynamic>);

  @override
  _i12.Future<dynamic> unmuteLocalAudio() => (super.noSuchMethod(
        Invocation.method(
          #unmuteLocalAudio,
          [],
        ),
        returnValue: _i12.Future<dynamic>.value(),
      ) as _i12.Future<dynamic>);
}

/// A class which mocks [MVoiceCallContract].
///
/// See the documentation for Mockito's code generation for more information.
class MockMVoiceCallContract extends _i1.Mock
    implements _i11.MVoiceCallContract {
  MockMVoiceCallContract() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i7.Either<_i13.Failure, _i8.AgoraCallTokenEntity>> getAgoraToken(
          {required String? channelName}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAgoraToken,
          [],
          {#channelName: channelName},
        ),
        returnValue: _i12
            .Future<_i7.Either<_i13.Failure, _i8.AgoraCallTokenEntity>>.value(
            _FakeEither_5<_i13.Failure, _i8.AgoraCallTokenEntity>(
          this,
          Invocation.method(
            #getAgoraToken,
            [],
            {#channelName: channelName},
          ),
        )),
      ) as _i12.Future<_i7.Either<_i13.Failure, _i8.AgoraCallTokenEntity>>);

  @override
  _i12.Future<_i7.Either<_i13.Failure, _i8.ChannelIdEntity>> getChannelId() =>
      (super.noSuchMethod(
        Invocation.method(
          #getChannelId,
          [],
        ),
        returnValue:
            _i12.Future<_i7.Either<_i13.Failure, _i8.ChannelIdEntity>>.value(
                _FakeEither_5<_i13.Failure, _i8.ChannelIdEntity>(
          this,
          Invocation.method(
            #getChannelId,
            [],
          ),
        )),
      ) as _i12.Future<_i7.Either<_i13.Failure, _i8.ChannelIdEntity>>);

  @override
  _i12.Future<_i7.Either<_i13.Failure, _i8.AgoraSdkStatusEntity>>
      instantiateAgoraSdk() => (super.noSuchMethod(
            Invocation.method(
              #instantiateAgoraSdk,
              [],
            ),
            returnValue: _i12.Future<
                    _i7.Either<_i13.Failure, _i8.AgoraSdkStatusEntity>>.value(
                _FakeEither_5<_i13.Failure, _i8.AgoraSdkStatusEntity>(
              this,
              Invocation.method(
                #instantiateAgoraSdk,
                [],
              ),
            )),
          ) as _i12.Future<_i7.Either<_i13.Failure, _i8.AgoraSdkStatusEntity>>);

  @override
  _i12.Future<_i7.Either<_i13.Failure, _i8.CallStatusEntity>> joinCall(
    String? token,
    String? channelId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #joinCall,
          [
            token,
            channelId,
          ],
        ),
        returnValue:
            _i12.Future<_i7.Either<_i13.Failure, _i8.CallStatusEntity>>.value(
                _FakeEither_5<_i13.Failure, _i8.CallStatusEntity>(
          this,
          Invocation.method(
            #joinCall,
            [
              token,
              channelId,
            ],
          ),
        )),
      ) as _i12.Future<_i7.Either<_i13.Failure, _i8.CallStatusEntity>>);

  @override
  _i12.Future<_i7.Either<_i13.Failure, _i8.CallStatusEntity>> leaveCall() =>
      (super.noSuchMethod(
        Invocation.method(
          #leaveCall,
          [],
        ),
        returnValue:
            _i12.Future<_i7.Either<_i13.Failure, _i8.CallStatusEntity>>.value(
                _FakeEither_5<_i13.Failure, _i8.CallStatusEntity>(
          this,
          Invocation.method(
            #leaveCall,
            [],
          ),
        )),
      ) as _i12.Future<_i7.Either<_i13.Failure, _i8.CallStatusEntity>>);

  @override
  _i12.Future<_i7.Either<_i13.Failure, _i8.LocalAudioStreamStatusEntity>>
      muteLocalAudio() => (super.noSuchMethod(
            Invocation.method(
              #muteLocalAudio,
              [],
            ),
            returnValue: _i12.Future<
                    _i7.Either<_i13.Failure,
                        _i8.LocalAudioStreamStatusEntity>>.value(
                _FakeEither_5<_i13.Failure, _i8.LocalAudioStreamStatusEntity>(
              this,
              Invocation.method(
                #muteLocalAudio,
                [],
              ),
            )),
          ) as _i12.Future<
              _i7.Either<_i13.Failure, _i8.LocalAudioStreamStatusEntity>>);

  @override
  _i12.Future<_i7.Either<_i13.Failure, _i8.LocalAudioStreamStatusEntity>>
      unmuteLocalAudio() => (super.noSuchMethod(
            Invocation.method(
              #unmuteLocalAudio,
              [],
            ),
            returnValue: _i12.Future<
                    _i7.Either<_i13.Failure,
                        _i8.LocalAudioStreamStatusEntity>>.value(
                _FakeEither_5<_i13.Failure, _i8.LocalAudioStreamStatusEntity>(
              this,
              Invocation.method(
                #unmuteLocalAudio,
                [],
              ),
            )),
          ) as _i12.Future<
              _i7.Either<_i13.Failure, _i8.LocalAudioStreamStatusEntity>>);
}

/// A class which mocks [MGetAgoraToken].
///
/// See the documentation for Mockito's code generation for more information.
class MockMGetAgoraToken extends _i1.Mock implements _i11.MGetAgoraToken {
  MockMGetAgoraToken() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.VoiceCallContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeVoiceCallContract_6(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i8.VoiceCallContract);

  @override
  _i12.Future<_i7.Either<_i13.Failure, _i8.AgoraCallTokenEntity>> call(
          _i8.GetAgoraTokenParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i12
            .Future<_i7.Either<_i13.Failure, _i8.AgoraCallTokenEntity>>.value(
            _FakeEither_5<_i13.Failure, _i8.AgoraCallTokenEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i12.Future<_i7.Either<_i13.Failure, _i8.AgoraCallTokenEntity>>);
}

/// A class which mocks [MGetChannelId].
///
/// See the documentation for Mockito's code generation for more information.
class MockMGetChannelId extends _i1.Mock implements _i11.MGetChannelId {
  MockMGetChannelId() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.VoiceCallContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeVoiceCallContract_6(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i8.VoiceCallContract);

  @override
  _i12.Future<_i7.Either<_i13.Failure, _i8.ChannelIdEntity>> call(
          _i14.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue:
            _i12.Future<_i7.Either<_i13.Failure, _i8.ChannelIdEntity>>.value(
                _FakeEither_5<_i13.Failure, _i8.ChannelIdEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i12.Future<_i7.Either<_i13.Failure, _i8.ChannelIdEntity>>);
}

/// A class which mocks [MInstantiateAgoraSdk].
///
/// See the documentation for Mockito's code generation for more information.
class MockMInstantiateAgoraSdk extends _i1.Mock
    implements _i11.MInstantiateAgoraSdk {
  MockMInstantiateAgoraSdk() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.VoiceCallContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeVoiceCallContract_6(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i8.VoiceCallContract);

  @override
  _i12.Future<_i7.Either<_i13.Failure, _i8.AgoraSdkStatusEntity>> call(
          _i14.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i12
            .Future<_i7.Either<_i13.Failure, _i8.AgoraSdkStatusEntity>>.value(
            _FakeEither_5<_i13.Failure, _i8.AgoraSdkStatusEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i12.Future<_i7.Either<_i13.Failure, _i8.AgoraSdkStatusEntity>>);
}

/// A class which mocks [MJoinCall].
///
/// See the documentation for Mockito's code generation for more information.
class MockMJoinCall extends _i1.Mock implements _i11.MJoinCall {
  MockMJoinCall() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.VoiceCallContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeVoiceCallContract_6(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i8.VoiceCallContract);

  @override
  _i12.Future<_i7.Either<_i13.Failure, _i8.CallStatusEntity>> call(
          _i8.JoinCallParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue:
            _i12.Future<_i7.Either<_i13.Failure, _i8.CallStatusEntity>>.value(
                _FakeEither_5<_i13.Failure, _i8.CallStatusEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i12.Future<_i7.Either<_i13.Failure, _i8.CallStatusEntity>>);
}

/// A class which mocks [MLeaveCall].
///
/// See the documentation for Mockito's code generation for more information.
class MockMLeaveCall extends _i1.Mock implements _i11.MLeaveCall {
  MockMLeaveCall() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.VoiceCallContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeVoiceCallContract_6(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i8.VoiceCallContract);

  @override
  _i12.Future<_i7.Either<_i13.Failure, _i8.CallStatusEntity>> call(
          _i14.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue:
            _i12.Future<_i7.Either<_i13.Failure, _i8.CallStatusEntity>>.value(
                _FakeEither_5<_i13.Failure, _i8.CallStatusEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i12.Future<_i7.Either<_i13.Failure, _i8.CallStatusEntity>>);
}

/// A class which mocks [MMuteLocalAudio].
///
/// See the documentation for Mockito's code generation for more information.
class MockMMuteLocalAudio extends _i1.Mock implements _i11.MMuteLocalAudio {
  MockMMuteLocalAudio() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.VoiceCallContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeVoiceCallContract_6(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i8.VoiceCallContract);

  @override
  _i12.Future<_i7.Either<_i13.Failure, _i8.LocalAudioStreamStatusEntity>> call(
          _i14.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i12.Future<
                _i7
                .Either<_i13.Failure, _i8.LocalAudioStreamStatusEntity>>.value(
            _FakeEither_5<_i13.Failure, _i8.LocalAudioStreamStatusEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i12
          .Future<_i7.Either<_i13.Failure, _i8.LocalAudioStreamStatusEntity>>);
}

/// A class which mocks [MUnmuteLocalAudio].
///
/// See the documentation for Mockito's code generation for more information.
class MockMUnmuteLocalAudio extends _i1.Mock implements _i11.MUnmuteLocalAudio {
  MockMUnmuteLocalAudio() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.VoiceCallContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeVoiceCallContract_6(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i8.VoiceCallContract);

  @override
  _i12.Future<_i7.Either<_i13.Failure, _i8.LocalAudioStreamStatusEntity>> call(
          _i14.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i12.Future<
                _i7
                .Either<_i13.Failure, _i8.LocalAudioStreamStatusEntity>>.value(
            _FakeEither_5<_i13.Failure, _i8.LocalAudioStreamStatusEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i12
          .Future<_i7.Either<_i13.Failure, _i8.LocalAudioStreamStatusEntity>>);
}

/// A class which mocks [MGetAgoraTokenStore].
///
/// See the documentation for Mockito's code generation for more information.
class MockMGetAgoraTokenStore extends _i1.Mock
    implements _i11.MGetAgoraTokenStore {
  MockMGetAgoraTokenStore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.GetAgoraToken get logic => (super.noSuchMethod(
        Invocation.getter(#logic),
        returnValue: _FakeGetAgoraToken_7(
          this,
          Invocation.getter(#logic),
        ),
      ) as _i8.GetAgoraToken);

  @override
  _i9.BaseFutureStore<_i8.AgoraCallTokenEntity> get futureStore =>
      (super.noSuchMethod(
        Invocation.getter(#futureStore),
        returnValue: _FakeBaseFutureStore_8<_i8.AgoraCallTokenEntity>(
          this,
          Invocation.getter(#futureStore),
        ),
      ) as _i9.BaseFutureStore<_i8.AgoraCallTokenEntity>);

  @override
  set futureStore(_i9.BaseFutureStore<_i8.AgoraCallTokenEntity>? value) =>
      super.noSuchMethod(
        Invocation.setter(
          #futureStore,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  String get token => (super.noSuchMethod(
        Invocation.getter(#token),
        returnValue: '',
      ) as String);

  @override
  set token(String? value) => super.noSuchMethod(
        Invocation.setter(
          #token,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i15.StoreState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _i15.StoreState.initial,
      ) as _i15.StoreState);

  @override
  set state(_i15.StoreState? value) => super.noSuchMethod(
        Invocation.setter(
          #state,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  String get errorMessage => (super.noSuchMethod(
        Invocation.getter(#errorMessage),
        returnValue: '',
      ) as String);

  @override
  set errorMessage(String? value) => super.noSuchMethod(
        Invocation.setter(
          #errorMessage,
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
  _i10.ReactiveContext get context => (super.noSuchMethod(
        Invocation.getter(#context),
        returnValue: _FakeReactiveContext_9(
          this,
          Invocation.getter(#context),
        ),
      ) as _i10.ReactiveContext);

  @override
  void stateOrErrorUpdater(
          _i7.Either<_i13.Failure, _i8.AgoraCallTokenEntity>? result) =>
      super.noSuchMethod(
        Invocation.method(
          #stateOrErrorUpdater,
          [result],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i12.Future<void> call(dynamic params) => (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i12.Future<void>.value(),
        returnValueForMissingStub: _i12.Future<void>.value(),
      ) as _i12.Future<void>);

  @override
  String mapFailureToMessage(_i13.Failure? failure) => (super.noSuchMethod(
        Invocation.method(
          #mapFailureToMessage,
          [failure],
        ),
        returnValue: '',
      ) as String);
}

/// A class which mocks [MGetChannelIdStore].
///
/// See the documentation for Mockito's code generation for more information.
class MockMGetChannelIdStore extends _i1.Mock
    implements _i11.MGetChannelIdStore {
  MockMGetChannelIdStore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.GetChannelId get logic => (super.noSuchMethod(
        Invocation.getter(#logic),
        returnValue: _FakeGetChannelId_10(
          this,
          Invocation.getter(#logic),
        ),
      ) as _i8.GetChannelId);

  @override
  String get channelId => (super.noSuchMethod(
        Invocation.getter(#channelId),
        returnValue: '',
      ) as String);

  @override
  set channelId(String? value) => super.noSuchMethod(
        Invocation.setter(
          #channelId,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i9.BaseFutureStore<_i8.ChannelIdEntity> get futureStore =>
      (super.noSuchMethod(
        Invocation.getter(#futureStore),
        returnValue: _FakeBaseFutureStore_8<_i8.ChannelIdEntity>(
          this,
          Invocation.getter(#futureStore),
        ),
      ) as _i9.BaseFutureStore<_i8.ChannelIdEntity>);

  @override
  set futureStore(_i9.BaseFutureStore<_i8.ChannelIdEntity>? value) =>
      super.noSuchMethod(
        Invocation.setter(
          #futureStore,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i15.StoreState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _i15.StoreState.initial,
      ) as _i15.StoreState);

  @override
  set state(_i15.StoreState? value) => super.noSuchMethod(
        Invocation.setter(
          #state,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  String get errorMessage => (super.noSuchMethod(
        Invocation.getter(#errorMessage),
        returnValue: '',
      ) as String);

  @override
  set errorMessage(String? value) => super.noSuchMethod(
        Invocation.setter(
          #errorMessage,
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
  _i10.ReactiveContext get context => (super.noSuchMethod(
        Invocation.getter(#context),
        returnValue: _FakeReactiveContext_9(
          this,
          Invocation.getter(#context),
        ),
      ) as _i10.ReactiveContext);

  @override
  void stateOrErrorUpdater(
          _i7.Either<_i13.Failure, _i8.ChannelIdEntity>? result) =>
      super.noSuchMethod(
        Invocation.method(
          #stateOrErrorUpdater,
          [result],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i12.Future<void> call(_i14.NoParams? params) => (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i12.Future<void>.value(),
        returnValueForMissingStub: _i12.Future<void>.value(),
      ) as _i12.Future<void>);

  @override
  String mapFailureToMessage(_i13.Failure? failure) => (super.noSuchMethod(
        Invocation.method(
          #mapFailureToMessage,
          [failure],
        ),
        returnValue: '',
      ) as String);
}

/// A class which mocks [MInstantiateAgoraSdkStore].
///
/// See the documentation for Mockito's code generation for more information.
class MockMInstantiateAgoraSdkStore extends _i1.Mock
    implements _i11.MInstantiateAgoraSdkStore {
  MockMInstantiateAgoraSdkStore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.InstantiateAgoraSdk get logic => (super.noSuchMethod(
        Invocation.getter(#logic),
        returnValue: _FakeInstantiateAgoraSdk_11(
          this,
          Invocation.getter(#logic),
        ),
      ) as _i8.InstantiateAgoraSdk);

  @override
  bool get isInstantiated => (super.noSuchMethod(
        Invocation.getter(#isInstantiated),
        returnValue: false,
      ) as bool);

  @override
  set isInstantiated(bool? value) => super.noSuchMethod(
        Invocation.setter(
          #isInstantiated,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i9.BaseFutureStore<_i8.AgoraSdkStatusEntity> get futureStore =>
      (super.noSuchMethod(
        Invocation.getter(#futureStore),
        returnValue: _FakeBaseFutureStore_8<_i8.AgoraSdkStatusEntity>(
          this,
          Invocation.getter(#futureStore),
        ),
      ) as _i9.BaseFutureStore<_i8.AgoraSdkStatusEntity>);

  @override
  set futureStore(_i9.BaseFutureStore<_i8.AgoraSdkStatusEntity>? value) =>
      super.noSuchMethod(
        Invocation.setter(
          #futureStore,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i15.StoreState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _i15.StoreState.initial,
      ) as _i15.StoreState);

  @override
  set state(_i15.StoreState? value) => super.noSuchMethod(
        Invocation.setter(
          #state,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  String get errorMessage => (super.noSuchMethod(
        Invocation.getter(#errorMessage),
        returnValue: '',
      ) as String);

  @override
  set errorMessage(String? value) => super.noSuchMethod(
        Invocation.setter(
          #errorMessage,
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
  _i10.ReactiveContext get context => (super.noSuchMethod(
        Invocation.getter(#context),
        returnValue: _FakeReactiveContext_9(
          this,
          Invocation.getter(#context),
        ),
      ) as _i10.ReactiveContext);

  @override
  void stateOrErrorUpdater(
          _i7.Either<_i13.Failure, _i8.AgoraSdkStatusEntity>? result) =>
      super.noSuchMethod(
        Invocation.method(
          #stateOrErrorUpdater,
          [result],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i12.Future<void> call(_i14.NoParams? params) => (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i12.Future<void>.value(),
        returnValueForMissingStub: _i12.Future<void>.value(),
      ) as _i12.Future<void>);

  @override
  String mapFailureToMessage(_i13.Failure? failure) => (super.noSuchMethod(
        Invocation.method(
          #mapFailureToMessage,
          [failure],
        ),
        returnValue: '',
      ) as String);
}

/// A class which mocks [MVoiceCallActionsStore].
///
/// See the documentation for Mockito's code generation for more information.
class MockMVoiceCallActionsStore extends _i1.Mock
    implements _i11.MVoiceCallActionsStore {
  MockMVoiceCallActionsStore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.JoinCall get joinCall => (super.noSuchMethod(
        Invocation.getter(#joinCall),
        returnValue: _FakeJoinCall_12(
          this,
          Invocation.getter(#joinCall),
        ),
      ) as _i8.JoinCall);

  @override
  _i8.LeaveCall get leaveCall => (super.noSuchMethod(
        Invocation.getter(#leaveCall),
        returnValue: _FakeLeaveCall_13(
          this,
          Invocation.getter(#leaveCall),
        ),
      ) as _i8.LeaveCall);

  @override
  _i8.MuteLocalAudio get muteAudio => (super.noSuchMethod(
        Invocation.getter(#muteAudio),
        returnValue: _FakeMuteLocalAudio_14(
          this,
          Invocation.getter(#muteAudio),
        ),
      ) as _i8.MuteLocalAudio);

  @override
  _i8.UnmuteLocalAudio get unmuteAudio => (super.noSuchMethod(
        Invocation.getter(#unmuteAudio),
        returnValue: _FakeUnmuteLocalAudio_15(
          this,
          Invocation.getter(#unmuteAudio),
        ),
      ) as _i8.UnmuteLocalAudio);

  @override
  _i16.CallStatus get callStatus => (super.noSuchMethod(
        Invocation.getter(#callStatus),
        returnValue: _i16.CallStatus.initial,
      ) as _i16.CallStatus);

  @override
  set callStatus(_i16.CallStatus? value) => super.noSuchMethod(
        Invocation.setter(
          #callStatus,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get isMuted => (super.noSuchMethod(
        Invocation.getter(#isMuted),
        returnValue: false,
      ) as bool);

  @override
  set isMuted(bool? value) => super.noSuchMethod(
        Invocation.setter(
          #isMuted,
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
  _i15.StoreState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _i15.StoreState.initial,
      ) as _i15.StoreState);

  @override
  set state(_i15.StoreState? value) => super.noSuchMethod(
        Invocation.setter(
          #state,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  String get errorMessage => (super.noSuchMethod(
        Invocation.getter(#errorMessage),
        returnValue: '',
      ) as String);

  @override
  set errorMessage(String? value) => super.noSuchMethod(
        Invocation.setter(
          #errorMessage,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i10.ReactiveContext get context => (super.noSuchMethod(
        Invocation.getter(#context),
        returnValue: _FakeReactiveContext_9(
          this,
          Invocation.getter(#context),
        ),
      ) as _i10.ReactiveContext);

  @override
  dynamic audioStateOrErrorUpdater(
          _i7.Either<_i13.Failure, _i8.LocalAudioStreamStatusEntity>? result) =>
      super.noSuchMethod(Invocation.method(
        #audioStateOrErrorUpdater,
        [result],
      ));

  @override
  dynamic callStateOrErrorUpdater(
          _i7.Either<_i13.Failure, _i8.CallStatusEntity>? result) =>
      super.noSuchMethod(Invocation.method(
        #callStateOrErrorUpdater,
        [result],
      ));

  @override
  _i12.Future<void> muteOrUnmuteAudio({required bool? wantToMute}) =>
      (super.noSuchMethod(
        Invocation.method(
          #muteOrUnmuteAudio,
          [],
          {#wantToMute: wantToMute},
        ),
        returnValue: _i12.Future<void>.value(),
        returnValueForMissingStub: _i12.Future<void>.value(),
      ) as _i12.Future<void>);

  @override
  _i12.Future<void> enterOrLeaveCall(
          _i7.Either<_i14.NoParams, _i8.JoinCallParams>? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #enterOrLeaveCall,
          [params],
        ),
        returnValue: _i12.Future<void>.value(),
        returnValueForMissingStub: _i12.Future<void>.value(),
      ) as _i12.Future<void>);

  @override
  String mapFailureToMessage(_i13.Failure? failure) => (super.noSuchMethod(
        Invocation.method(
          #mapFailureToMessage,
          [failure],
        ),
        returnValue: '',
      ) as String);

  @override
  void stateOrErrorUpdater(_i7.Either<_i13.Failure, dynamic>? result) =>
      super.noSuchMethod(
        Invocation.method(
          #stateOrErrorUpdater,
          [result],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i12.Future<void> call(dynamic params) => (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i12.Future<void>.value(),
        returnValueForMissingStub: _i12.Future<void>.value(),
      ) as _i12.Future<void>);
}
