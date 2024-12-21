import 'package:equatable/equatable.dart';

class CollaboratorRequests extends Equatable {
  final String senderName;
  final String senderUID;
  final String requestUID;

  const CollaboratorRequests({
    required this.senderName,
    required this.senderUID,
    required this.requestUID,
  });

  @override
  List<Object?> get props => [senderName, senderUID];
}
