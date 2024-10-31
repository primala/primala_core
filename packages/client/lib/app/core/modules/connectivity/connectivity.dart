import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:flutter_modular/flutter_modular.dart';
export 'mobx/get_on_connectivity_changed_store.dart';
export 'sources/connectivity_remote_source.dart';
export 'wifi_disconnect_overlay/wifi_disconnect_overlay.dart';

class ConnectivityModule extends Module {
  @override
  exportedBinds(i) {
    i.add<ConnectivityRemoteSourceImpl>(
      () => ConnectivityRemoteSourceImpl(
        connectivity: Connectivity(),
      ),
    );

    i.add<GetOnConnectivityChangedStore>(
      () => GetOnConnectivityChangedStore(
        remoteSource: i<ConnectivityRemoteSourceImpl>(),
      ),
    );
    i.add<WifiDisconnectOverlayStore>(
      () => WifiDisconnectOverlayStore(
        getOnConnectivityChanged: Modular.get<GetOnConnectivityChangedStore>(),
      ),
    );
  }
}
