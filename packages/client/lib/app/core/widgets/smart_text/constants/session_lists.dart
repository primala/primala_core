import 'package:nokhte/app/core/widgets/widgets.dart';

class SessionLists {
  static RotatingTextData putYourPhoneOnDND = RotatingTextData(
    text: "Put your phone on do not disturb",
    pauseHere: true,
    mainFontSize: 24.0,
  );

  static List<RotatingTextData> previewHeader = [
    RotatingTextData(
      text: "Session Type",
      pauseHere: true,
      mainFontSize: 40.0,
    ),
  ];

  static List<RotatingTextData> lobby = [
    // SharedLists.emptyItem,
    RotatingTextData(
      text: "Tap to begin",
      pauseHere: true,
    ),
    RotatingTextData(
      text: "Tap to begin",
      pauseHere: true,
    ),
    SharedLists.emptyItem,
  ];

  static List<RotatingTextData> tapWhenYouHaveDoneSo(int length) => List.filled(
        length,
        RotatingTextData(
          text: "Tap when you have done so",
          pauseHere: true,
          mainFontSize: 20.0,
        ),
      );

  static List<RotatingTextData> collaborationGreeterPrimary = [
    putYourPhoneOnDND,
    SharedLists.emptyItem,
  ];

  static List<RotatingTextData> trialGreeterPrimary = [
    RotatingTextData(
      text: "This is your only Trial Group Session",
      pauseHere: true,
      mainFontSize: 24.0,
    ),
  ];

  static List<RotatingTextData> singleTapToConfirm = [
    SharedLists.tapToConfirm(20),
    SharedLists.emptyItem,
  ];

  static List<RotatingTextData> duoGreeterPrimary = [
    putYourPhoneOnDND,
    RotatingTextData(
      text: "Put both phones in a position both of you can reach",
      pauseHere: true,
      mainFontSize: 24.0,
    ),
    SharedLists.emptyItem,
    RotatingTextData(
      text: "Tap on the other phone to continue",
      pauseHere: true,
    ),
  ];

  static List<RotatingTextData> duoGreeterSecondary = tapWhenYouHaveDoneSo(2);
  static List<RotatingTextData> groupGreeterSecondary = [
    ...tapWhenYouHaveDoneSo(3),
    SharedLists.emptyItem,
  ];

  static List<RotatingTextData> get groupGreeterPrimary => [
        putYourPhoneOnDND,
        RotatingTextData(
          text: "Sit in a circle",
          pauseHere: true,
          mainFontSize: 23.0,
        ),
        RotatingTextData(
          text:
              "Place your phone halfway between you and the person to your right",
          pauseHere: true,
          mainFontSize: 22.0,
        ),
        SharedLists.emptyItem,
      ];

  static List<RotatingTextData> speakingInstructionsPrimary({
    required bool isHybrid,
    bool isHoldToTalk = true,
  }) {
    String phoneOrSide = isHybrid ? "side" : "phone";
    return [
      RotatingTextData(
        text: "The point of this $phoneOrSide is to limit speaking",
        pauseHere: true,
        mainFontSize: 22.0,
        subText: "Tap to confirm",
        subFontSize: 18.0,
      ),
      RotatingTextData(
        text: isHoldToTalk
            ? "You can only speak when your finger is on the screen"
            : "You can only speak when you tap on the screen",
        pauseHere: true,
        mainFontSize: 22.0,
        subText: "Tap to confirm",
        subFontSize: 18.0,
      ),
      RotatingTextData(
        text: isHoldToTalk ? "Now, put your finger on the screen" : "Tap",
        pauseHere: true,
        mainFontSize: 22.0,
        subText: "",
        subFontSize: 18.0,
      ),
      SharedLists.emptyItem,
      RotatingTextData(
        text: "Only you are allowed to speak right now",
        mainFontSize: 22.0,
        pauseHere: true,
        subText: "",
        subFontSize: 18.0,
      ),
      SharedLists.emptyItem,
      RotatingTextData(
        text: isHoldToTalk ? "Let go" : "Tap again",
        mainFontSize: 22.0,
        pauseHere: true,
        subText: "",
        subFontSize: 18.0,
      ),
    ];
  }

  static List<RotatingTextData> soloHybridInstructions = [
    ...speakingInstructionsPrimary(
      isHybrid: true,
      isHoldToTalk: false,
    ),
    ...getNotesInstructions(
      isHybrid: true,
    ),
  ];

  static RotatingTextData thisIsYou = SharedLists.customTapToConfirmSub(
    "This is you",
    subTextFontSize: 18.0,
  );

  static RotatingTextData thatIsYourCollaborator =
      SharedLists.customTapToConfirmSub(
    "That is your collaborator",
    subTextFontSize: 18.0,
  );

  static List<RotatingTextData> socraticSpeakingSymbols = [
    thisIsYou,
    thatIsYourCollaborator,
    SharedLists.customTapToConfirmSub(
      "All the Phones will be used for speaking during the session",
      subTextFontSize: 18.0,
      mainFontSize: 20.0,
    ),
    SharedLists.emptyItem,
  ];

  static List<RotatingTextData> socraticJustSymbols = [
    SharedLists.customTapToConfirmSub(
      "All the Phones will be used for speaking during the session",
      subTextFontSize: 18.0,
      mainFontSize: 20.0,
    ),
    SharedLists.customTapToConfirmSub(
      "Everyone will take a note at the end of the session",
      subTextFontSize: 18.0,
      mainFontSize: 20.0,
    ),
  ];

