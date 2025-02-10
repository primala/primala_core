import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte_backend/tables/sessions.dart';

class HomeScreenBody extends HookWidget {
  final ActiveSession activeSession;
  final Function startSession;
  final Function joinSession;

  const HomeScreenBody({
    super.key,
    required this.activeSession,
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
                activeSession.canJoin
                    ? '${activeSession.sessionHost} has started a session'
                    : activeSession.sessionHost.isEmpty
                        ? 'Who would you like to collaborate with today?'
                        : 'Session is already happening, only 1 session at a time per group',
                fontSize: 24,
                softWrap: true,
                shouldCenter: true,
              ),
            ),
            const SizedBox(height: 84),
            if (activeSession.canJoin || activeSession.id == -1)
              ElevatedButton(
                onPressed: () {
                  if (activeSession.canJoin) {
                    joinSession();
                  } else {
                    startSession();
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
                  activeSession.canJoin ? 'Join Session' : 'Start Session',
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
