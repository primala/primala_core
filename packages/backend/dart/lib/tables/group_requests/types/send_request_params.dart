import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/group_roles.dart';

class SendRequestParams extends Equatable {
  final int groupId;
  final String recipientUid;
  final GroupRole role;

  const SendRequestParams({
    required this.groupId,
    required this.recipientUid,
    required this.role,
  });
  @override
  List<Object> get props => [groupId, recipientUid, role];
}
