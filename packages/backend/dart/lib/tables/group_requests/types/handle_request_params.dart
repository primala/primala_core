import 'package:equatable/equatable.dart';

class HandleRequestParams extends Equatable {
  final int requestId;
  final bool accept;

  HandleRequestParams({
    required this.requestId,
    required this.accept,
  });

  @override
  List<Object> get props => [requestId, accept];
}
