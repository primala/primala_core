// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'group_picker_widgets_coordinator.g.dart';

class GroupPickerWidgetsCoordinator = _GroupPickerWidgetsCoordinatorBase
    with _$GroupPickerWidgetsCoordinator;

abstract class _GroupPickerWidgetsCoordinatorBase
    with Store, AnimatedScaffoldMovie {
  final AnimatedScaffoldStore animatedScaffold;
  final GroupDisplayStore groupDisplay;

  _GroupPickerWidgetsCoordinatorBase({
    required this.animatedScaffold,
    required this.groupDisplay,
  });

  @observable
  bool showWidgets = false;

  @action
  setShowWidgets(bool value) => showWidgets = value;

  @action
  constructor() {
    Timer(Seconds.get(0, milli: 1), () {
      setShowWidgets(true);
    });
  }
}
