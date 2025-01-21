// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:ui';

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
part 'group_picker_widgets_coordinator.g.dart';

class GroupPickerWidgetsCoordinator = _GroupPickerWidgetsCoordinatorBase
    with _$GroupPickerWidgetsCoordinator;

abstract class _GroupPickerWidgetsCoordinatorBase
    with Store, AnimatedScaffoldMovie {
  final AnimatedScaffoldStore animatedScaffold;

  _GroupPickerWidgetsCoordinatorBase({
    required this.animatedScaffold,
  });

  @action
  constructor() {
    animatedScaffold.setMovie(
      getMovie(
        const Color(0xFFFFFBEC),
        const Color(0xFFFFFBEC),
      ),
    );
  }
}
