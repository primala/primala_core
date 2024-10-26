// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:mobx/mobx.dart';
import 'package:equatable/equatable.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/modules/login/login.dart';
part 'get_login_state_store.g.dart';

class GetLoginStateStore = _GetLoginStateStoreBase with _$GetLoginStateStore;

abstract class _GetLoginStateStoreBase extends Equatable with Store {
  final GetLoginState logic;

  _GetLoginStateStoreBase({
    required this.logic,
  }) : authState = logic(const NoParams()).asBroadcastStream();

  @observable
  Stream<bool> authState;

  @override
  List<Object> get props => [authState];
}
