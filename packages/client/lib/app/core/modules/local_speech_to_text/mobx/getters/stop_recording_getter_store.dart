// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/modules/local_speech_to_text/domain/domain.dart';
part 'stop_recording_getter_store.g.dart';

class StopRecordingGetterStore = _StopRecordingGetterStoreBase
    with _$StopRecordingGetterStore;

abstract class _StopRecordingGetterStoreBase extends Equatable with Store {
  final StopRecording logic;

  _StopRecordingGetterStoreBase({
    required this.logic,
  });

  Future<Either<Failure, AudioProcessingEntity>> call(params) async =>
      await logic(params);

  @override
  List<Object> get props => [];
}
