import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
export 'group_display_store.dart';

class GroupDisplay extends HookWidget {
  final GroupDisplayStore store;

  const GroupDisplay({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();

    useEffect(() {
      // store.constructor(context);
      return null;
    }, []);

    return Observer(builder: (context) {
      return AnimatedOpacity(
        opacity: useWidgetOpacity(store.showWidget),
        duration: Seconds.get(1),
        child: MultiHitStack(
          children: [
            GestureDetector(
              onTap: () {
                // store.onUsewithThisrButtonTapped();
              },
              child: Padding(
                padding: EdgeInsets.only(
                  top: screenSize.height * 0.16,
                  left: 30,
                ),
                child: Image.asset(
                  'assets/groups/user_icon.png',
                  width: 60,
                  height: 60,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: screenSize.height * 0.45,
                ),
                child: Jost(
                  'Your Groups',
                  fontSize: 40,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Positioned.fill(
                child: Padding(
              padding: EdgeInsets.only(
                top: screenSize.height * 0.35,
              ),
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: store.groups.length,
                itemBuilder: (context, index) {
                  return Observer(builder: (context) {
                    final group = store.groups[index];
                    return _buildGroupItem(index, group);
                  });
                },
              ),
            )),

            // Dynamic Action Button
          ],
        ),
      );
    });
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      key: const ValueKey('add-button'),
      onTap: () {
        // store.onAddButtonTap();
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.27),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildGroupItem(
    int index,
    dynamic group, {
    bool isDragging = false,
  }) {
    return Observer(builder: (context) {
      return GestureDetector(
        onTap: () {
          // store.setCurrentlySelectedIndex(index);
          // store.groupDisplayModal.showModal(group, context);
        },
        child: Column(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                border: Border.all(
                    color: isDragging
                        ? Colors.red.withOpacity(0.5)
                        : Colors.grey.shade300),
                borderRadius: BorderRadius.circular(80),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  group.groupName.characters.first,
                  style: GoogleFonts.jost(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              group.groupName,
              style: GoogleFonts.jost(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    });
  }
}
