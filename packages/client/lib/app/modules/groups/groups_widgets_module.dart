import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';

class GroupsWidgetsModule extends Module {
  @override
  List<Module> get imports => [];
  @override
  exportedBinds(i) {
    i.add<GroupPickerWidgetsCoordinator>(
      () => GroupPickerWidgetsCoordinator(
        animatedScaffold: AnimatedScaffoldStore(),
      ),
    );
  }
}
