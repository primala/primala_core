// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
part 'context_header_store.g.dart';

class ContextHeaderStore = _ContextHeaderStoreBase with _$ContextHeaderStore;

abstract class _ContextHeaderStoreBase extends BaseWidgetStore with Store {
  @observable
  String groupName = '';

  @observable
  String queueName = '';

  @action
  setHeader(
    String groupName,
    String queueName,
  ) {
    this.groupName = groupName;
    this.queueName = queueName;
  }

  @action
  onTap() => tapCount++;
}
