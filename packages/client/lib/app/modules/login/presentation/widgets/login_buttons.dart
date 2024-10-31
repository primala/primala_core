import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';

class LoginButtons extends HookWidget {
  final bool showLoginButtons;
  final Function onSignInWithApple;
  final Function onSignInWithGoogle;
  const LoginButtons({
    super.key,
    required this.showLoginButtons,
    required this.onSignInWithApple,
    required this.onSignInWithGoogle,
  });

  Widget buildLoginButton({
    required String label,
    required String assetPath,
    required double width,
    required VoidCallback onPressed,
    required double bottomPadding,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 8.0, bottom: bottomPadding),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Image.asset(
            assetPath,
            width: 24,
            height: 24,
          ),
          label: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w300,
            ),
          ),
          style: ElevatedButton.styleFrom(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
              left: width * .15,
              top: 12.0,
              bottom: 12.0,
            ),
            fixedSize: Size(width * 0.7, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            // alignment: Alignment.centerLeft,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = useFullScreenSize().width;
    return AnimatedOpacity(
      opacity: useWidgetOpacity(showLoginButtons),
      duration: Seconds.get(1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Opacity(
            opacity: Platform.isIOS ? 1 : 0.5,
            child: buildLoginButton(
              label: "Sign in with Apple",
              assetPath: 'assets/apple_icon.png',
              width: width,
              onPressed: Platform.isIOS
                  ? () async => await onSignInWithApple()
                  : () {},
              bottomPadding: 8,
            ),
          ),
          buildLoginButton(
            label: "Sign in with Google",
            assetPath: 'assets/google_icon.png',
            width: width,
            onPressed: () async => await onSignInWithGoogle(),
            bottomPadding: 50,
          ),
        ],
      ),
    );
  }
}
