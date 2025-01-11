import 'package:equatable/equatable.dart';

class SessionRequests extends Equatable {
  final String sessionUID;
  final String groupName;

  SessionRequests({
    required this.sessionUID,
    required this.groupName,
  });

  @override
  List<Object> get props => [
        sessionUID,
        groupName,
      ];
}
