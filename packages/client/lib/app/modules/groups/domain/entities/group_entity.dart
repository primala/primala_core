import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/types/types.dart';

class GroupEntity extends Equatable {
  final int id;
  final String name;
  final ProfileGradient profileGradient;
  final bool isAdmin;

  const GroupEntity({
    required this.id,
    required this.name,
    required this.isAdmin,
    required this.profileGradient,
  });

  factory GroupEntity.initial() => const GroupEntity(
        id: 0,
        name: '',
        isAdmin: false,
        profileGradient: ProfileGradient.none,
      );

  @override
  List<Object> get props => [id, name, isAdmin, profileGradient];
}
