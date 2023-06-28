// * Testing & Mocking Libs
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:modular_test/modular_test.dart';
// * 3rd Party Libs
import 'package:flutter_modular/flutter_modular.dart';
import 'package:primala/app/core/interfaces/logic.dart';
import 'package:primala/app/modules/username/domain/logic/create_username.dart';
// * The Username Module
import 'package:primala/app/modules/username/username_module.dart';
// * Remote Source
import 'package:primala/app/modules/username/data/sources/username_remote_source.dart';
// * Main Mobx Stores
import 'package:primala/app/modules/username/presentation/mobx/main/create_username_store.dart';
import 'package:primala/app/modules/username/presentation/mobx/main/get_default_username_store.dart';
// * Local Mocks
import './fixtures/username_stack_mock_gen.mocks.dart';
// * Helpers
import '../_helpers/module_setup.dart';

// so step 1 is going to be initializing the main app module

void main() {
  late MockMUsernameRemoteSourceImpl mockRemoteSource;

  void teeItUp({required bool isOnline, required Function body}) {
    group("${isOnline == true ? 'Online' : 'Offline'} INTEGRATION BLOCK", () {
      setUp(() {
        mockRemoteSource = MockMUsernameRemoteSourceImpl();

        ModuleHelpers.dependentModulesSetup(isOnline);
        initModule(
          UsernameModule(),
          replaceBinds: [
            Bind.instance<UsernameRemoteSourceImpl>(mockRemoteSource),
          ],
        );
      });

      body();

      tearDown(() {
        Modular.destroy();
      });
    });
  }

  teeItUp(
      isOnline: true,
      body: () {
        test("SUCCESS CASE: CREATE USERNAME is sucessfully passed", () async {
          when(mockRemoteSource.createUsername("test")).thenAnswer(
            (_) async => [
              {"uid": "test-uid", "username": "tester"},
            ],
          );
          final createUsernameStore = Modular.get<CreateUsernameStore>();
          await createUsernameStore(const CreateUserParams(username: 'test'));
          final res = createUsernameStore.usernameIsCreated;
          expect(res, true);
          expect(createUsernameStore.errorMessage, "");
        });
        test("SUCESS CASE: DEFAULT USERNAME is successfully passed", () async {
          when(mockRemoteSource.getDefaultUsername()).thenAnswer(
            (_) async => "test@example.com",
          );
          final getDefaultUsernameStore =
              Modular.get<GetDefaultUsernameStore>();
          await getDefaultUsernameStore(NoParams());
          final res = getDefaultUsernameStore.defaultUsername;
          expect(res, "test");
        });
        // include online failure case
        test("FAILURE CASE: Create Username returns an Empty Query", () async {
          when(mockRemoteSource.createUsername("test"))
              .thenAnswer((_) async => []);
          final createUsernameStore = Modular.get<CreateUsernameStore>();
          await createUsernameStore(const CreateUserParams(username: 'test'));
          final res = createUsernameStore.usernameIsCreated;
          expect(res, false);
          expect(createUsernameStore.errorMessage, "");
        });
      });

  teeItUp(
      isOnline: false,
      body: () {
        test("FAILURE CASE: CreateUsername is called offline", () async {
          final createUsernameStore = Modular.get<CreateUsernameStore>();
          await createUsernameStore(const CreateUserParams(username: 'test'));
          final res = createUsernameStore.errorMessage;
          expect(res, 'Check Your Internet Connection, and Try Again.');
        });
        test("FAILURE CASE: getDefaultUsername is called offline", () async {
          final createUsernameStore = Modular.get<CreateUsernameStore>();
          await createUsernameStore(const CreateUserParams(username: 'test'));
          final res = createUsernameStore.errorMessage;
          expect(res, 'Check Your Internet Connection, and Try Again.');
        });
        // the behavior of this should be modified, even if they are offline
        // this SHOULD work, but if they're on this page it would be a helpful
      });
}