  static List<RotatingTextData> socraticNotesSymbols = [
    SharedLists.customTapToConfirmSub(
      "Everyone will take a note at the end of the session",
      subTextFontSize: 18.0,
      mainFontSize: 22.0,
    ),
    SharedLists.emptyItem,
  ];

  static List<RotatingTextData> consultationTalkingSymbols = [
    thisIsYou,
    thatIsYourCollaborator,
    SharedLists.customTapToConfirmSub(
      "One phone will be used for speaking",
      subTextFontSize: 18.0,
    ),
    SharedLists.emptyItem,
  ];

  static List<RotatingTextData> collaborationFullInstructions = [
    thisIsYou,
    SharedLists.customTapToConfirmSub(
      "Your phone will be used to talk and take notes",
      subTextFontSize: 18.0,
    ),
    SharedLists.emptyItem,
  ];

  static List<RotatingTextData> consultationJustSymbols = [
    SharedLists.customTapToConfirmSub(
      "One phone will be used for speaking",
      subTextFontSize: 18.0,
    ),
    SharedLists.customTapToConfirmSub(
      "Another phone will be used for notes",
      subTextFontSize: 18.0,
    ),
    SharedLists.emptyItem,
  ];

  static List<RotatingTextData> collaborationJustSymbols = [
    SharedLists.customTapToConfirmSub(
      "You can be anywhere in the room",
      subTextFontSize: 18.0,
    ),
    SharedLists.emptyItem,
  ];

  static List<RotatingTextData> consultationNotesSymbols = [
    SharedLists.customTapToConfirmSub(
      "Another phone will be used for notes",
      subTextFontSize: 18.0,
    ),
    SharedLists.emptyItem,
  ];

  static List<RotatingTextData> showGroupGeometry = [
    SharedLists.customTapToConfirmSub(
      "2 Person Group",
    ),
    SharedLists.emptyItem,
    SharedLists.customTapToConfirmSub(
      "3 Person Group",
    ),
    SharedLists.emptyItem,
    SharedLists.customTapToConfirmSub(
      "4 Person Group",
    ),
    SharedLists.emptyItem,
  ];

  static List<RotatingTextData> waitForTheOthers = [
    RotatingTextData(
      text: "Wait for the others",
      pauseHere: true,
    ),
    SharedLists.emptyItem,
  ];

  static List<RotatingTextData> holdToTalk = [
    RotatingTextData(
      text: "Hold to talk",
      pauseHere: true,
      mainFontSize: 19.0,
    ),
  ];

  static List<RotatingTextData> tapToTalk = [
    RotatingTextData(
      text: "Tap to talk",
      pauseHere: true,
      mainFontSize: 19.0,
    ),
  ];
  static List<RotatingTextData> tapToTakeANote = [
    RotatingTextData(
      text: "Tap to take a note",
      pauseHere: true,
      mainFontSize: 19.0,
    ),
  ];

  static List<RotatingTextData> get socraticNotesInstructions => [
        SharedLists.customTapToConfirmSub(
          "Swipe down on all the phones to take your final notes",
          mainFontSize: 22.0,
        ),
        SharedLists.emptyItem,
      ];

  static List<RotatingTextData> getNotesInstructions({
    required bool isHybrid,
  }) {
    String phoneOrSide = isHybrid ? "side" : "phone";
    final arr = [
      RotatingTextData(
        text: "This $phoneOrSide will be used for notes",
        pauseHere: true,
        mainFontSize: 22.0,
        subText: "Tap to confirm",
        subFontSize: 18.0,
      ),
      RotatingTextData(
        text: "To complete the session swipe down on all the phones",
        pauseHere: true,
        mainFontSize: 20.0,
        subText: "Tap to confirm",
        subFontSize: 18.0,
      ),
      SharedLists.emptyItem,
    ];
    return arr;
  }

  static List<RotatingTextData> paywallPrimaryList({
    required num price,
    required String period,
    required String currencyCode,
  }) =>
      [
        RotatingTextData(
          text: "Pairs are free",
          subText: "Tap to confirm",
          subFontSize: 18.0,
          pauseHere: true,
        ),
        RotatingTextData(
          text: "Trios are also free",
          subText: "Tap to confirm",
          subFontSize: 18.0,
          pauseHere: true,
        ),
        RotatingTextData(
          text: "Groups larger than 4 require everyone to pay",
          subText: "Tap to confirm",
          subFontSize: 18.0,
          pauseHere: true,
        ),
        ...SharedLists.genEmptyList(2),
      ];
  static List<RotatingTextData> swipeUpToPay = [
    RotatingTextData(
      text: "Swipe up to pay",
      pauseHere: true,
    ),
  ];
  static List<RotatingTextData> swipeToDecide = [
    RotatingTextData(
      text: "Swipe to decide",
      mainFontSize: 18.0,
      pauseHere: true,
    ),
  ];

  static List<RotatingTextData> notesPrimary = [
    RotatingTextData(
      text: "Swipe up to submit",
      pauseHere: true,
      mainFontSize: 22.0,
    ),
  ];

  static List<RotatingTextData> waitingToTakeFinalNote = [
    RotatingTextData(
      text: "Waiting to take final note",
      subFontSize: 22.0,
      pauseHere: true,
      mainFontSize: 22.0,
    ),
  ];

  static List<RotatingTextData> waitingToLeave = [
    RotatingTextData(
      text: "Waiting to leave",
      pauseHere: true,
      mainFontSize: 22.0,
    ),
  ];
  static List<RotatingTextData> exitBottomText = [
    RotatingTextData(
      text: "Swipe down to cancel",
      pauseHere: true,
      mainFontSize: 22.0,
    ),
  ];
}
