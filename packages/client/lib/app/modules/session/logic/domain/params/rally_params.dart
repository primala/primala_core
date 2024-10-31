import 'package:equatable/equatable.dart';

class RallyParams extends Equatable {
  final String userUID;
  final bool shouldAdd;

  const RallyParams({
    required this.userUID,
    required this.shouldAdd,
  });

  @override
  List<Object> get props => [
        userUID,
        shouldAdd,
      ];
}
