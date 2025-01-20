import 'package:equatable/equatable.dart';

class GroupRequestEntity extends Equatable {
  final int requestId;
  final String senderFullName;
  final String groupName;
  final String sentAt;

  const GroupRequestEntity({
    required this.requestId,
    required this.senderFullName,
    required this.groupName,
    required this.sentAt,
  });

  @override
  List<Object> get props => [
        requestId,
        senderFullName,
        groupName,
        sentAt,
      ];
}
