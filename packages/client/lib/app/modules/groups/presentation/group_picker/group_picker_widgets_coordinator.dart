// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'group_picker_widgets_coordinator.g.dart';

class GroupPickerWidgetsCoordinator = _GroupPickerWidgetsCoordinatorBase
    with _$GroupPickerWidgetsCoordinator;

abstract class _GroupPickerWidgetsCoordinatorBase
    with Store, AnimatedScaffoldMovie, BaseWidgetsCoordinator {
  final AnimatedScaffoldStore animatedScaffold;
  final GroupDisplayStore groupDisplay;

  _GroupPickerWidgetsCoordinatorBase({
    required this.animatedScaffold,
    required this.groupDisplay,
  }) {
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    groupDisplay.setWidgetVisibility(false);
    fadeInWidgets();
  }

  editGroupReactor() => reaction((p0) => groupDisplay.groupIndexToEdit, (p0) {
        if (p0 == -1) return;
        final group = groupDisplay.groups[p0];
        Modular.to.push(MaterialPageRoute(builder: (BuildContext context) {
          return EditGroupScreen(
            group: group,
            coordinator: Modular.get<EditGroupCoordinator>(),
          );
        }));
        groupDisplay.setGroupIndexToEdit(-1);
        groupDisplay.toggleIsManagingGroups(false);
      });

  activeGroupReactor(Function(int groupId) onSelected) =>
      reaction((p0) => groupDisplay.activeGroupIndex, (p0) async {
        if (!showWidgets) return;
        setShowWidgets(false);
        final group = groupDisplay.groups[p0];
        await onSelected(group.id);
        Timer(Seconds.get(0, milli: 500), () {
          // Modular.to.navigate(
          //   HomeConstants.home,
          // );
        });
      });

  createGroupReactor() =>
      reaction((p0) => groupDisplay.createGroupTapCount, (p0) {
        if (!showWidgets) return;
        setShowWidgets(false);
        Timer(Seconds.get(0, milli: 500), () {
          Modular.to.navigate(GroupsConstants.createGroup);
        });
      });
}
