import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/types/types.dart';

class UpdateGroupProfileGradientParams extends Equatable {
  final int groupId;
  final ProfileGradient gradient;

  UpdateGroupProfileGradientParams({
    required this.groupId,
    required this.gradient,
  });

  @override
  List<Object> get props => [groupId, gradient];
}
