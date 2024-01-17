import 'package:equatable/equatable.dart';

class CollaborationSessionMetadata extends Equatable {
  final bool userIsOnCall;
  final bool collaboratorIsOnCall;
  final bool userIsOnline;
  final bool collaboratorIsOnline;
  final bool timerShouldRun;
  final bool collaboratorIsTalking;
  final String meetingToken;
  final String meetingId;

  CollaborationSessionMetadata({
    required this.userIsOnCall,
    required this.collaboratorIsOnCall,
    required this.userIsOnline,
    required this.collaboratorIsOnline,
    required this.timerShouldRun,
    required this.collaboratorIsTalking,
    required this.meetingId,
    required this.meetingToken,
  });

  factory CollaborationSessionMetadata.initial({
    bool userIsOnCallParam = false,
    bool collaboratorIsOnCallParam = false,
    bool userIsOnlineParam = false,
    bool collaboratorIsOnlineParam = false,
    bool timerShouldRunParam = false,
    bool collaboratorIsTalkingParam = false,
    String meetingTokenParam = '',
    String meetingIdParam = '',
  }) =>
      CollaborationSessionMetadata(
        collaboratorIsOnCall: userIsOnCallParam,
        userIsOnline: collaboratorIsOnCallParam,
        userIsOnCall: userIsOnlineParam,
        collaboratorIsOnline: collaboratorIsOnlineParam,
        timerShouldRun: timerShouldRunParam,
        collaboratorIsTalking: collaboratorIsTalkingParam,
        meetingId: meetingIdParam,
        meetingToken: meetingTokenParam,
      );

  @override
  List<Object> get props => [
        collaboratorIsOnCall,
        userIsOnline,
        userIsOnCall,
        collaboratorIsOnline,
        timerShouldRun,
        collaboratorIsTalking,
        meetingId,
        meetingToken,
      ];
}
