import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/tables/group_requests.dart';

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
      isScrollable: true,
      children: [
        HeaderRow(
          title: "Inbox",
          onChevronTapped: () => Modular.to.pop(),
        ),
        InboxBody(
          handleRequest: handleRequest,
          requests: requests,
        ),
      ],
    );
  }
}
