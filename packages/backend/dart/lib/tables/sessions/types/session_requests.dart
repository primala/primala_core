import 'package:equatable/equatable.dart';

class SessionRequests extends Equatable {
  final int sessionID;
  final String groupName;

  SessionRequests({
    required this.sessionID,
    required this.groupName,
  });

  @override
  List<Object> get props => [
        sessionID,
        groupName,
      ];
}
