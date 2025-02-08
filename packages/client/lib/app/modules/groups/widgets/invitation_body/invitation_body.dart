import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
export 'invitation_body_store.dart';
export 'invitation_text_field.dart';
export 'invitation_permission_level.dart';

class InvitationBody extends HookWidget with NokhteGradients {
  final InvitationBodyStore store;

  const InvitationBody({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();

    final gapSize = useScaledSize(
      baseValue: .05,
      screenSize: screenSize,
      bumpPerHundredth: -.0001,
    );
    return Observer(builder: (context) {
      return Padding(
        padding: EdgeInsets.only(top: gapSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InvitationTextField(
              currentText: store.emailSearchText,
              controller: store.controller,
              selectedEmails: store.selectedEmails,
              onChange: store.onChange,
              onDeleteEmail: store.onDeleteEmail,
            ),
            InvitationPermissionLevel(
              onCurrentPermissionTapped: store.onPermissionLevelTap,
              currentRole: store.currentRole,
            ),
            SizedBox(height: gapSize),
            InvitationSelectionArea(
              titleText: store.selectAreaTitleText,
              bodyText: store.selectAreaBodyText,
              onSelected: store.onSelected,
              prefixWidget: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: store.isSelectable
                    ? UserAvatar(
                        fullName: store.userInformationEntity.fullName,
                        gradient: store.userInformationEntity.profileGradient,
                        size: 30,
                      )
                    : Image.asset(
                        'assets/groups/envelope_icon_transparent.png',
                        width: 30,
                        height: 30,
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class InvitationSelectionArea extends StatelessWidget {
  final String titleText;
  final String bodyText;
  final Widget prefixWidget;
  final Function onSelected;

  const InvitationSelectionArea({
    super.key,
    required this.titleText,
    required this.bodyText,
    required this.prefixWidget,
    required this.onSelected,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 28, bottom: 8),
          child: Jost(
            titleText,
            fontSize: 15,
            fontColor: Colors.black.withOpacity(.6),
          ),
        ),
        GenericMenuItem(
          prefixWidget: prefixWidget,
          onTap: () => onSelected(),
          padding: const EdgeInsets.only(
            left: 35,
            top: 4,
            bottom: 4,
          ),
          borderColor: Colors.black.withOpacity(.2),
          title: bodyText,
          showChevron: false,
        ),
      ],
    );
  }
}
