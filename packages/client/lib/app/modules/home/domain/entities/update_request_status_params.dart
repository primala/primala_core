import 'package:equatable/equatable.dart';

class UpdateRequestStatusParams extends Equatable {
  final String requestUID;
  final bool shouldAccept;

  const UpdateRequestStatusParams({
    required this.requestUID,
    required this.shouldAccept,
  });

  @override
  List<Object> get props => [requestUID, shouldAccept];
}
