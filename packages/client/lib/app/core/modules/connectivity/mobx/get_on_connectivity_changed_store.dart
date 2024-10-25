// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mobx/mobx.dart';
import 'package:equatable/equatable.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
part 'get_on_connectivity_changed_store.g.dart';

class GetOnConnectivityChangedStore = _GetOnConnectivityChangedStoreBase
    with _$GetOnConnectivityChangedStore;

abstract class _GetOnConnectivityChangedStoreBase extends Equatable with Store {
  late StreamSubscription<ConnectivityResult> streamSub;
  final ConnectivityRemoteSourceImpl remoteSource;

  _GetOnConnectivityChangedStoreBase({required this.remoteSource}) {
    callAndListen();
  }

  @observable
  ObservableStream<ConnectivityResult> connectivityStream =
      ObservableStream(const Stream.empty());

  @observable
  bool isConnected = true;

  @observable
  ConnectivityResult mostRecentResult = ConnectivityResult.none;

  @action
  setMostRecentResult(ConnectivityResult newResult) {
    if (newResult == ConnectivityResult.none) {
      isConnected = false;
    } else {
      isConnected = true;
    }
  }

  @action
  callAndListen() {
    connectivityStream = ObservableStream(
        remoteSource.getOnConnectivityChanged(const NoParams()));
    streamSub = connectivityStream
        .distinct()
        .listen((value) => setMostRecentResult(value));
  }

  dispose() async {
    await connectivityStream.close();

    await streamSub.cancel();
  }

  @override
  List<Object> get props => [];
}
