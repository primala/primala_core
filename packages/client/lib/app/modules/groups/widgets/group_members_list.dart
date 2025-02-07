import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';

class GroupMembersList extends HookWidget {
  final List<GroupRoleEntity> members;
  final Function onMemberTapped;

  const GroupMembersList(
    this.members, {
    super.key,
    required this.onMemberTapped,
  });

  List<Widget> getMembers(double width) {
    final temp = <Widget>[];
    for (int i = 0; i < members.length; i++) {
      final member = members[i];
      final isLastItem = i == members.length - 1;
      temp.add(GestureDetector(
        onTap: () {
          if (member.isUser || member.isPending) return;
          onMemberTapped(member);
        },
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: const BorderSide(
                color: Colors.black,
                width: 1,
              ),
              bottom: BorderSide(
                color: isLastItem ? Colors.black : Colors.transparent,
                width: isLastItem ? 1 : 0,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: UserAvatar(
                    fullName: member.fullName,
                    gradient: member.profileGradient,
                    size: 30,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    // right: 56,
                    left: 10,
                  ),
                  child: Jost(
                    "${member.fullName} ${member.isUser ? "(you)" : ""}",
                    // fontWeight: FontWeight.w500,
                    fontSize: 16,
                    fontColor: Colors.black,
                  ),
                ),
                const Spacer(),
                Jost(
                  member.isPending ? "pending" : member.role.name,
                  fontSize: 12,
                  // fontWeight: FontWeight.w300,
                  shouldAlignRight: true,
                  fontColor: Colors.black.withOpacity(.6),
                ),
                // if (!member.isUser)
                Padding(
                  padding: const EdgeInsets.only(right: 12, left: 56),
                  child: Icon(
                    CupertinoIcons.chevron_right,
                    size: 20,
                    // weight: 100,
                    color: Colors.black.withOpacity(
                        member.isUser || member.isPending ? .2 : 1),
                  ),
                )

                // put the chevron here (except if it's theirs)
              ],
            ),
          ),
          // onTap: () {},
          // title: member.fullName,
        ),
      ));
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    final width = useFullScreenSize().width;
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        children: getMembers(width),
      ),
    );
  }
}
