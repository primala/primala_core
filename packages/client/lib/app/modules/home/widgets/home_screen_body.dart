import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class HomeScreenBody extends HookWidget {
  final bool sessionIsActive;
  final String sessionHost;
  final Function startSession;
  final Function joinSession;

  const HomeScreenBody({
    super.key,
    required this.sessionIsActive,
    required this.sessionHost,
    required this.startSession,
    required this.joinSession,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Jost(
                sessionIsActive
                    ? '$sessionHost has started a session'
                    : 'Who would you like to collaborate with today?',
                fontSize: 24,
                softWrap: true,
                shouldCenter: true,
              ),
            ),
            const SizedBox(height: 84),
            ElevatedButton(
              onPressed: () {
                if (sessionIsActive) {
                  startSession();
                } else {
                  joinSession();
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.black,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                splashFactory: NoSplash.splashFactory,
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 20.0),
              ),
              child: Jost(
                sessionIsActive ? 'Join Session' : 'Start Session',
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontColor: Colors.white,
              ),
            )

            //
          ],
        ),
      ),
    );
  }
}
