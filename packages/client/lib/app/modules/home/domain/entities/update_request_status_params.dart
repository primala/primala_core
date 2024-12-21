import 'package:equatable/equatable.dart';

class UpdateRequestStatusParams extends Equatable {
  final String requestUID;
  final bool shouldAccept;
  final String senderUID;

  const UpdateRequestStatusParams({
    required this.requestUID,
    required this.shouldAccept,
    required this.senderUID,
  });

  @override
  List<Object> get props => [requestUID, shouldAccept];
}
