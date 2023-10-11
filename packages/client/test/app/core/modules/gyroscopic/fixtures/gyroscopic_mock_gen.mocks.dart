// Mocks generated by Mockito 5.4.1 from annotations
// in primala/test/app/core/modules/gyroscopic/fixtures/gyroscopic_mock_gen.dart.
// Do not manually edit this file.

// @dart=2.19

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:primala/app/core/error/failure.dart' as _i5;
import 'package:primala/app/core/interfaces/logic.dart' as _i7;
import 'package:primala/app/core/modules/gyroscopic/domain/domain.dart' as _i6;

import 'gyroscopic_mock_gen.dart' as _i3;

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

/// A class which mocks [MGyroscopicContract].
///
/// See the documentation for Mockito's code generation for more information.
class MockMGyroscopicContract extends _i1.Mock
    implements _i3.MGyroscopicContract {
  MockMGyroscopicContract() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<
      _i2.Either<_i5.Failure, _i6.DirectionAngleEntity>> getDirectionAngle(
          _i7.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #getDirectionAngle,
          [params],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, _i6.DirectionAngleEntity>>.value(
                _FakeEither_0<_i5.Failure, _i6.DirectionAngleEntity>(
          this,
          Invocation.method(
            #getDirectionAngle,
            [params],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.DirectionAngleEntity>>);
}

/// A class which mocks [MGyroscopicRemoteSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockMGyroscopicRemoteSource extends _i1.Mock
    implements _i3.MGyroscopicRemoteSource {
  MockMGyroscopicRemoteSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<int> getDirectionAngle() => (super.noSuchMethod(
        Invocation.method(
          #getDirectionAngle,
          [],
        ),
        returnValue: _i4.Stream<int>.empty(),
      ) as _i4.Stream<int>);
  @override
  void setReferenceAngle(int? newReferenceAngle) => super.noSuchMethod(
        Invocation.method(
          #setReferenceAngle,
          [newReferenceAngle],
        ),
        returnValueForMissingStub: null,
      );
}
