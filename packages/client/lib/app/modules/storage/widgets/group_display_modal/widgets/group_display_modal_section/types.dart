enum GroupDisplayModalSectionType {
  storage,
  queue,
  addRemove,
}

class GroupDisplayModalDetails {
  final GroupDisplayModalSectionType type;
  late String assetPath;
  late String sectionHeader;
  GroupDisplayModalDetails(
    this.type,
  ) {
    switch (type) {
      case GroupDisplayModalSectionType.storage:
        assetPath = 'assets/storage_icon.png';
        sectionHeader = 'Storage';
      case GroupDisplayModalSectionType.queue:
        assetPath = 'assets/queue_icon.png';
        sectionHeader = 'Queue';
      case GroupDisplayModalSectionType.addRemove:
        assetPath = 'assets/add_remove_icon.png';
        sectionHeader = 'Add/Remove';
    }
  }
}
