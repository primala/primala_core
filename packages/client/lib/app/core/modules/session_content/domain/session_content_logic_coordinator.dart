// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/session_content/session_content.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';
part 'session_content_logic_coordinator.g.dart';

class SessionContentLogicCoordinator = _SessionContentLogicCoordinatorBase
    with _$SessionContentLogicCoordinator;

abstract class _SessionContentLogicCoordinatorBase with Store, BaseMobxLogic {
  final SessionContentContract contract;

  _SessionContentLogicCoordinatorBase({
    required this.contract,
  }) {
    initBaseLogicActions();
  }

  @observable
  bool contentIsUpdated = false;

  @observable
  bool contentIsDeleted = false;

  @observable
  bool parentIsUpdated = false;

  @observable
  bool contentIsAdded = false;

  @observable
  ObservableList<ContentBlockEntity> sessionContentEntity =
      ObservableList<ContentBlockEntity>();

  StreamSubscription contentStreamSubscription =
      const Stream.empty().listen((event) {});

  @observable
  ObservableStream<ContentBlockList> sessionContent =
      ObservableStream(const Stream.empty());

  @action
  listenToDocumentContent(int documentId) async {
    final result = await contract.listenToDocumentContent(documentId);

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
      (contentAdditionStatus) => contentIsAdded = contentAdditionStatus,
    );
    setState(StoreState.loaded);
  }

  @action
  deleteContent(int contentId) async {
    final res = await contract.deleteContent(contentId);
    res.fold(
      (failure) => errorUpdater(failure),
      (contentDeletionStatus) => contentIsDeleted = contentDeletionStatus,
    );
    setState(StoreState.loaded);
  }

  @action
  updateContent(UpdateContentParams params) async {
    final res = await contract.updateContent(params);
    res.fold(
      (failure) => errorUpdater(failure),
      (contentUpdateStatus) => contentIsUpdated = contentUpdateStatus,
    );
    setState(StoreState.loaded);
  }

  @action
  updateParent(UpdateParentParams params) async {
    final res = await contract.updateParent(params);
    res.fold(
      (failure) => errorUpdater(failure),
      (parentUpdateStatus) => parentIsUpdated = parentUpdateStatus,
    );
    setState(StoreState.loaded);
  }

  @action
  dispose() async {
    await contract.cancelSessionContentStream();
    contentStreamSubscription = const Stream.empty().listen((event) {});
    sessionContent = ObservableStream(const Stream.empty());
  }

  @computed
  String get currentFocus {
    if (sessionContentEntity.isEmpty) {
      return '';
    } else {
      return sessionContentEntity
          .where((element) => element.numberOfParents == 0)
          .last
          .content;
    }
  }
}
