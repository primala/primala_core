// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'create_group_coordinator.g.dart';

class CreateGroupCoordinator = _CreateGroupCoordinatorBase
    with _$CreateGroupCoordinator;

abstract class _CreateGroupCoordinatorBase with Store, Reactions {
  final CreateGroupWidgetsCoordinator widgets;

  _CreateGroupCoordinatorBase({
    required this.widgets,
  });

  @action
  constructor() {
    widgets.constructor();
  }

  @action
  onGoBack() {
    if (!widgets.showWidgets) return;
    Timer(Seconds.get(0, milli: 500), () {
      Modular.to.navigate(GroupsConstants.groupPicker);
    });
  }
}
