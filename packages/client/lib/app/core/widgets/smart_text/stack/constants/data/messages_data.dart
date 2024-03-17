import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widget_constants.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class MessagesData {
  static List<RotatingTextData> get loginList => [
        RotatingTextData(
          initialFadeInDelay: Seconds.get(1),
          mainMessage: "Howdy",
          onScreenTime: Seconds.get(2),
        ),
        RotatingTextData(
          initialFadeInDelay: Seconds.get(2),
          mainMessage: "The Point Of The App Is",
          onScreenTime: Seconds.get(2),
        ),
        RotatingTextData(
          initialFadeInDelay: Seconds.get(2),
          mainMessage: "To Collectively Uplift Ideas Into Reality",
          onScreenTime: Seconds.get(2),
        ),
        RotatingTextData(
          initialFadeInDelay: Seconds.get(2),
          mainMessage: "Tap",
          unlockGesture: Gestures.tap,
          pauseHere: true,
          onScreenTime: Seconds.get(2),
        ),
      ];

  static List<RotatingTextData> get homeListHasDoneASession => [
        RotatingTextData(
          mainMessage: "Swipe right to see session notes",
          pauseHere: true,
        ),
      ];
  static List<RotatingTextData> get firstTimeHomeList => [
        RotatingTextData(
          initialFadeInDelay: Seconds.get(1),
          mainMessage: "If you're ever confused, Tap on the cross",
          onScreenTime: Seconds.get(2),
          pauseHere: true,
          unlockGesture: Gestures.tap,
        ),
        RotatingTextData(
          initialFadeInDelay: Seconds.get(1),
          mainMessage: "Swipe Up to Enter The Collaboration Page.",
          onScreenTime: Seconds.get(2),
          pauseHere: true,
        ),
        RotatingTextData(
          initialFadeInDelay: Seconds.get(0),
          mainMessage: "",
          pauseHere: true,
          onScreenTime: Seconds.get(0),
        ),
      ];

  static List<RotatingTextData> get firstTimeCollaborationList => [
        RotatingTextData(
          initialFadeInDelay: Seconds.get(1),
          mainMessage: "This is the collaboration page.",
          onScreenTime: Seconds.get(2),
        ),
        RotatingTextData(
          initialFadeInDelay: Seconds.get(1),
          mainMessage: "To make an invitation tap on the yellow dot.",
          onScreenTime: Seconds.get(0),
          pauseHere: true,
        ),
        RotatingTextData(
          initialFadeInDelay: Seconds.get(1),
          mainMessage: "Swipe Down to go Home.",
          onScreenTime: Seconds.get(2),
          pauseHere: true,
        ),
      ];

  static List<RotatingTextData> get postInvitationFlowText => [
        RotatingTextData(
          initialFadeInDelay: Seconds.get(0),
          mainMessage: "Tap on the yellow dot to make an invitation.",
          onScreenTime: Seconds.get(0),
          pauseHere: true,
          unlockGesture: Gestures.tap,
        ),
      ];

  static List<RotatingTextData> get postInvitationNoInvite => [
        RotatingTextData(
          initialFadeInDelay: Seconds.get(0),
          mainMessage:
              "Send An Invitation To Open Your Collaborator's Invitation.",
          onScreenTime: Seconds.get(0),
          pauseHere: true,
          unlockGesture: Gestures.tap,
        ),
      ];

  static List<RotatingTextData> get firstTimeSecondaryHomeList => [
        RotatingTextData(
          initialFadeInDelay: Seconds.get(0),
          mainMessage: "Tap on the overlapping time.",
          onScreenTime: Seconds.get(0),
          pauseHere: true,
          unlockGesture: Gestures.tap,
        ),
        RotatingTextData(
          initialFadeInDelay: Seconds.get(0),
          mainMessage: "",
          onScreenTime: Seconds.get(0),
        ),
      ];
  static List<RotatingTextData> get empty => [
        RotatingTextData(
          mainMessage: "",
          onScreenTime: Seconds.get(0),
        ),
      ];

  static List<RotatingTextData> get primaryPurposeSessionHasTheQuestion => [
        RotatingTextData(
          mainMessage: "Ask: What can we collectively create?",
          onScreenTime: Seconds.get(0),
          pauseHere: true,
          unlockGesture: Gestures.tap,
        ),
      ];

  static List<RotatingTextData>
      get primaryPurposeSessionDoesNotHaveTheQuestion => [
            RotatingTextData(
              mainMessage: "Wait For The Question.",
              onScreenTime: Seconds.get(0),
              pauseHere: true,
              unlockGesture: Gestures.tap,
            ),
            RotatingTextData(
              mainMessage: "What can we collectively create?",
              onScreenTime: Seconds.get(0),
              pauseHere: true,
              unlockGesture: Gestures.tap,
            ),
          ];

  static List<RotatingTextData> get primaryPurposeSessionPhase0List => [
        RotatingTextData(
          initialFadeInDelay: Seconds.get(0),
          mainMessage: "To Complete The Call, Swipe Up At The Same Time.",
          onScreenTime: Seconds.get(5, milli: 400),
        ),
        RotatingTextData(
          mainMessage: "",
          pauseHere: true,
        ),
      ];

  static List<RotatingTextData> get secondaryPurposeSessionPhase1List => [
        RotatingTextData(
          mainMessage: "hold anywhere to speak",
          onScreenTime: Seconds.get(0),
          pauseHere: true,
          mainMessageFontSize: 20.0,
          unlockGesture: Gestures.tap,
        ),
      ];
  static List<RotatingTextData> get purposeSessionBootUpList => [
        RotatingTextData(
          mainMessage: "Joining Call",
          pauseHere: true,
        ),
        RotatingTextData(
          mainMessage: "Waiting On Collaborator",
          pauseHere: true,
        ),
        RotatingTextData(
          mainMessage: "",
          pauseHere: true,
        ),
      ];

  static List<RotatingTextData> get purposeSessionPhase2List => [
        RotatingTextData(
          mainMessage: "Answer: What can we collectively create?",
          onScreenTime: Seconds.get(3),
        ),
        RotatingTextData(
          mainMessage: "",
          pauseHere: true,
        ),
        RotatingTextData(
          mainMessage: "Swipe Up If you are done",
          onScreenTime: Seconds.get(2),
        ),
        RotatingTextData(
          mainMessage: "",
          pauseHere: true,
        ),
        RotatingTextData(
          mainMessage: "Waiting On Collaborator",
          pauseHere: true,
        ),
        RotatingTextData(
          mainMessage: "",
          pauseHere: true,
        ),
      ];
  static List<RotatingTextData> get purposeSessionPhase2ErrorList => [
        RotatingTextData(
          mainMessage: "",
          pauseHere: true,
        ),
        RotatingTextData(
          mainMessage: "Collaborator Is Offline",
          pauseHere: true,
        ),
        RotatingTextData(
          mainMessage: "",
          pauseHere: true,
        ),
      ];

  static List<RotatingTextData> get primaryNokhteSessionPhase0List => [
        RotatingTextData(
          initialFadeInDelay: Seconds.get(0),
          mainMessage:
              "You will have some questions to orient the conversation",
          onScreenTime: Seconds.get(2),
        ),
        RotatingTextData(
          initialFadeInDelay: Seconds.get(0),
          mainMessage: "The aim is to create a single statement together",
          onScreenTime: Seconds.get(2),
        ),
        RotatingTextData(
          mainMessage: "",
          pauseHere: true,
        ),
      ];

  static List<RotatingTextData> get primaryNokhteSessionPhase1HasTheQuestion =>
      [
        RotatingTextData(
          mainMessage: "Ask: What Are We Here To Do?",
          pauseHere: true,
        ),
        RotatingTextData(
          mainMessage: "",
          pauseHere: true,
        ),
      ];
  static List<RotatingTextData>
      get primaryNokhteSessionPhase1DoesNotHaveTheQuestion => [
            RotatingTextData(
              mainMessage: "Wait For The Question.",
              pauseHere: true,
            ),
            RotatingTextData(
              mainMessage: "",
              pauseHere: true,
            ),
            RotatingTextData(
              mainMessage: "",
              pauseHere: true,
            ),
            RotatingTextData(
              mainMessage: "Ask: What Can We Collectively Create?",
              pauseHere: true,
            ),
          ];

  static List<RotatingTextData> get irlNokhteSessionPhase0PrimaryList => [
        RotatingTextData(
          mainMessage: "Put both phones in a position both of you can reach",
          pauseHere: true,
          mainMessageFontSize: 24.0,
        ),
        RotatingTextData(
          mainMessage: "",
          pauseHere: true,
        ),
        RotatingTextData(
          mainMessage: "Tap on the other phone to continue",
          pauseHere: true,
        ),
      ];

  static List<RotatingTextData> get irlNokhteSessionPhase0SecondaryList => [
        RotatingTextData(
          mainMessage: "Tap when you have done so",
          pauseHere: true,
          mainMessageFontSize: 20.0,
        ),
      ];

  static List<RotatingTextData>
      getIrlNokhteSessionSpeakingInstructionsPrimaryPhase0List(
          MirroredTextOrientations orientation) {
    final arr = [
      RotatingTextData(
        mainMessage: "Hold on This Side When You Are Speaking",
        pauseHere: true,
        mainMessageFontSize: 22.0,
      ),
      RotatingTextData(
        mainMessage: "",
        pauseHere: true,
      ),
      RotatingTextData(
        mainMessage: "Say: One person can speak at a time",
        pauseHere: true,
        mainMessageFontSize: 22.0,
      ),
      RotatingTextData(
        mainMessage: "",
        pauseHere: true,
      ),
      RotatingTextData(
        mainMessage: "Continue on the other phone",
        pauseHere: true,
        mainMessageFontSize: 22.0,
      ),
      RotatingTextData(
        mainMessage: "",
        pauseHere: true,
        mainMessageFontSize: 22.0,
      ),
    ];
    if (orientation == MirroredTextOrientations.upsideDown) {
      arr.removeAt(3);
    }
    return arr;
  }

  static List<RotatingTextData>
      get irlNokhteSessionSpeakingInstructionsSecondaryPhase0List => [
            RotatingTextData(
              mainMessage: "Tap to confirm",
              pauseHere: true,
              mainMessageFontSize: 19.0,
            ),
            RotatingTextData(
              mainMessage: "",
              pauseHere: true,
            ),
            RotatingTextData(
              mainMessage: "Tap to confirm",
              pauseHere: true,
              mainMessageFontSize: 19.0,
            ),
            RotatingTextData(
              mainMessage: "",
              pauseHere: true,
            ),
            RotatingTextData(
              mainMessage: "",
              pauseHere: true,
            ),
          ];
  static List<RotatingTextData>
      get irlNokhteSessionSpeakingPhoneSecondaryPhase0List => [
            RotatingTextData(
              mainMessage: "Hold to speak",
              pauseHere: true,
              mainMessageFontSize: 19.0,
            ),
          ];

  static List<RotatingTextData>
      getIrlNokhteSessionNotesInstructionsPrimaryPhase0List(
          MirroredTextOrientations orientation) {
    final arr = [
      RotatingTextData(
        mainMessage: "Look at the other phone",
        pauseHere: true,
        mainMessageFontSize: 22.0,
      ),
      RotatingTextData(
        mainMessage: "",
        pauseHere: true,
      ),
      RotatingTextData(
        mainMessage: "This phone will be used for notes",
        pauseHere: true,
        mainMessageFontSize: 22.0,
      ),
      RotatingTextData(
        mainMessage: "",
        pauseHere: true,
      ),
      RotatingTextData(
        mainMessage: "To complete the session pick up both phones",
        pauseHere: true,
        mainMessageFontSize: 22.0,
      ),
      RotatingTextData(
        mainMessage: "",
        pauseHere: true,
      ),
    ];
    if (orientation == MirroredTextOrientations.rightSideUp) {
      arr.removeAt(1);
    }
    return arr;
  }

  static List<RotatingTextData>
      getIrlNokhteSessionNotesInstructionsSecondaryPhase0List(
          MirroredTextOrientations orientation) {
    final arr = [
      RotatingTextData(
        mainMessage: "",
        pauseHere: true,
      ),
      RotatingTextData(
        mainMessage: "",
        pauseHere: true,
      ),
      RotatingTextData(
        mainMessage: "Tap to confirm",
        pauseHere: true,
        mainMessageFontSize: 19.0,
      ),
      RotatingTextData(
        mainMessage: "",
        pauseHere: true,
      ),
      RotatingTextData(
        mainMessage: "Tap to confirm",
        pauseHere: true,
        mainMessageFontSize: 19.0,
      ),
      RotatingTextData(
        mainMessage: "",
        pauseHere: true,
      ),
    ];
    if (orientation == MirroredTextOrientations.rightSideUp) {
      arr.removeAt(1);
    }
    return arr;
  }

  static List<RotatingTextData> get notesSessionPrimaryList => [
        RotatingTextData(
          mainMessage: "Swipe up to submit",
          pauseHere: true,
          mainMessageFontSize: 22.0,
        ),
      ];

  static List<RotatingTextData> get nokhteSessionExitScreenTopText => [
        RotatingTextData(
          mainMessage: "Swipe up to Exit",
          pauseHere: true,
          mainMessageFontSize: 22.0,
        ),
      ];
  static List<RotatingTextData> get nokhteSessionExitScreenBottom => [
        RotatingTextData(
          mainMessage: "Swipe down to continue",
          pauseHere: true,
          mainMessageFontSize: 22.0,
        ),
      ];

  static List<RotatingTextData> get nokhteSessionExitWaiting => [
        RotatingTextData(
          mainMessage: "Waiting",
          pauseHere: true,
        ),
      ];

  static List<RotatingTextData> get storageHeader => [
        RotatingTextData(
          mainMessage: "Sessions:",
          pauseHere: true,
          mainMessageFontSize: 40.0,
        ),
      ];
}
