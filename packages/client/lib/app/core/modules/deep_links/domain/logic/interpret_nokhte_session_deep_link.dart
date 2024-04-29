import 'package:equatable/equatable.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/modules/deep_links/deep_links.dart';

class InterpretNokhteSessionDeepLink
    implements
        AbstractSyncNoFailureLogic<InterpretedDeepLinkEntity,
            InterpretNokhteSessionDeepLinkParams> {
  @override
  call(params) {
    return InterpretedDeepLinkEntity(
      path: '/session_starters/',
      additionalMetadata: {
        "isTheUsersInvitation": params.isTheUsersInvitation,
        "deepLinkUID": params.deepLinkUID,
      },
    );
  }
}

class InterpretNokhteSessionDeepLinkParams extends Equatable {
  final bool isTheUsersInvitation;
  final String deepLinkUID;

  const InterpretNokhteSessionDeepLinkParams({
    required this.deepLinkUID,
    required String usersUID,
  }) : isTheUsersInvitation = usersUID == deepLinkUID;

  @override
  List<Object> get props => [isTheUsersInvitation];
}
