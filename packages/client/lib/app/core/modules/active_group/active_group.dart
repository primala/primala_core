import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte_backend/tables/groups.dart';

class ActiveGroup {
  int groupId = -1;
  GroupEntity groupEntity = GroupEntity.initial();

  ActiveGroup();

  setGroupId(int groupId) => this.groupId = groupId;

  setGroupEntity(GroupEntity groupEntity) => this.groupEntity = groupEntity;

  reset() {
    groupId = -1;
    groupEntity = GroupEntity.initial();
  }
}

class ActiveGroupModule extends Module {
  @override
  List<Module> get imports => [];
  @override
  binds(i) {
    i.addSingleton<ActiveGroup>(
      () => ActiveGroup(),
    );
  }
}
