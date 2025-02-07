import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';

class LoginButtons extends HookWidget {
  final Function onSignInWithApple;
  final Function onSignInWithGoogle;
  final Function onSignUp;
  final Function onLogIn;
  const LoginButtons({
    super.key,
    required this.onSignInWithApple,
    required this.onSignInWithGoogle,
    required this.onSignUp,
    required this.onLogIn,
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
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = useFullScreenSize().width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Opacity(
          opacity: Platform.isIOS ? 1 : 0.5,
          child: buildLoginButton(
            label: "Sign in with Apple",
            assetPath: 'assets/login/apple_icon.png',
            width: width,
            onPressed:
                Platform.isIOS ? () async => await onSignInWithApple() : () {},
            bottomPadding: 8,
          ),
        ),
        buildLoginButton(
          label: "Sign in with Google",
          assetPath: 'assets/login/google_icon.png',
          width: width,
          onPressed: () async => await onSignInWithGoogle(),
          bottomPadding: 32,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ElevatedButton(
            onPressed: () async => await onSignUp(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(.3),
              side: const BorderSide(color: Colors.white, width: 1),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
              ),
              fixedSize: Size(width * 0.7, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            child: const Text(
              'Sign up',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ElevatedButton(
            onPressed: () async => await onLogIn(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0),
              side: const BorderSide(color: Colors.white, width: 1),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
              ),
              fixedSize: Size(width * 0.7, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            child: const Text(
              'Log in',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        )
      ],
    );
  }
}
