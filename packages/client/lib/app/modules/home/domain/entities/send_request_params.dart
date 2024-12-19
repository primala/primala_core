import 'package:equatable/equatable.dart';

class SendRequestParams extends Equatable {
  final String recipientUID;
  final String senderName;

  const SendRequestParams({
    required this.recipientUID,
    required this.senderName,
  });

  @override
  List<Object> get props => [recipientUID, senderName];
}
