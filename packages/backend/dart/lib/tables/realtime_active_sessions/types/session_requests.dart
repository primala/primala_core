import 'package:equatable/equatable.dart';

class SessionRequests extends Equatable {
  final String sessionUID;
  final String sessionLeaderFirstName;
  final int userIndex;

  SessionRequests({
    required this.sessionUID,
    required this.sessionLeaderFirstName,
    required this.userIndex,
  });

  @override
  List<Object> get props => [
        sessionUID,
        sessionLeaderFirstName,
        userIndex,
      ];
}
