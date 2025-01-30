import 'package:equatable/equatable.dart';

class SessionRequest extends Equatable {
  final int sessionID;
  final String sessionHost;

  SessionRequest({
    required this.sessionID,
    required this.sessionHost,
  });

  @override
  List<Object> get props => [
        sessionID,
        sessionHost,
      ];
}
