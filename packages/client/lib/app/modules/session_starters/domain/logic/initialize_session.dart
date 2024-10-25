import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/modules/session_starters/session_starters.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

typedef InitializeSessionParams = Either<NoParams, PresetTypes>;

class InitializeSession
    extends AbstractFutureLogic<bool, InitializeSessionParams> {
  final SessionStartersContract contract;

  InitializeSession({required this.contract});

  @override
  call(params) async => await contract.initializeSession(params);
}
