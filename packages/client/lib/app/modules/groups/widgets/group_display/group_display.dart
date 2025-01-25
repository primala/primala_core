import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/constants/gradients.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
export 'group_display_store.dart';

class GroupDisplay extends HookWidget with NokhteGradients {
  final GroupDisplayStore store;

  const GroupDisplay({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();
    final width = screenSize.width;
    return Observer(builder: (context) {
      return AnimatedOpacity(
        opacity: useWidgetOpacity(store.showWidget),
        duration: Seconds.get(1),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
                bottom: 20,
              ),
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: store.groups.length + 1, // Add 1 for the add button
                itemBuilder: (context, index) {
                  // If it's the last item, show the add button
                  if (index == store.groups.length) {
                    return GestureDetector(
                      onTap: () => store.onCreateGroupTapped(),
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            clipBehavior: Clip.none,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              shape: BoxShape.circle,
                              // color: Colors.white,
                            ),
                            child: Center(
                                child: Image.asset(
                              'assets/groups/plus_icon.png',
                              width: 80,
                              height: 80,
                            )),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Add Group',
                            style: GoogleFonts.jost(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  }
                  // Otherwise show the regular group item
                  return Observer(builder: (context) {
                    final group = store.groups[index];
                    return _buildGroupItem(index, group);
                  });
                },
              ),
            ),
            Observer(builder: (context) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: width * 0.7,
                  height: 50,
                  decoration: BoxDecoration(
                    color: store.isManagingGroups
                        ? Colors.black
                        : Colors.transparent,
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: ElevatedButton(
                    onPressed: () =>
                        store.toggleIsManagingGroups(!store.isManagingGroups),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: Text(
                        store.isManagingGroups ? 'Done' : 'Manage Profiles',
                        key: ValueKey(store.isManagingGroups),
                        style: GoogleFonts.jost(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: store.isManagingGroups
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildGroupItem(
    int index,
    GroupEntity group,
  ) {
    return Observer(builder: (context) {
      return GestureDetector(
        onTap: () => store.onGroupTap(index),
        child: Column(
          children: [
            Stack(
              children: [
                // Original container with gradient and first letter
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: mapProfileGradientToLinearGradient(
                        group.profileGradient),
                  ),
                  child: Center(
                    child: AnimatedOpacity(
                      opacity: store.isManagingGroups ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Jost(
                        group.groupName.characters.first,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        shouldCenter: true,
                      ),
                    ),
                  ),
                ),

                // Tint overlay that appears when managing groups
                if (store.isManagingGroups && store.groups[index].isAdmin)
                  AnimatedOpacity(
                    opacity: 0.5,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/groups/pencil_icon_white.png',
                          height: 35,
                          width: 35,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                group.groupName,
                style: GoogleFonts.jost(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    });
  }
}
