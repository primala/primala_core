import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/constants/colors.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/tables/group_requests.dart';

class InboxBody extends HookWidget {
  final GroupRequests requests;
  final Function(HandleRequestParams params) handleRequest;

  const InboxBody({
    super.key,
    required this.requests,
    required this.handleRequest,
  });

  Widget _buildActionButton({
    required String text,
    required Color backgroundColor,
    required bool isAccept,
    required int requestId,
    double rightPadding = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: rightPadding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: 0,
          backgroundColor: backgroundColor,
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: () async {
          await handleRequest(
            HandleRequestParams(
              requestId: requestId,
              accept: isAccept,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Jost(
            text,
            fontWeight: FontWeight.w400,
            fontSize: 18,
            fontColor: NokhteColors.eggshell,
          ),
        ),
      ),
    );
  }

  List<Widget> getRequests(double width) {
    final temp = <Widget>[];
    for (int i = 0; i < requests.length; i++) {
      final request = requests[i];
      final isLastItem = i == requests.length - 1;
      temp.add(
        Container(
          width: width,
          decoration: BoxDecoration(
            color: NokhteColors.eggshell,
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5),
                      child: UserAvatar(
                        fullName: request.senderFullName,
                        gradient: request.senderProfileGradient,
                        size: 30,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 8),
                      width: width - 150,
                      child: Jost(
                        '${request.senderFullName} invited you to ${request.groupName}',
                        softWrap: true,
                        fontSize: 22,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Jost(
                        request.sentAt,
                        fontColor: Colors.black.withOpacity(.6),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionButton(
                      text: 'Accept',
                      backgroundColor: NokhteColors.green,
                      isAccept: true,
                      requestId: request.id,
                      rightPadding: 24,
                    ),
                    _buildActionButton(
                      text: 'Reject',
                      backgroundColor: NokhteColors.red,
                      isAccept: false,
                      requestId: request.id,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    final width = useFullScreenSize().width;
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        children: getRequests(width),
      ),
    );
  }
}
