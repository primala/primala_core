// ignore_for_file: unused_local_variable

import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte/app/core/modules/user_information/mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/presentation/presentation.dart';

import '../../../fixtures/home_stack_mock_gen.mocks.dart';

void main() {
  late MockAddNameToDatabaseStore mockAddNameToDatabase;
  late MockGetExistingCollaborationsInfoStore mockGetExistingCollaborationInfo;
  late MockHomeScreenWidgetsCoordinator mockWidgets;
  late HomeScreenCoordinator testStore;
  late UserInformationCoordinator mockUserInformation;
  late MockDeepLinksCoordinator mockDeepLinks;
  late MockDeleteUnconsecratedCollaborationsCoordinator mockDelete;

  setUp(() {
    mockAddNameToDatabase = MockAddNameToDatabaseStore();
    mockDelete = MockDeleteUnconsecratedCollaborationsCoordinator();
    mockDeepLinks = MockDeepLinksCoordinator();
    mockGetExistingCollaborationInfo = MockGetExistingCollaborationsInfoStore();
    mockWidgets = MockHomeScreenWidgetsCoordinator();
    mockUserInformation = UserInformationCoordinator(
      getUserInfo: MockGetUserInfoStore(),
      updateHasGoneThroughInvitationFlow:
          MockUpdateHasGoneThroughInvitationFlowStore(),
      updateHasSentAnInvitation: MockUpdateHasSentAnInvitationStore(),
      updateWantsToRepeatInvitationFlow:
          MockUpdateWantsToRepeatInvitationFlowStore(),
    );

    testStore = HomeScreenCoordinator(
      deleteUnconsecratedCollaborations: mockDelete,
      swipe: SwipeDetector(),
      addNameToDatabaseStore: mockAddNameToDatabase,
      getExistingCollaborationInfo: mockGetExistingCollaborationInfo,
      userInformation: mockUserInformation,
      widgets: mockWidgets,
    );
  });
}
