import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/documents.dart';
import 'package:nokhte_backend/types/types.dart';
export 'widgets/widgets.dart';

class SessionStarterBody extends HookWidget {
  final List<DocumentEntity> allDocs;
  final List<UserEntity> allUsers;

  const SessionStarterBody({
    super.key,
    required this.allDocs,
    required this.allUsers,
  });

  @override
  Widget build(BuildContext context) {
    final unselectedDocs = useState<List<DocumentEntity>>([]);
    final unselectedUsers = useState<List<UserEntity>>([]);
    final selectedDocs = useState<List<DocumentEntity>>([]);
    final selectedUsers = useState<List<UserEntity>>([]);

    // Callbacks for user selection
    final selectUser = useCallback((UserEntity user) {
      unselectedUsers.value = List.from(unselectedUsers.value)..remove(user);
      selectedUsers.value = List.from(selectedUsers.value)..add(user);
    }, []);

    final deselectUser = useCallback((UserEntity user) {
      selectedUsers.value = List.from(selectedUsers.value)..remove(user);
      unselectedUsers.value = List.from(unselectedUsers.value)..add(user);
    }, []);

    // Callbacks for document selection
    final selectDoc = useCallback((DocumentEntity doc) {
      unselectedDocs.value = List.from(unselectedDocs.value)..remove(doc);
      selectedDocs.value = List.from(selectedDocs.value)..add(doc);
    }, []);

    final deselectDoc = useCallback((DocumentEntity doc) {
      selectedDocs.value = List.from(selectedDocs.value)..remove(doc);
      unselectedDocs.value = List.from(unselectedDocs.value)..add(doc);
    }, []);

    useEffect(() {
      unselectedDocs.value = allDocs;
      unselectedUsers.value = allUsers;
      return null;
    }, [allDocs, allUsers]);

    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: const Jost(
            'Collaborators',
            fontSize: 28,
          ),
        ),
        CollaboratorsCarousel(
          collaborators: unselectedUsers.value,
          onTap: selectUser,
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: const Jost(
            'Documents',
            fontSize: 28,
          ),
        ),
        DocsCarousel(
          docs: unselectedDocs.value,
          onTap: selectDoc,
        ),
        const SizedBox(height: 20),
        Divider(
          height: 1,
          thickness: 1,
          indent: 10,
          endIndent: 10,
          color: Colors.black.withOpacity(.4),
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20, bottom: 5),
          child: const Jost(
            'Preview',
            fontSize: 28,
          ),
        ),
        SessionPreview(
          selectedDocs: selectedDocs.value,
          selectedCollaborators: selectedUsers.value,
          onCollaboratorRemove: deselectUser,
          onDocRemove: deselectDoc,
        ),
        const SizedBox(height: 40),
        GenericButton(
          isEnabled:
              selectedDocs.value.isNotEmpty && selectedUsers.value.isNotEmpty,
          onPressed: () {},
          label: 'Start Session',
        ),
      ],
    );
  }
}
