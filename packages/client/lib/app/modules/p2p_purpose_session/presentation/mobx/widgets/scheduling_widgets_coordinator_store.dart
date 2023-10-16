// ignore_for_file: must_be_immutable, library_private_types_in_public_api
// * Mobx Import
import 'package:mobx/mobx.dart';
// * Equatable Import
import 'package:equatable/equatable.dart';
import 'package:primala/app/core/types/types.dart';
import 'package:primala/app/core/widgets/widgets.dart';
// * Mobx Codegen Inclusion
part 'scheduling_widgets_coordinator_store.g.dart';

class SchedulingWidgetsCoordinatorStore = _SchedulingWidgetsCoordinatorStoreBase
    with _$SchedulingWidgetsCoordinatorStore;

abstract class _SchedulingWidgetsCoordinatorStoreBase extends Equatable
    with Store {
  final ConveyerBeltTextStore conveyerBelt;
  final SunAndMoonStore sunAndMoon;
  final BeachHorizonWaterTrackerStore beachWaves;
  final BeachSkyStore beachSkyStore;
  _SchedulingWidgetsCoordinatorStoreBase({
    required this.conveyerBelt,
    required this.sunAndMoon,
    required this.beachSkyStore,
    required this.beachWaves,
  });

  @observable
  DateTime currentSelectedTime = DateTime.now();

  @action
  attuneTheWidgets(DateTime currentTimeParam) {
    currentSelectedTime = currentTimeParam;
    sunAndMoon.selectTimeBasedMovie(currentTimeParam);
    beachWaves.selectTimeBasedMovie(currentTimeParam);
    beachSkyStore.selectTimeBasedMovie(currentTimeParam);
  }

  @action
  initForwardTimeShift() {
    final pastTime = currentSelectedTime;
    final newTime = currentSelectedTime.add(Hours.get(1));
    beachSkyStore.initForwardShift(pastTime, newTime);
    currentSelectedTime = newTime;
  }

  @action
  initBackwardTimeShift() {
    // final pastTime = currentSelectedTime;
    // final newTime = currentSelectedTime.subtract(Hours.get(1));
  }

  @override
  List<Object> get props => [];
}
