// Mocks generated by Mockito 5.4.0 from annotations
// in primala/test/app/modules/p2p_collaborator_pool/fixtures/p2p_collaborator_pool_stack_mock_gen.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:primala/app/core/error/failure.dart' as _i5;
import 'package:primala/app/modules/p2p_collaborator_pool/domain/entities/entities.dart'
    as _i6;

import 'p2p_collaborator_pool_stack_mock_gen.dart' as _i3;

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

/// A class which mocks [MockMP2PCollaboratorPoolContract].
///
/// See the documentation for Mockito's code generation for more information.
class MockMockMP2PCollaboratorPoolContract extends _i1.Mock
    implements _i3.MockMP2PCollaboratorPoolContract {
  MockMockMP2PCollaboratorPoolContract() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.CollaboratorPhraseValidationEntity>>
      validateQuery(String? query) => (super.noSuchMethod(
            Invocation.method(
              #validateQuery,
              [query],
            ),
            returnValue: _i4.Future<
                    _i2.Either<_i5.Failure,
                        _i6.CollaboratorPhraseValidationEntity>>.value(
                _FakeEither_0<_i5.Failure,
                    _i6.CollaboratorPhraseValidationEntity>(
              this,
              Invocation.method(
                #validateQuery,
                [query],
              ),
            )),
          ) as _i4.Future<
              _i2.Either<_i5.Failure, _i6.CollaboratorPhraseValidationEntity>>);
  @override
  _i4.Future<
      _i2.Either<_i5.Failure,
          _i6.SpeechToTextInitializerStatusEntity>> initializeSpeechToText() =>
      (super.noSuchMethod(
        Invocation.method(
          #initializeSpeechToText,
          [],
        ),
        returnValue: _i4.Future<
                _i2.Either<_i5.Failure,
                    _i6.SpeechToTextInitializerStatusEntity>>.value(
            _FakeEither_0<_i5.Failure, _i6.SpeechToTextInitializerStatusEntity>(
          this,
          Invocation.method(
            #initializeSpeechToText,
            [],
          ),
        )),
      ) as _i4.Future<
          _i2.Either<_i5.Failure, _i6.SpeechToTextInitializerStatusEntity>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.ListeningStatusEntity>>
      startListening() => (super.noSuchMethod(
            Invocation.method(
              #startListening,
              [],
            ),
            returnValue: _i4.Future<
                    _i2.Either<_i5.Failure, _i6.ListeningStatusEntity>>.value(
                _FakeEither_0<_i5.Failure, _i6.ListeningStatusEntity>(
              this,
              Invocation.method(
                #startListening,
                [],
              ),
            )),
          ) as _i4.Future<_i2.Either<_i5.Failure, _i6.ListeningStatusEntity>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.ListeningStatusEntity>>
      stopListening() => (super.noSuchMethod(
            Invocation.method(
              #stopListening,
              [],
            ),
            returnValue: _i4.Future<
                    _i2.Either<_i5.Failure, _i6.ListeningStatusEntity>>.value(
                _FakeEither_0<_i5.Failure, _i6.ListeningStatusEntity>(
              this,
              Invocation.method(
                #stopListening,
                [],
              ),
            )),
          ) as _i4.Future<_i2.Either<_i5.Failure, _i6.ListeningStatusEntity>>);
}
