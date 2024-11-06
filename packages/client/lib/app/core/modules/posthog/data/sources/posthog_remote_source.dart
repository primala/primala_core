import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class PosthogRemoteSource {
  Future<void> identifyUser();
  Future<void> captureSessionStart(
    CaptureSessionStartParams params,
  );
  Future<void> captureSessionEnd(
    CaptureSessionEndParams params,
  );
  Future<void> captureScreen(String screenRoute);
}

class PosthogRemoteSourceImpl
    with PosthogEventConstants
    implements PosthogRemoteSource {
  String formatRoute(String input) {
    if (input.startsWith('/')) {
      input = input.substring(1);
    }
    if (input.endsWith('/')) {
      input = input.substring(0, input.length - 1);
    }
    return "\$${input}_screen";
  }

  final Posthog posthog = Posthog();
  @override
  captureSessionEnd(params) async {
    final durationInMinutes =
        DateTime.now().difference(params.sessionsStartTime).inSeconds / 60;
    print('durationInMinutes: $durationInMinutes');
    if (durationInMinutes < 5) return;
    await Posthog().capture(
      eventName: END_SESSION,
      properties: {
        "duration_minutes": durationInMinutes,
        "preset_type": params.presetType.toString(),
      },
    );
  }

  @override
  captureSessionStart(
    params,
  ) async =>
      await Posthog().capture(
        eventName: START_SESSION,
        properties: {
          "sent_at": DateTime.now().toIso8601String(),
          "number_of_collaborators": params.numberOfCollaborators,
          "preset_type": params.presetType.toString(),
        },
      );

  @override
  identifyUser() async {
    final supabase = Supabase.instance.client;
    await posthog.identify(userId: supabase.auth.currentUser!.id);
  }

  @override
  captureScreen(String screenRoute) async {
    await posthog.capture(eventName: formatRoute(screenRoute));
  }
}
