import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/types/types.dart';

class SendRequestParams extends Equatable {
  final String recipientEmail;
  final int groupId;
  final ProfileGradient recipientProfileGradient;
  final String recipientUid;
  final String recipientFullName;
  final GroupRole role;

  const SendRequestParams({
    required this.groupId,
    required this.recipientEmail,
    required this.recipientUid,
    required this.recipientFullName,
    required this.recipientProfileGradient,
    required this.role,
  });
  @override
  List<Object> get props => [
        recipientEmail,
        groupId,
        recipientUid,
        recipientFullName,
        recipientProfileGradient,
        role,
      ];
}
