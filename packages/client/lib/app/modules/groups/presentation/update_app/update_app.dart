import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppScreen extends HookWidget {
  const UpdateAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 500),
      initialValue: 0,
    );

    final fadeIn = useAnimation(
      Tween<double>(begin: 0, end: 1).animate(controller),
    );

    handleTap() async {
      final Uri url;
      if (Platform.isIOS) {
        url = Uri.parse('https://apps.apple.com/us/app/nokhte/id6470394110');
      } else {
        url = Uri.parse(
            'https://play.google.com/store/apps/details?id=com.nokhte.nokhte');
      }
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      }
    }

    useEffect(() {
      controller.forward();
      return null;
    }, []);

    return GestureDetector(
      onTap: () async => await handleTap(),
      child: AnimatedScaffold(
          body: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                return Opacity(
                  opacity: fadeIn,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Center(
                        child: Jost(
                          'Update Available',
                          fontSize: 24,
                          softWrap: true,
                          shouldCenter: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Jost(
                        'tap anywhere to go to app store',
                        fontSize: 16,
                        fontColor: Colors.black.withOpacity(.6),
                        softWrap: true,
                        shouldCenter: true,
                      ),
                    ],
                  ),
                );
              })),
    );
  }
}
