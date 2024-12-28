import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
export 'session_starter_dropdown_store.dart';

class SessionStarterDropdown extends StatelessWidget {
  final SessionStarterDropdownStore store;

  const SessionStarterDropdown({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Group Dropdown
            DropdownButtonFormField<GroupInformationEntity>(
              value: store.selectedGroup,
              hint: const Text('Select a Group'),
              isExpanded: true,
              menuMaxHeight: 300,
              dropdownColor: Theme.of(context).colorScheme.surface,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(),
              ),
              items: store.groups.map((group) {
                return DropdownMenuItem(
                  value: group,
                  child: Text(group.groupName),
                );
              }).toList(),
              onChanged: store.setSelectedGroup,
            ),
            const SizedBox(height: 24),
            // Queue Dropdown
            DropdownButtonFormField<QueueEntity>(
              value: store.selectedQueue,
              hint: const Text('Select a Queue'),
              isExpanded: true,
              menuMaxHeight: 300,
              dropdownColor: Theme.of(context).colorScheme.surface,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(),
              ),
              items: store.availableQueues.map((queue) {
                return DropdownMenuItem(
                  value: queue,
                  child: Text(queue.title),
                );
              }).toList(),
              onChanged:
                  store.selectedGroup != null ? store.setSelectedQueue : null,
            ),
            const SizedBox(height: 32),
            // Start Session Button
            ElevatedButton(
              onPressed: store.selectedGroup != null
                  ? () {
                      store.onTap();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                minimumSize: const Size(200, 48),
              ),
              child: const Text(
                'Start Session',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
