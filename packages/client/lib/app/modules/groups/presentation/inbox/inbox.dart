import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/tables/group_requests.dart';
export 'inbox_coordinator.dart';
export 'inbox_widgets_coordinator.dart';

class InboxScreen extends HookWidget {
  final GroupRequests requests;
  final Function(HandleRequestParams params) handleRequest;

  const InboxScreen({
    super.key,
    required this.requests,
    required this.handleRequest,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScaffold(
      store: AnimatedScaffoldStore(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderRow(
              includeDivider: false,
              children: [
                LeftChevron(
                  onTap: () => Modular.to.pop(),
                ),
                const SmartHeader(
                  content: "Inbox",
                ),
                const LeftChevron(
                  color: Colors.transparent,
                ),
              ],
            ),
            InboxBody(
              handleRequest: handleRequest,
              requests: requests,
            ),
          ],
        ),
      ),
    );
  }
}
