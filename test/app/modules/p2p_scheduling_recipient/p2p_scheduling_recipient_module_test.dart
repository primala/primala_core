// * Testing & Mocking Libs
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:modular_test/modular_test.dart';
// * 3rd Party Libs
import 'package:flutter_modular/flutter_modular.dart';
// * Core Imports
import 'package:primala/app/core/constants/failure_constants.dart';
import 'package:primala/app/core/mobx/store_state.dart';
// * The p2p request receiver module
import 'package:primala/app/modules/p2p_scheduling_recipient/p2p_scheduling_recipient_module.dart';
// * Remote Source
import 'package:primala/app/modules/p2p_scheduling_recipient/data/sources/p2p_scheduling_recipient_remote_source.dart';
// * Main MobX Stores
import 'package:primala/app/modules/p2p_scheduling_recipient/presentation/mobx/main/respond_to_scheduling_request_store.dart';
// * Local Mocks
import 'constants/param/respond_param_entity.dart';
import './fixtures/p2p_scheduling_recipient_mock_gen.mocks.dart';
// * Helpers
import '../_helpers/module_setup.dart';
import 'constants/sample_data.dart';
import '../p2p_scheduling_sender/constants/sample_data.dart' as sd;

void main() {
  late MockMP2PSchedulingRecipientRemoteSourceImpl mockRemoteSource;
  late RespondToSchedulingRequestStore respondToSchedulingRequestStore;

  void teeItUp({required bool isOnline, required Function body}) {
    group(
      "${isOnline == true ? 'Online' : 'Offline'} INTEGRATION BLOCK",
      () {
        setUp(() {
          mockRemoteSource = MockMP2PSchedulingRecipientRemoteSourceImpl();
          ModuleHelpers.dependentModulesSetup(isOnline);
          initModule(
            P2PSchedulingRecipientModule(),
            replaceBinds: [
              Bind.instance<P2PSchedulingRecipientRemoteSourceImpl>(
                mockRemoteSource,
              ),
            ],
          );
        });
        body();

        tearDown(() {
          Modular.destroy();
        });
      },
    );
  }

  teeItUp(
      isOnline: true,
      body: () {
        group('respondToSchedulingRequestStore', () {
          setUp(() {
            respondToSchedulingRequestStore =
                Modular.get<RespondToSchedulingRequestStore>();
          });
          test("✅ SUCCESS CASE: Successful Request is made", () async {
            when(mockRemoteSource.respondToSchedulingRequest(
                    sd.SampleData.randomUID,
                    sd.SampleData.june19th10AMtimestampz))
                .thenAnswer((_) async => [SampleData.successRespondRes]);
            await respondToSchedulingRequestStore(
                ConstantRespondParamEntities.entity);
            expect(respondToSchedulingRequestStore.isSent, true);
            expect(respondToSchedulingRequestStore.errorMessage, "");
            expect(respondToSchedulingRequestStore.state, StoreState.loaded);
          });
        });
      });

  teeItUp(
      isOnline: false,
      body: () {
        group('respondToSchedulingRequestStore', () {
          setUp(() {
            respondToSchedulingRequestStore =
                Modular.get<RespondToSchedulingRequestStore>();
          });
          test("❌ FAILURE CASE: Request is attempted when off the grid",
              () async {
            await respondToSchedulingRequestStore(
              ConstantRespondParamEntities.entity,
            );
            expect(respondToSchedulingRequestStore.isSent, false);
            expect(respondToSchedulingRequestStore.errorMessage,
                FailureConstants.internetConnectionFailureMsg);
            expect(respondToSchedulingRequestStore.state, StoreState.initial);
          });
        });
      });
}
