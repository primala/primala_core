import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:nokhte_backend/utils/profile_gradients_utils.dart';

typedef UserEntities = List<UserEntity>;

class UserEntity extends Equatable {
  final String uid;
  final ProfileGradient profileGradient;
  final String fullName;
  final String email;
  final int activeGroupId;

  UserEntity({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.profileGradient,
    required this.activeGroupId,
  });

  factory UserEntity.initial() {
    return UserEntity(
      uid: '',
      fullName: '',
      email: '',
      profileGradient: ProfileGradient.none,
      activeGroupId: -1,
    );
  }

  factory UserEntity.fromSupabaseSingle(Map res) {
    if (res.isEmpty) return UserEntity.initial();

    return UserEntity(
      uid: res[UsersConstants.S_UID],
      fullName: res[UsersConstants.S_FULL_NAME],
      email: res[UsersConstants.S_EMAIL],
      profileGradient: ProfileGradientUtils.mapStringToProfileGradient(
        res[UsersConstants.S_GRADIENT],
      ),
      activeGroupId: res[UsersConstants.S_ACTIVE_GROUP] ?? -1,
    );
  }

  static UserEntities fromSupabaseMultiple(List res) {
    List<UserEntity> temp = [];
    for (var user in res) {
      temp.add(UserEntity.fromSupabaseSingle(user));
    }
    return temp;
  }

  factory UserEntity.fromDatabaseFunction(Map res) {
    if (res[UsersConstants.S_UID] == null) return UserEntity.initial();

    return UserEntity(
      uid: res[UsersConstants.S_UID],
      fullName: res[UsersConstants.S_FULL_NAME],
      email: res[UsersConstants.S_EMAIL],
      profileGradient: ProfileGradientUtils.mapStringToProfileGradient(
        res[UsersConstants.S_GRADIENT],
      ),
      activeGroupId: res[UsersConstants.S_ACTIVE_GROUP] ?? -1,
    );
  }

  static List<UserEntity> generateFakeUsers(int count) {
    final faker = Faker();

    return List.generate(count, (index) {
      return UserEntity(
        uid: faker.guid.guid(),
        fullName: faker.person.name(),
        email: faker.internet.email(),
        profileGradient: ProfileGradient.values[
            index % ProfileGradient.values.length], // Cycle through gradients
        activeGroupId: faker.randomGenerator.integer(100, min: 1),
      );
    });
  }

  @override
  List<Object> get props => [
        uid,
        fullName,
        email,
        profileGradient,
        activeGroupId,
      ];
}
