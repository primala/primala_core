import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
export 'group_display_collaborator_card_store.dart';

class GroupDisplayCollaboratorCard extends HookWidget {
  final GroupDisplayCollaboratorCardStore store;
  final bool showWidget;

  const GroupDisplayCollaboratorCard({
    super.key,
    required this.store,
    required this.showWidget,
  });

  @override
  Widget build(BuildContext context) {
    final height = useFullScreenSize().height;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: store.collaborators.length,
      separatorBuilder: (context, index) => SizedBox(height: height * 0.02),
      itemBuilder: (context, index) {
        final session = store.collaborators[index];

        return Observer(builder: (context) {
          return AnimatedOpacity(
            opacity: useWidgetOpacity(showWidget),
            duration: Seconds.get(0, milli: 500),
            child: GestureDetector(
              onTap: () {
                if (!showWidget) return;
                store.toggleMembershipStatus(index);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.04),
                child: AnimatedOpacity(
                  opacity: store.membershipList[index] ? 1 : 0.5,
                  duration: Seconds.get(0, milli: 500),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Column(
                        children: [
                          Jost(
                            session.name,
                            fontSize: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
