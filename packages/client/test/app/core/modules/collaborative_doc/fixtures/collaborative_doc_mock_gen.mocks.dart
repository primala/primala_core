// Mocks generated by Mockito 5.4.1 from annotations
// in primala/test/app/core/modules/collaborative_doc/fixtures/collaborative_doc_mock_gen.dart.
// Do not manually edit this file.

// @dart=2.19

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mobx/mobx.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:primala/app/core/error/failure.dart' as _i8;
import 'package:primala/app/core/interfaces/logic.dart' as _i9;
import 'package:primala/app/core/modules/collaborative_doc/domain/domain.dart'
    as _i3;
import 'package:primala_backend/working_collaborative_documents.dart' as _i7;

import 'collaborative_doc_mock_gen.dart' as _i5;

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

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCollaborativeDocContract_1 extends _i1.SmartFake
    implements _i3.CollaborativeDocContract {
  _FakeCollaborativeDocContract_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUpdateUserDelta_2 extends _i1.SmartFake
    implements _i3.UpdateUserDelta {
  _FakeUpdateUserDelta_2(
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

class _FakeUpdateUserPresence_4 extends _i1.SmartFake
    implements _i3.UpdateUserPresence {
  _FakeUpdateUserPresence_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGetCollaborativeDocContent_5 extends _i1.SmartFake
    implements _i3.GetCollaborativeDocContent {
  _FakeGetCollaborativeDocContent_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUpdateCollaborativeDoc_6 extends _i1.SmartFake
    implements _i3.UpdateCollaborativeDoc {
  _FakeUpdateCollaborativeDoc_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCreateCollaborativeDoc_7 extends _i1.SmartFake
    implements _i3.CreateCollaborativeDoc {
  _FakeCreateCollaborativeDoc_7(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGetCollaboratorDocInfo_8 extends _i1.SmartFake
    implements _i3.GetCollaboratorDocInfo {
  _FakeGetCollaboratorDocInfo_8(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [MCollaborativeDocRemoteSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockMCollaborativeDocRemoteSource extends _i1.Mock
    implements _i5.MCollaborativeDocRemoteSource {
  MockMCollaborativeDocRemoteSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Stream<_i7.DocInfoContent> getCollaborativeDocContent() =>
      (super.noSuchMethod(
        Invocation.method(
          #getCollaborativeDocContent,
          [],
        ),
        returnValue: _i6.Stream<_i7.DocInfoContent>.empty(),
      ) as _i6.Stream<_i7.DocInfoContent>);
  @override
  _i6.Stream<_i7.CollaboratorDocInfo> getCollaboratorDocInfo() =>
      (super.noSuchMethod(
        Invocation.method(
          #getCollaboratorDocInfo,
          [],
        ),
        returnValue: _i6.Stream<_i7.CollaboratorDocInfo>.empty(),
      ) as _i6.Stream<_i7.CollaboratorDocInfo>);
  @override
  _i6.Future<List<dynamic>> createCollaborativeDoc(
          {required String? docType}) =>
      (super.noSuchMethod(
        Invocation.method(
          #createCollaborativeDoc,
          [],
          {#docType: docType},
        ),
        returnValue: _i6.Future<List<dynamic>>.value(<dynamic>[]),
      ) as _i6.Future<List<dynamic>>);
  @override
  _i6.Future<void> updateUserPresence({required bool? updatedUserPresence}) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUserPresence,
          [],
          {#updatedUserPresence: updatedUserPresence},
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> updateUserDelta({required int? updatedDelta}) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUserDelta,
          [],
          {#updatedDelta: updatedDelta},
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> updateCollaborativeDoc({required String? newContent}) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateCollaborativeDoc,
          [],
          {#newContent: newContent},
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
}

/// A class which mocks [MCollaborativeDocContract].
///
/// See the documentation for Mockito's code generation for more information.
class MockMCollaborativeDocContract extends _i1.Mock
    implements _i5.MCollaborativeDocContract {
  MockMCollaborativeDocContract() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<_i2.Either<_i8.Failure, _i3.CollaborativeDocContentEntity>>
      getCollaborativeDocContent() => (super.noSuchMethod(
            Invocation.method(
              #getCollaborativeDocContent,
              [],
            ),
            returnValue: _i6.Future<
                    _i2.Either<_i8.Failure,
                        _i3.CollaborativeDocContentEntity>>.value(
                _FakeEither_0<_i8.Failure, _i3.CollaborativeDocContentEntity>(
              this,
              Invocation.method(
                #getCollaborativeDocContent,
                [],
              ),
            )),
          ) as _i6.Future<
              _i2.Either<_i8.Failure, _i3.CollaborativeDocContentEntity>>);
  @override
  _i6.Future<
          _i2.Either<_i8.Failure, _i3.CollaborativeDocCollaboratorInfoEntity>>
      getCollaboratorDocInfo() => (super.noSuchMethod(
            Invocation.method(
              #getCollaboratorDocInfo,
              [],
            ),
            returnValue: _i6.Future<
                    _i2.Either<_i8.Failure,
                        _i3.CollaborativeDocCollaboratorInfoEntity>>.value(
                _FakeEither_0<_i8.Failure,
                    _i3.CollaborativeDocCollaboratorInfoEntity>(
              this,
              Invocation.method(
                #getCollaboratorDocInfo,
                [],
              ),
            )),
          ) as _i6.Future<
              _i2.Either<_i8.Failure,
                  _i3.CollaborativeDocCollaboratorInfoEntity>>);
  @override
  _i6.Future<_i2.Either<_i8.Failure, _i3.CollaborativeDocCreationStatusEntity>>
      createCollaborativeDoc({required String? docType}) => (super.noSuchMethod(
            Invocation.method(
              #createCollaborativeDoc,
              [],
              {#docType: docType},
            ),
            returnValue: _i6.Future<
                    _i2.Either<_i8.Failure,
                        _i3.CollaborativeDocCreationStatusEntity>>.value(
                _FakeEither_0<_i8.Failure,
                    _i3.CollaborativeDocCreationStatusEntity>(
              this,
              Invocation.method(
                #createCollaborativeDoc,
                [],
                {#docType: docType},
              ),
            )),
          ) as _i6.Future<
              _i2.Either<_i8.Failure,
                  _i3.CollaborativeDocCreationStatusEntity>>);
  @override
  _i6.Future<_i2.Either<_i8.Failure, _i3.CollaborativeDocUpdateStatusEntity>>
      updateCollaborativeDoc({required String? newContent}) =>
          (super.noSuchMethod(
            Invocation.method(
              #updateCollaborativeDoc,
              [],
              {#newContent: newContent},
            ),
            returnValue: _i6.Future<
                    _i2.Either<_i8.Failure,
                        _i3.CollaborativeDocUpdateStatusEntity>>.value(
                _FakeEither_0<_i8.Failure,
                    _i3.CollaborativeDocUpdateStatusEntity>(
              this,
              Invocation.method(
                #updateCollaborativeDoc,
                [],
                {#newContent: newContent},
              ),
            )),
          ) as _i6.Future<
              _i2.Either<_i8.Failure, _i3.CollaborativeDocUpdateStatusEntity>>);
  @override
  _i6.Future<
          _i2.Either<_i8.Failure, _i3.CollaborativeDocDeltaUpdaterStatusEntity>>
      updateUserDelta({required int? newDelta}) => (super.noSuchMethod(
            Invocation.method(
              #updateUserDelta,
              [],
              {#newDelta: newDelta},
            ),
            returnValue: _i6.Future<
                    _i2.Either<_i8.Failure,
                        _i3.CollaborativeDocDeltaUpdaterStatusEntity>>.value(
                _FakeEither_0<_i8.Failure,
                    _i3.CollaborativeDocDeltaUpdaterStatusEntity>(
              this,
              Invocation.method(
                #updateUserDelta,
                [],
                {#newDelta: newDelta},
              ),
            )),
          ) as _i6.Future<
              _i2.Either<_i8.Failure,
                  _i3.CollaborativeDocDeltaUpdaterStatusEntity>>);
  @override
  _i6.Future<
          _i2.Either<_i8.Failure,
              _i3.CollaborativeDocPresenceUpdaterStatusEntity>>
      updateUserPresence({required bool? newPresence}) => (super.noSuchMethod(
            Invocation.method(
              #updateUserPresence,
              [],
              {#newPresence: newPresence},
            ),
            returnValue: _i6.Future<
                    _i2.Either<_i8.Failure,
                        _i3.CollaborativeDocPresenceUpdaterStatusEntity>>.value(
                _FakeEither_0<_i8.Failure,
                    _i3.CollaborativeDocPresenceUpdaterStatusEntity>(
              this,
              Invocation.method(
                #updateUserPresence,
                [],
                {#newPresence: newPresence},
              ),
            )),
          ) as _i6.Future<
              _i2.Either<_i8.Failure,
                  _i3.CollaborativeDocPresenceUpdaterStatusEntity>>);
}

/// A class which mocks [MGetCollaborativeDocContent].
///
/// See the documentation for Mockito's code generation for more information.
class MockMGetCollaborativeDocContent extends _i1.Mock
    implements _i5.MGetCollaborativeDocContent {
  MockMGetCollaborativeDocContent() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.CollaborativeDocContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeCollaborativeDocContract_1(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i3.CollaborativeDocContract);
  @override
  _i6.Future<_i2.Either<_i8.Failure, _i3.CollaborativeDocContentEntity>> call(
          _i9.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i6.Future<
                _i2.Either<_i8.Failure,
                    _i3.CollaborativeDocContentEntity>>.value(
            _FakeEither_0<_i8.Failure, _i3.CollaborativeDocContentEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i6
          .Future<_i2.Either<_i8.Failure, _i3.CollaborativeDocContentEntity>>);
}

/// A class which mocks [MGetCollaboratorDocInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockMGetCollaboratorDocInfo extends _i1.Mock
    implements _i5.MGetCollaboratorDocInfo {
  MockMGetCollaboratorDocInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.CollaborativeDocContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeCollaborativeDocContract_1(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i3.CollaborativeDocContract);
  @override
  _i6.Future<
      _i2.Either<_i8.Failure, _i3.CollaborativeDocCollaboratorInfoEntity>> call(
          _i9.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i6.Future<
                _i2.Either<_i8.Failure,
                    _i3.CollaborativeDocCollaboratorInfoEntity>>.value(
            _FakeEither_0<_i8.Failure,
                _i3.CollaborativeDocCollaboratorInfoEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i6.Future<
          _i2.Either<_i8.Failure, _i3.CollaborativeDocCollaboratorInfoEntity>>);
}

/// A class which mocks [MUpdateCollaborativeDoc].
///
/// See the documentation for Mockito's code generation for more information.
class MockMUpdateCollaborativeDoc extends _i1.Mock
    implements _i5.MUpdateCollaborativeDoc {
  MockMUpdateCollaborativeDoc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.CollaborativeDocContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeCollaborativeDocContract_1(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i3.CollaborativeDocContract);
  @override
  _i6.Future<
      _i2.Either<_i8.Failure, _i3.CollaborativeDocUpdateStatusEntity>> call(
          _i3.UpdateCollaborativeDocParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i6.Future<
                _i2.Either<_i8.Failure,
                    _i3.CollaborativeDocUpdateStatusEntity>>.value(
            _FakeEither_0<_i8.Failure, _i3.CollaborativeDocUpdateStatusEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i6.Future<
          _i2.Either<_i8.Failure, _i3.CollaborativeDocUpdateStatusEntity>>);
}

/// A class which mocks [MCreateCollaborativeDoc].
///
/// See the documentation for Mockito's code generation for more information.
class MockMCreateCollaborativeDoc extends _i1.Mock
    implements _i5.MCreateCollaborativeDoc {
  MockMCreateCollaborativeDoc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.CollaborativeDocContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeCollaborativeDocContract_1(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i3.CollaborativeDocContract);
  @override
  _i6.Future<
      _i2.Either<_i8.Failure, _i3.CollaborativeDocCreationStatusEntity>> call(
          _i3.CreateCollaborativeDocParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i6.Future<
            _i2.Either<_i8.Failure,
                _i3.CollaborativeDocCreationStatusEntity>>.value(_FakeEither_0<
            _i8.Failure, _i3.CollaborativeDocCreationStatusEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i6.Future<
          _i2.Either<_i8.Failure, _i3.CollaborativeDocCreationStatusEntity>>);
}

/// A class which mocks [MUpdateUserDelta].
///
/// See the documentation for Mockito's code generation for more information.
class MockMUpdateUserDelta extends _i1.Mock implements _i5.MUpdateUserDelta {
  MockMUpdateUserDelta() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.CollaborativeDocContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeCollaborativeDocContract_1(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i3.CollaborativeDocContract);
  @override
  _i6.Future<
          _i2.Either<_i8.Failure, _i3.CollaborativeDocDeltaUpdaterStatusEntity>>
      call(_i3.UpdateUserDeltaParams? params) => (super.noSuchMethod(
            Invocation.method(
              #call,
              [params],
            ),
            returnValue: _i6.Future<
                    _i2.Either<_i8.Failure,
                        _i3.CollaborativeDocDeltaUpdaterStatusEntity>>.value(
                _FakeEither_0<_i8.Failure,
                    _i3.CollaborativeDocDeltaUpdaterStatusEntity>(
              this,
              Invocation.method(
                #call,
                [params],
              ),
            )),
          ) as _i6.Future<
              _i2.Either<_i8.Failure,
                  _i3.CollaborativeDocDeltaUpdaterStatusEntity>>);
}

/// A class which mocks [MUpdateUserPresence].
///
/// See the documentation for Mockito's code generation for more information.
class MockMUpdateUserPresence extends _i1.Mock
    implements _i5.MUpdateUserPresence {
  MockMUpdateUserPresence() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.CollaborativeDocContract get contract => (super.noSuchMethod(
        Invocation.getter(#contract),
        returnValue: _FakeCollaborativeDocContract_1(
          this,
          Invocation.getter(#contract),
        ),
      ) as _i3.CollaborativeDocContract);
  @override
  _i6.Future<
          _i2.Either<_i8.Failure,
              _i3.CollaborativeDocPresenceUpdaterStatusEntity>>
      call(_i3.UpdateUserPresenceParams? params) => (super.noSuchMethod(
            Invocation.method(
              #call,
              [params],
            ),
            returnValue: _i6.Future<
                    _i2.Either<_i8.Failure,
                        _i3.CollaborativeDocPresenceUpdaterStatusEntity>>.value(
                _FakeEither_0<_i8.Failure,
                    _i3.CollaborativeDocPresenceUpdaterStatusEntity>(
              this,
              Invocation.method(
                #call,
                [params],
              ),
            )),
          ) as _i6.Future<
              _i2.Either<_i8.Failure,
                  _i3.CollaborativeDocPresenceUpdaterStatusEntity>>);
}

/// A class which mocks [MUpdateUserDeltaGetterStore].
///
/// See the documentation for Mockito's code generation for more information.
class MockMUpdateUserDeltaGetterStore extends _i1.Mock
    implements _i5.MUpdateUserDeltaGetterStore {
  MockMUpdateUserDeltaGetterStore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.UpdateUserDelta get logic => (super.noSuchMethod(
        Invocation.getter(#logic),
        returnValue: _FakeUpdateUserDelta_2(
          this,
          Invocation.getter(#logic),
        ),
      ) as _i3.UpdateUserDelta);
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
  _i6.Future<
          _i2.Either<_i8.Failure, _i3.CollaborativeDocDeltaUpdaterStatusEntity>>
      call(_i3.UpdateUserDeltaParams? params) => (super.noSuchMethod(
            Invocation.method(
              #call,
              [params],
            ),
            returnValue: _i6.Future<
                    _i2.Either<_i8.Failure,
                        _i3.CollaborativeDocDeltaUpdaterStatusEntity>>.value(
                _FakeEither_0<_i8.Failure,
                    _i3.CollaborativeDocDeltaUpdaterStatusEntity>(
              this,
              Invocation.method(
                #call,
                [params],
              ),
            )),
          ) as _i6.Future<
              _i2.Either<_i8.Failure,
                  _i3.CollaborativeDocDeltaUpdaterStatusEntity>>);
}

/// A class which mocks [MUpdateUserPresenceGetterStore].
///
/// See the documentation for Mockito's code generation for more information.
class MockMUpdateUserPresenceGetterStore extends _i1.Mock
    implements _i5.MUpdateUserPresenceGetterStore {
  MockMUpdateUserPresenceGetterStore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.UpdateUserPresence get logic => (super.noSuchMethod(
        Invocation.getter(#logic),
        returnValue: _FakeUpdateUserPresence_4(
          this,
          Invocation.getter(#logic),
        ),
      ) as _i3.UpdateUserPresence);
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
  _i6.Future<
          _i2.Either<_i8.Failure,
              _i3.CollaborativeDocPresenceUpdaterStatusEntity>>
      call(_i3.UpdateUserPresenceParams? params) => (super.noSuchMethod(
            Invocation.method(
              #call,
              [params],
            ),
            returnValue: _i6.Future<
                    _i2.Either<_i8.Failure,
                        _i3.CollaborativeDocPresenceUpdaterStatusEntity>>.value(
                _FakeEither_0<_i8.Failure,
                    _i3.CollaborativeDocPresenceUpdaterStatusEntity>(
              this,
              Invocation.method(
                #call,
                [params],
              ),
            )),
          ) as _i6.Future<
              _i2.Either<_i8.Failure,
                  _i3.CollaborativeDocPresenceUpdaterStatusEntity>>);
}

/// A class which mocks [MGetCollaborativeDocContentGetterStore].
///
/// See the documentation for Mockito's code generation for more information.
class MockMGetCollaborativeDocContentGetterStore extends _i1.Mock
    implements _i5.MGetCollaborativeDocContentGetterStore {
  MockMGetCollaborativeDocContentGetterStore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.GetCollaborativeDocContent get logic => (super.noSuchMethod(
        Invocation.getter(#logic),
        returnValue: _FakeGetCollaborativeDocContent_5(
          this,
          Invocation.getter(#logic),
        ),
      ) as _i3.GetCollaborativeDocContent);
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
  _i6.Future<_i2.Either<_i8.Failure, _i3.CollaborativeDocContentEntity>>
      call() => (super.noSuchMethod(
            Invocation.method(
              #call,
              [],
            ),
            returnValue: _i6.Future<
                    _i2.Either<_i8.Failure,
                        _i3.CollaborativeDocContentEntity>>.value(
                _FakeEither_0<_i8.Failure, _i3.CollaborativeDocContentEntity>(
              this,
              Invocation.method(
                #call,
                [],
              ),
            )),
          ) as _i6.Future<
              _i2.Either<_i8.Failure, _i3.CollaborativeDocContentEntity>>);
}

/// A class which mocks [MUpdateCollaborativeDocGetterStore].
///
/// See the documentation for Mockito's code generation for more information.
class MockMUpdateCollaborativeDocGetterStore extends _i1.Mock
    implements _i5.MUpdateCollaborativeDocGetterStore {
  MockMUpdateCollaborativeDocGetterStore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.UpdateCollaborativeDoc get logic => (super.noSuchMethod(
        Invocation.getter(#logic),
        returnValue: _FakeUpdateCollaborativeDoc_6(
          this,
          Invocation.getter(#logic),
        ),
      ) as _i3.UpdateCollaborativeDoc);
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
  _i6.Future<
      _i2.Either<_i8.Failure, _i3.CollaborativeDocUpdateStatusEntity>> call(
          _i3.UpdateCollaborativeDocParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i6.Future<
                _i2.Either<_i8.Failure,
                    _i3.CollaborativeDocUpdateStatusEntity>>.value(
            _FakeEither_0<_i8.Failure, _i3.CollaborativeDocUpdateStatusEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i6.Future<
          _i2.Either<_i8.Failure, _i3.CollaborativeDocUpdateStatusEntity>>);
}

/// A class which mocks [MCreateCollaborativeDocGetterStore].
///
/// See the documentation for Mockito's code generation for more information.
class MockMCreateCollaborativeDocGetterStore extends _i1.Mock
    implements _i5.MCreateCollaborativeDocGetterStore {
  MockMCreateCollaborativeDocGetterStore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.CreateCollaborativeDoc get logic => (super.noSuchMethod(
        Invocation.getter(#logic),
        returnValue: _FakeCreateCollaborativeDoc_7(
          this,
          Invocation.getter(#logic),
        ),
      ) as _i3.CreateCollaborativeDoc);
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
  _i6.Future<
      _i2.Either<_i8.Failure, _i3.CollaborativeDocCreationStatusEntity>> call(
          _i3.CreateCollaborativeDocParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i6.Future<
            _i2.Either<_i8.Failure,
                _i3.CollaborativeDocCreationStatusEntity>>.value(_FakeEither_0<
            _i8.Failure, _i3.CollaborativeDocCreationStatusEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i6.Future<
          _i2.Either<_i8.Failure, _i3.CollaborativeDocCreationStatusEntity>>);
}

/// A class which mocks [MGetCollaboratorDocInfoGetterStore].
///
/// See the documentation for Mockito's code generation for more information.
class MockMGetCollaboratorDocInfoGetterStore extends _i1.Mock
    implements _i5.MGetCollaboratorDocInfoGetterStore {
  MockMGetCollaboratorDocInfoGetterStore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.GetCollaboratorDocInfo get logic => (super.noSuchMethod(
        Invocation.getter(#logic),
        returnValue: _FakeGetCollaboratorDocInfo_8(
          this,
          Invocation.getter(#logic),
        ),
      ) as _i3.GetCollaboratorDocInfo);
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
  _i6.Future<
      _i2.Either<_i8.Failure,
          _i3.CollaborativeDocCollaboratorInfoEntity>> call() =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [],
        ),
        returnValue: _i6.Future<
                _i2.Either<_i8.Failure,
                    _i3.CollaborativeDocCollaboratorInfoEntity>>.value(
            _FakeEither_0<_i8.Failure,
                _i3.CollaborativeDocCollaboratorInfoEntity>(
          this,
          Invocation.method(
            #call,
            [],
          ),
        )),
      ) as _i6.Future<
          _i2.Either<_i8.Failure, _i3.CollaborativeDocCollaboratorInfoEntity>>);
}
