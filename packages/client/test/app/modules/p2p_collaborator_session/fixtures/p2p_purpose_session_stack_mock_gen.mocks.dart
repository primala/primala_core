// Mocks generated by Mockito 5.4.1 from annotations
// in primala/test/app/modules/p2p_collaborator_session/fixtures/p2p_purpose_session_stack_mock_gen.dart.
// Do not manually edit this file.

// @dart=2.19

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i8;

import 'package:agora_rtc_engine/agora_rtc_engine.dart' as _i4;
import 'package:dartz/dartz.dart' as _i6;
import 'package:http/http.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:primala/app/core/error/failure.dart' as _i9;
import 'package:primala/app/modules/p2p_purpose_session/domain/domain.dart'
    as _i10;
import 'package:primala/app/modules/p2p_purpose_session/presentation/mobx/main/main.dart'
    as _i3;
import 'package:supabase_flutter/supabase_flutter.dart' as _i2;

import 'p2p_purpose_session_stack_mock_gen.dart' as _i7;

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

class _FakeAgoraCallbacksStore_1 extends _i1.SmartFake
    implements _i3.AgoraCallbacksStore {
  _FakeAgoraCallbacksStore_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeRtcEngine_2 extends _i1.SmartFake implements _i4.RtcEngine {
  _FakeRtcEngine_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeResponse_3 extends _i1.SmartFake implements _i5.Response {
  _FakeResponse_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEither_4<L, R> extends _i1.SmartFake implements _i6.Either<L, R> {
  _FakeEither_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [MP2PPurposeSessionRemoteSourceImpl].
///
/// See the documentation for Mockito's code generation for more information.
class MockMP2PPurposeSessionRemoteSourceImpl extends _i1.Mock
    implements _i7.MP2PPurposeSessionRemoteSourceImpl {
  MockMP2PPurposeSessionRemoteSourceImpl() {
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
  _i3.AgoraCallbacksStore get agoraCallbacksStore => (super.noSuchMethod(
        Invocation.getter(#agoraCallbacksStore),
        returnValue: _FakeAgoraCallbacksStore_1(
          this,
          Invocation.getter(#agoraCallbacksStore),
        ),
      ) as _i3.AgoraCallbacksStore);
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
  _i4.RtcEngine get agoraEngine => (super.noSuchMethod(
        Invocation.getter(#agoraEngine),
        returnValue: _FakeRtcEngine_2(
          this,
          Invocation.getter(#agoraEngine),
        ),
      ) as _i4.RtcEngine);
  @override
  _i8.Future<_i5.Response> fetchAgoraToken({required String? channelName}) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchAgoraToken,
          [],
          {#channelName: channelName},
        ),
        returnValue: _i8.Future<_i5.Response>.value(_FakeResponse_3(
          this,
          Invocation.method(
            #fetchAgoraToken,
            [],
            {#channelName: channelName},
          ),
        )),
      ) as _i8.Future<_i5.Response>);
  @override
  _i8.Future<void> joinCall({
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
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  _i8.Future<void> leaveCall() => (super.noSuchMethod(
        Invocation.method(
          #leaveCall,
          [],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  _i8.Future<void> instantiateAgoraSDK() => (super.noSuchMethod(
        Invocation.method(
          #instantiateAgoraSDK,
          [],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  _i8.Future<List<dynamic>> fetchChannelId() => (super.noSuchMethod(
        Invocation.method(
          #fetchChannelId,
          [],
        ),
        returnValue: _i8.Future<List<dynamic>>.value(<dynamic>[]),
      ) as _i8.Future<List<dynamic>>);
  @override
  _i8.Future<dynamic> muteLocalAudioStream() => (super.noSuchMethod(
        Invocation.method(
          #muteLocalAudioStream,
          [],
        ),
        returnValue: _i8.Future<dynamic>.value(),
      ) as _i8.Future<dynamic>);
  @override
  _i8.Future<dynamic> unmuteLocalAudioStream() => (super.noSuchMethod(
        Invocation.method(
          #unmuteLocalAudioStream,
          [],
        ),
        returnValue: _i8.Future<dynamic>.value(),
      ) as _i8.Future<dynamic>);
}

/// A class which mocks [MP2PPurposeSessionContract].
///
/// See the documentation for Mockito's code generation for more information.
class MockMP2PPurposeSessionContract extends _i1.Mock
    implements _i7.MP2PPurposeSessionContract {
  MockMP2PPurposeSessionContract() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Future<_i6.Either<_i9.Failure, _i10.AgoraCallTokenEntity>>
      fetchAgoraToken({required String? channelName}) => (super.noSuchMethod(
            Invocation.method(
              #fetchAgoraToken,
              [],
              {#channelName: channelName},
            ),
            returnValue: _i8.Future<
                    _i6.Either<_i9.Failure, _i10.AgoraCallTokenEntity>>.value(
                _FakeEither_4<_i9.Failure, _i10.AgoraCallTokenEntity>(
              this,
              Invocation.method(
                #fetchAgoraToken,
                [],
                {#channelName: channelName},
              ),
            )),
          ) as _i8.Future<_i6.Either<_i9.Failure, _i10.AgoraCallTokenEntity>>);
  @override
  _i8.Future<_i6.Either<_i9.Failure, _i10.ChannelIdEntity>> fetchChannelId() =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchChannelId,
          [],
        ),
        returnValue:
            _i8.Future<_i6.Either<_i9.Failure, _i10.ChannelIdEntity>>.value(
                _FakeEither_4<_i9.Failure, _i10.ChannelIdEntity>(
          this,
          Invocation.method(
            #fetchChannelId,
            [],
          ),
        )),
      ) as _i8.Future<_i6.Either<_i9.Failure, _i10.ChannelIdEntity>>);
  @override
  _i8.Future<_i6.Either<_i9.Failure, _i10.AgoraSdkStatusEntity>>
      instantiateAgoraSdk() => (super.noSuchMethod(
            Invocation.method(
              #instantiateAgoraSdk,
              [],
            ),
            returnValue: _i8.Future<
                    _i6.Either<_i9.Failure, _i10.AgoraSdkStatusEntity>>.value(
                _FakeEither_4<_i9.Failure, _i10.AgoraSdkStatusEntity>(
              this,
              Invocation.method(
                #instantiateAgoraSdk,
                [],
              ),
            )),
          ) as _i8.Future<_i6.Either<_i9.Failure, _i10.AgoraSdkStatusEntity>>);
  @override
  _i8.Future<_i6.Either<_i9.Failure, _i10.CallStatusEntity>> joinCall(
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
            _i8.Future<_i6.Either<_i9.Failure, _i10.CallStatusEntity>>.value(
                _FakeEither_4<_i9.Failure, _i10.CallStatusEntity>(
          this,
          Invocation.method(
            #joinCall,
            [
              token,
              channelId,
            ],
          ),
        )),
      ) as _i8.Future<_i6.Either<_i9.Failure, _i10.CallStatusEntity>>);
  @override
  _i8.Future<_i6.Either<_i9.Failure, _i10.CallStatusEntity>> leaveCall() =>
      (super.noSuchMethod(
        Invocation.method(
          #leaveCall,
          [],
        ),
        returnValue:
            _i8.Future<_i6.Either<_i9.Failure, _i10.CallStatusEntity>>.value(
                _FakeEither_4<_i9.Failure, _i10.CallStatusEntity>(
          this,
          Invocation.method(
            #leaveCall,
            [],
          ),
        )),
      ) as _i8.Future<_i6.Either<_i9.Failure, _i10.CallStatusEntity>>);
  @override
  _i8.Future<_i6.Either<_i9.Failure, _i10.LocalAudioStreamStatusEntity>>
      muteLocalAudioStream() => (super.noSuchMethod(
            Invocation.method(
              #muteLocalAudioStream,
              [],
            ),
            returnValue: _i8.Future<
                    _i6.Either<_i9.Failure,
                        _i10.LocalAudioStreamStatusEntity>>.value(
                _FakeEither_4<_i9.Failure, _i10.LocalAudioStreamStatusEntity>(
              this,
              Invocation.method(
                #muteLocalAudioStream,
                [],
              ),
            )),
          ) as _i8.Future<
              _i6.Either<_i9.Failure, _i10.LocalAudioStreamStatusEntity>>);
  @override
  _i8.Future<_i6.Either<_i9.Failure, _i10.LocalAudioStreamStatusEntity>>
      unmuteLocalAudioStream() => (super.noSuchMethod(
            Invocation.method(
              #unmuteLocalAudioStream,
              [],
            ),
            returnValue: _i8.Future<
                    _i6.Either<_i9.Failure,
                        _i10.LocalAudioStreamStatusEntity>>.value(
                _FakeEither_4<_i9.Failure, _i10.LocalAudioStreamStatusEntity>(
              this,
              Invocation.method(
                #unmuteLocalAudioStream,
                [],
              ),
            )),
          ) as _i8.Future<
              _i6.Either<_i9.Failure, _i10.LocalAudioStreamStatusEntity>>);
}
