import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
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
        final groupDisplaySessionCard = GroupDisplaySessionCardStore();
        return StorageHomeWidgetsCoordinator(
          groupDisplay: GroupDisplayStore(
            groupDisplayModal: GroupDisplayModalStore(
              groupDisplayQueueCard: GroupDisplayQueueCardStore(),
              groupDisplaySessionCard: groupDisplaySessionCard,
              blur: NokhteBlurStore(),
              queueCreationModal: QueueCreationModalStore(
                groupDisplaySessionCard: groupDisplaySessionCard,
                blur: NokhteBlurStore(),
              ),
            ),
          ),
          groupRegistration: GroupRegistrationStore(),
          blur: NokhteBlurStore(),
          backButton: BackButtonStore(),
          sessionCard: SessionCardStore(),
          headerText: SmartTextStore(),
          beachWaves: BeachWavesStore(),
          wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        );
      },
    );
    i.add<StorageContentWidgetsCoordinator>(
      () => StorageContentWidgetsCoordinator(
        backButton: BackButtonStore(),
        contentCard: ContentCardStore(),
        beachWaves: BeachWavesStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
      ),
    );
  }
}
