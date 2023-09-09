// ignore_for_file: must_be_immutable, library_private_types_in_public_api
// * Mobx Import
import 'package:mobx/mobx.dart';
// * Equatable Import
import 'package:primala/app/core/interfaces/logic.dart';
import 'package:primala/app/core/mobx/base_mobx_db_store.dart';
import 'package:primala/app/core/mobx/store_state.dart';
import 'package:primala/app/modules/p2p_purpose_session/domain/domain.dart';
import 'package:primala/app/modules/p2p_purpose_session/presentation/presentation.dart';
// * Mobx Codegen Inclusion
part 'get_collaborative_doc_content_store.g.dart';

class GetCollaborativeDocContentStore = _GetCollaborativeDocContentStoreBase
    with _$GetCollaborativeDocContentStore;

abstract class _GetCollaborativeDocContentStoreBase
    extends BaseMobxDBStore<NoParams, CollaborativeDocContentEntity>
    with Store {
  final GetCollaborativeDocContentGetterStore getterStore;

  _GetCollaborativeDocContentStoreBase({
    required this.getterStore,
  });

  @observable
  ObservableStream<String> docContent = ObservableStream(Stream.value(""));

  @override
  Future<void> call(params) async {
    final result = await getterStore();
    result.fold(
      (failure) {
        errorMessage = mapFailureToMessage(failure);
        state = StoreState.initial;
      },
      (docContentEntity) {
        docContent = ObservableStream(docContentEntity.docContent);
        state = StoreState.loaded;
      },
    );
  }
}
