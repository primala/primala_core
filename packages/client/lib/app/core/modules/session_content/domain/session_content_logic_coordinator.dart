// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/session_content/session_content.dart';
import 'package:nokhte_backend/tables/session_content.dart';
part 'session_content_logic_coordinator.g.dart';

class SessionContentLogicCoordinatorStore = _SessionContentLogicCoordinatorStoreBase
    with _$SessionContentLogicCoordinatorStore;

abstract class _SessionContentLogicCoordinatorStoreBase
    with Store, BaseMobxLogic {
  final SessionContentContract contract;

  _SessionContentLogicCoordinatorStoreBase({
    required this.contract,
  }) {
    initBaseLogicActions();
  }

  @observable
  bool contentIsUpdated = false;

  @observable
  ObservableList<SessionContentEntity> sessionContentEntity =
      ObservableList<SessionContentEntity>();

  StreamSubscription contentStreamSubscription =
      const Stream.empty().listen((event) {});

  @observable
  ObservableStream<SessionContentList> sessionContent =
      ObservableStream(const Stream.empty());

  @action
  listenToSessionContent(String sessionUID) async {
    final result = await contract.listenToSessionContent(sessionUID);

    result.fold(
      (failure) {
        setErrorMessage(mapFailureToMessage(failure));
      },
      (stream) {
        sessionContent = ObservableStream(stream);
        contentStreamSubscription = sessionContent.listen((value) {
          sessionContentEntity = ObservableList.of(value);
        });
      },
    );
  }

  @action
  addContent(AddContentParams params) async {
    final res = await contract.addContent(params);
    res.fold(
      (failure) => errorUpdater(failure),
      (contentUpdateStatus) => contentIsUpdated = contentUpdateStatus,
    );
    setState(StoreState.loaded);
  }

  @action
  dispose() async {
    await contract.cancelSessionContentStream();
    contentStreamSubscription = const Stream.empty().listen((event) {});
    sessionContent = ObservableStream(const Stream.empty());
  }
}
