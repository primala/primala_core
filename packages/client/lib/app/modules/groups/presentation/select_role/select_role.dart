import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/constants/colors.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
export 'select_role_coordinator.dart';
export 'select_role_widgets_coordinator.dart';

class SelectRoleScreen extends HookWidget {
  final Function(GroupRole role) onRoleSelected;
  final bool showRemoveItem;

  const SelectRoleScreen({
    super.key,
    required this.onRoleSelected,
    this.showRemoveItem = true,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      //  coordinator.constructor();
      return null;
      // return () => coordinator.deconstructor();
    }, []);
    return AnimatedScaffold(
      store: AnimatedScaffoldStore(),
      child: Observer(builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TitleBar(
              centerTextLabel: 'Select Role',
              rightTextLabel: 'Confirm',
              onCancelTapped: () => Modular.to.pop(),
              onConfirmTapped: () => Modular.to.pop(),
            ),
            const SizedBox(
              height: 60,
            ),
            GenericMenuItem(
              onTap: () => onRoleSelected(GroupRole.admin),
              title: 'Admin',
              subtitle: 'Add, edit, or remove collaborators and documents',
              borderColor: Colors.black.withOpacity(.6),
              showChevron: false,
            ),
            const SizedBox(
              height: 20,
            ),
            GenericMenuItem(
              onTap: () => onRoleSelected(GroupRole.collaborator),
              title: 'Collaborator',
              subtitle: 'Add, edit, or remove documents',
              borderColor: Colors.black.withOpacity(.6),
              showChevron: false,
            ),
            const SizedBox(
              height: 20,
            ),
            if (showRemoveItem)
              GenericMenuItem(
                onTap: () => onRoleSelected(GroupRole.none),
                title: 'Remove',
                textColor: NokhteColors.red,
                subtitle: 'Lose access to everything',
                borderColor: Colors.black.withOpacity(.6),
                showChevron: false,
              ),
          ],
        );
      }),
    );
  }
}
