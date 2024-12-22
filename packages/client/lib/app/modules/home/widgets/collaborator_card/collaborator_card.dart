import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
export 'collaborator_card_store.dart';

class CollaboratorCard extends HookWidget {
  final CollaboratorCardStore store;

  const CollaboratorCard({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final height = useFullScreenSize().height;

    return Observer(builder: (context) {
      return AnimatedOpacity(
        opacity: useWidgetOpacity(store.showWidget),
        duration: Seconds.get(0, milli: 500),
        child: Padding(
          padding: EdgeInsets.only(top: height * .3),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics:
                store.showWidget ? null : const NeverScrollableScrollPhysics(),
            itemCount: store.collaborators.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: height * 0.02),
            itemBuilder: (context, index) {
              final collaborator = store.collaborators[index];

              return Observer(builder: (context) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: height * 0.04),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Column(
                        children: [
                          Jost(
                            collaborator.fullName,
                            fontSize: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ),
      );
    });
  }
}
