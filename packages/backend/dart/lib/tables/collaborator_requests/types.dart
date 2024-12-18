import 'package:equatable/equatable.dart';

class CollaboratorRequests extends Equatable {
  final String senderName;
  final String senderUID;

  const CollaboratorRequests({
    required this.senderName,
    required this.senderUID,
  });

  @override
  List<Object?> get props => [senderName, senderUID];
}
