import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/tables/groups.dart';
export 'group_members_coordinator.dart';

class GroupMembersScreen extends HookWidget {
  final GroupMembersCoordinator coordinator;
  final GroupEntity group;
  const GroupMembersScreen({
    super.key,
    required this.coordinator,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor(group);
      return null;
      // return () => coordinator.deconstructor();
    }, []);
    return Observer(builder: (context) {
      return AnimatedScaffold(
        isScrollable: true,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HeaderRow(
            title: 'Group Members',
            onChevronTapped: coordinator.onGoBack,
          ),
          GroupMembersList(
            coordinator.groupMembers,
            onMemberTapped: coordinator.onMemberTapped,
          ),
        ],
      );
    });
  }
}
