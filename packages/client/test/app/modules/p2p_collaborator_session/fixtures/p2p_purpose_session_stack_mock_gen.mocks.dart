// Mocks generated by Mockito 5.4.1 from annotations
// in primala/test/app/modules/p2p_collaborator_session/fixtures/p2p_purpose_session_stack_mock_gen.dart.
// Do not manually edit this file.

// @dart=2.19

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i9;

import 'package:agora_rtc_engine/agora_rtc_engine.dart' as _i4;
import 'package:dartz/dartz.dart' as _i6;
import 'package:http/http.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:primala/app/core/error/failure.dart' as _i10;
import 'package:primala/app/core/interfaces/logic.dart' as _i11;
import 'package:primala/app/modules/p2p_purpose_session/domain/domain.dart'
    as _i7;
import 'package:primala/app/modules/p2p_purpose_session/presentation/mobx/main/main.dart'
    as _i3;
import 'package:supabase_flutter/supabase_flutter.dart' as _i2;

import 'p2p_purpose_session_stack_mock_gen.dart' as _i8;

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

class _FakeP2PPurposeSessionContract_5 extends _i1.SmartFake
    implements _i7.P2PPurposeSessionContract {
  _FakeP2PPurposeSessionContract_5(
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
    implements _i8.MP2PPurposeSessionRemoteSourceImpl {
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
  _i9.Future<_i5.Response> fetchAgoraToken({required String? channelName}) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchAgoraToken,
          [],
          {#channelName: channelName},
        ),
        returnValue: _i9.Future<_i5.Response>.value(_FakeResponse_3(
          this,
          Invocation.method(
            #fetchAgoraToken,
            [],
            {#channelName: channelName},
          ),
        )),
      ) as _i9.Future<_i5.Response>);
  @override
  _i9.Future<void> joinCall({
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
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  _i9.Future<void> leaveCall() => (super.noSuchMethod(
        Invocation.method(
          #leaveCall,
          [],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  _i9.Future<void> instantiateAgoraSDK() => (super.noSuchMethod(
        Invocation.method(
          #instantiateAgoraSDK,
          [],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  _i9.Future<List<dynamic>> fetchCollaboratorInfo() => (super.noSuchMethod(
        Invocation.method(
          #fetchCollaboratorInfo,
          [],
        ),
        returnValue: _i9.Future<List<dynamic>>.value(<dynamic>[]),
      ) as _i9.Future<List<dynamic>>);
  @override
  _i9.Future<dynamic> muteLocalAudioStream() => (super.noSuchMethod(
        Invocation.method(
          #muteLocalAudioStream,
          [],
        ),
        returnValue: _i9.Future<dynamic>.value(),
      ) as _i9.Future<dynamic>);
  @override
  _i9.Future<dynamic> unmuteLocalAudioStream() => (super.noSuchMethod(
        Invocation.method(
          #unmuteLocalAudioStream,
          [],
        ),
        returnValue: _i9.Future<dynamic>.value(),
      ) as _i9.Future<dynamic>);
}

/// A class which mocks [MP2PPurposeSessionContract].
///
/// See the documentation for Mockito's code generation for more information.
class MockMP2PPurposeSessionContract extends _i1.Mock
    implements _i8.MP2PPurposeSessionContract {
  MockMP2PPurposeSessionContract() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i9.Future<_i6.Either<_i10.Failure, _i7.AgoraCallTokenEntity>>
      fetchAgoraToken({required String? channelName}) => (super.noSuchMethod(
            Invocation.method(
              #fetchAgoraToken,
              [],
              {#channelName: channelName},
            ),
            returnValue: _i9.Future<
                    _i6.Either<_i10.Failure, _i7.AgoraCallTokenEntity>>.value(
                _FakeEither_4<_i10.Failure, _i7.AgoraCallTokenEntity>(
              this,
              Invocation.method(
                #fetchAgoraToken,
                [],
                {#channelName: channelName},
              ),
            )),
          ) as _i9.Future<_i6.Either<_i10.Failure, _i7.AgoraCallTokenEntity>>);
  @override
  _i9.Future<_i6.Either<_i10.Failure, _i7.ChannelIdEntity>> fetchChannelId() =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchChannelId,
          [],
        ),
        returnValue:
            _i9.Future<_i6.Either<_i10.Failure, _i7.ChannelIdEntity>>.value(
                _FakeEither_4<_i10.Failure, _i7.ChannelIdEntity>(
          this,
          Invocation.method(
            #fetchChannelId,
            [],
          ),
        )),
      ) as _i9.Future<_i6.Either<_i10.Failure, _i7.ChannelIdEntity>>);
  @override
  _i9.Future<_i6.Either<_i10.Failure, _i7.AgoraSdkStatusEntity>>
      instantiateAgoraSdk() => (super.noSuchMethod(
            Invocation.method(
              #instantiateAgoraSdk,
              [],
            ),
            returnValue: _i9.Future<
                    _i6.Either<_i10.Failure, _i7.AgoraSdkStatusEntity>>.value(
                _FakeEither_4<_i10.Failure, _i7.AgoraSdkStatusEntity>(
              this,
              Invocation.method(
                #instantiateAgoraSdk,
                [],
              ),
            )),
          ) as _i9.Future<_i6.Either<_i10.Failure, _i7.AgoraSdkStatusEntity>>);
  @override
  _i9.Future<_i6.Either<_i10.Failure, _i7.CallStatusEntity>> joinCall(
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
            _i9.Future<_i6.Either<_i10.Failure, _i7.CallStatusEntity>>.value(
                _FakeEither_4<_i10.Failure, _i7.CallStatusEntity>(
          this,
          Invocation.method(
            #joinCall,
            [
              token,
              channelId,
            ],
          ),
        )),
      ) as _i9.Future<_i6.Either<_i10.Failure, _i7.CallStatusEntity>>);
  @override
  _i9.Future<_i6.Either<_i10.Failure, _i7.CallStatusEntity>> leaveCall() =>
      (super.noSuchMethod(
        Invocation.method(
          #leaveCall,
          [],
        ),
        returnValue:
            _i9.Future<_i6.Either<_i10.Failure, _i7.CallStatusEntity>>.value(
                _FakeEither_4<_i10.Failure, _i7.CallStatusEntity>(
          this,
          Invocation.method(
            #leaveCall,
            [],
          ),
        )),
      ) as _i9.Future<_i6.Either<_i10.Failure, _i7.CallStatusEntity>>);
  @override
  _i9.Future<_i6.Either<_i10.Failure, _i7.LocalAudioStreamStatusEntity>>
      muteLocalAudioStream() => (super.noSuchMethod(
            Invocation.method(
              #muteLocalAudioStream,
              [],
            ),
            returnValue: _i9.Future<
                    _i6.Either<_i10.Failure,
                        _i7.LocalAudioStreamStatusEntity>>.value(
                _FakeEither_4<_i10.Failure, _i7.LocalAudioStreamStatusEntity>(
              this,
              Invocation.method(
                #muteLocalAudioStream,
                [],
              ),
            )),
          ) as _i9.Future<
              _i6.Either<_i10.Failure, _i7.LocalAudioStreamStatusEntity>>);
  @override
  _i9.Future<_i6.Either<_i10.Failure, _i7.LocalAudioStreamStatusEntity>>
      unmuteLocalAudioStream() => (super.noSuchMethod(
            Invocation.method(
              #unmuteLocalAudioStream,
              [],
            ),
            returnValue: _i9.Future<
                    _i6.Either<_i10.Failure,
                        _i7.LocalAudioStreamStatusEntity>>.value(
                _FakeEither_4<_i10.Failure, _i7.LocalAudioStreamStatusEntity>(
              this,
              Invocation.method(
                #unmuteLocalAudioStream,
                [],
              ),
            )),
          ) as _i9.Future<
              _i6.Either<_i10.Failure, _i7.LocalAudioStreamStatusEntity>>);
  @override
  _i9.Future<_i6.Either<_i10.Failure, _i7.WhoGetsTheQuestionEntity>>
      checkIfUserHasTheQuestion() => (super.noSuchMethod(
            Invocation.method(
              #checkIfUserHasTheQuestion,
              [],
            ),
            returnValue: _i9.Future<
                    _i6.Either<_i10.Failure,
                        _i7.WhoGetsTheQuestionEntity>>.value(
                _FakeEither_4<_i10.Failure, _i7.WhoGetsTheQuestionEntity>(
              this,
              Invocation.method(
                #checkIfUserHasTheQuestion,
                [],
              ),
            )),
          ) as _i9
              .Future<_i6.Either<_i10.Failure, _i7.WhoGetsTheQuestionEntity>>);
}

/// A class which mocks [MCheckIfUserHasTheQuestion].
///
/// See the documentation for Mockito's code generation for more information.
class MockMCheckIfUserHasTheQuestion extends _i1.Mock
    implements _i8.MCheckIfUserHasTheQuestion {
  MockMCheckIfUserHasTheQuestion() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.P2PPurposeSessionContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeP2PPurposeSessionContract_5(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i7.P2PPurposeSessionContract);
  @override
  _i9.Future<_i6.Either<_i10.Failure, _i7.WhoGetsTheQuestionEntity>> call(
          _i11.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i9.Future<
                _i6.Either<_i10.Failure, _i7.WhoGetsTheQuestionEntity>>.value(
            _FakeEither_4<_i10.Failure, _i7.WhoGetsTheQuestionEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i9.Future<_i6.Either<_i10.Failure, _i7.WhoGetsTheQuestionEntity>>);
}

/// A class which mocks [MFetchAgoraToken].
///
/// See the documentation for Mockito's code generation for more information.
class MockMFetchAgoraToken extends _i1.Mock implements _i8.MFetchAgoraToken {
  MockMFetchAgoraToken() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.P2PPurposeSessionContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeP2PPurposeSessionContract_5(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i7.P2PPurposeSessionContract);
  @override
  _i9.Future<_i6.Either<_i10.Failure, _i7.AgoraCallTokenEntity>> call(
          _i7.FetchAgoraTokenParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i9.Future<
                _i6.Either<_i10.Failure, _i7.AgoraCallTokenEntity>>.value(
            _FakeEither_4<_i10.Failure, _i7.AgoraCallTokenEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i9.Future<_i6.Either<_i10.Failure, _i7.AgoraCallTokenEntity>>);
}

/// A class which mocks [MFetchChannelId].
///
/// See the documentation for Mockito's code generation for more information.
class MockMFetchChannelId extends _i1.Mock implements _i8.MFetchChannelId {
  MockMFetchChannelId() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.P2PPurposeSessionContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeP2PPurposeSessionContract_5(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i7.P2PPurposeSessionContract);
  @override
  _i9.Future<_i6.Either<_i10.Failure, _i7.ChannelIdEntity>> call(
          _i11.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue:
            _i9.Future<_i6.Either<_i10.Failure, _i7.ChannelIdEntity>>.value(
                _FakeEither_4<_i10.Failure, _i7.ChannelIdEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i9.Future<_i6.Either<_i10.Failure, _i7.ChannelIdEntity>>);
}

/// A class which mocks [MInstantiateAgoraSdk].
///
/// See the documentation for Mockito's code generation for more information.
class MockMInstantiateAgoraSdk extends _i1.Mock
    implements _i8.MInstantiateAgoraSdk {
  MockMInstantiateAgoraSdk() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.P2PPurposeSessionContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeP2PPurposeSessionContract_5(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i7.P2PPurposeSessionContract);
  @override
  _i9.Future<_i6.Either<_i10.Failure, _i7.AgoraSdkStatusEntity>> call(
          _i11.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i9.Future<
                _i6.Either<_i10.Failure, _i7.AgoraSdkStatusEntity>>.value(
            _FakeEither_4<_i10.Failure, _i7.AgoraSdkStatusEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i9.Future<_i6.Either<_i10.Failure, _i7.AgoraSdkStatusEntity>>);
}

/// A class which mocks [MJoinCall].
///
/// See the documentation for Mockito's code generation for more information.
class MockMJoinCall extends _i1.Mock implements _i8.MJoinCall {
  MockMJoinCall() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.P2PPurposeSessionContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeP2PPurposeSessionContract_5(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i7.P2PPurposeSessionContract);
  @override
  _i9.Future<_i6.Either<_i10.Failure, _i7.CallStatusEntity>> call(
          _i7.JoinCallParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue:
            _i9.Future<_i6.Either<_i10.Failure, _i7.CallStatusEntity>>.value(
                _FakeEither_4<_i10.Failure, _i7.CallStatusEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i9.Future<_i6.Either<_i10.Failure, _i7.CallStatusEntity>>);
}

/// A class which mocks [MLeaveCall].
///
/// See the documentation for Mockito's code generation for more information.
class MockMLeaveCall extends _i1.Mock implements _i8.MLeaveCall {
  MockMLeaveCall() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.P2PPurposeSessionContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeP2PPurposeSessionContract_5(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i7.P2PPurposeSessionContract);
  @override
  _i9.Future<_i6.Either<_i10.Failure, _i7.CallStatusEntity>> call(
          _i11.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue:
            _i9.Future<_i6.Either<_i10.Failure, _i7.CallStatusEntity>>.value(
                _FakeEither_4<_i10.Failure, _i7.CallStatusEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i9.Future<_i6.Either<_i10.Failure, _i7.CallStatusEntity>>);
}

/// A class which mocks [MMuteLocalAudioStream].
///
/// See the documentation for Mockito's code generation for more information.
class MockMMuteLocalAudioStream extends _i1.Mock
    implements _i8.MMuteLocalAudioStream {
  MockMMuteLocalAudioStream() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.P2PPurposeSessionContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeP2PPurposeSessionContract_5(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i7.P2PPurposeSessionContract);
  @override
  _i9.Future<_i6.Either<_i10.Failure, _i7.LocalAudioStreamStatusEntity>> call(
          _i11.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i9.Future<
                _i6.Either<_i10.Failure,
                    _i7.LocalAudioStreamStatusEntity>>.value(
            _FakeEither_4<_i10.Failure, _i7.LocalAudioStreamStatusEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i9
          .Future<_i6.Either<_i10.Failure, _i7.LocalAudioStreamStatusEntity>>);
}

/// A class which mocks [MUnmuteLocalAudioStream].
///
/// See the documentation for Mockito's code generation for more information.
class MockMUnmuteLocalAudioStream extends _i1.Mock
    implements _i8.MUnmuteLocalAudioStream {
  MockMUnmuteLocalAudioStream() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.P2PPurposeSessionContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeP2PPurposeSessionContract_5(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i7.P2PPurposeSessionContract);
  @override
  _i9.Future<_i6.Either<_i10.Failure, _i7.LocalAudioStreamStatusEntity>> call(
          _i11.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i9.Future<
                _i6.Either<_i10.Failure,
                    _i7.LocalAudioStreamStatusEntity>>.value(
            _FakeEither_4<_i10.Failure, _i7.LocalAudioStreamStatusEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i9
          .Future<_i6.Either<_i10.Failure, _i7.LocalAudioStreamStatusEntity>>);
}
