import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/modules/session_content/session_content.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';

class StorageWidgetsModule extends Module {
  @override
  List<Module> get imports => [
        GestureCrossModule(),
        ConnectivityModule(),
      ];
  @override
  exportedBinds(i) {
    i.add<StorageHomeWidgetsCoordinator>(
      () {
        final groupDisplaySessionCard = GroupDisplayCardStore();
        return StorageHomeWidgetsCoordinator(
          groupDisplay: GroupDisplayStore(
            groupDisplayModal: GroupDisplayModalStore(
              groupDisplayQueueCard: GroupDisplayCardStore(),
              groupDisplayCollaboratorCard: GroupDisplayCollaboratorCardStore(),
              groupDisplaySessionCard: groupDisplaySessionCard,
              blur: NokhteBlurStore(),
              queueCreationModal: QueueCreationModalStore(
                blockTextDisplay: BlockTextDisplayStore(
                  blockTextFields: BlockTextFieldsStore(),
                ),
                groupDisplaySessionCard: groupDisplaySessionCard,
                blur: NokhteBlurStore(),
              ),
            ),
          ),
          groupRegistration: GroupRegistrationStore(),
          blur: NokhteBlurStore(),
          navigationCarousels: NavigationCarouselsStore(
            beachWaves: BeachWavesStore(),
          ),
          wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        );
      },
    );
  }
}
