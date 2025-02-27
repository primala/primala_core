import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte_backend/tables/users.dart';
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
  Future<void> captureCreateDoc();
}

class PosthogRemoteSourceImpl
    with PosthogEventConstants
    implements PosthogRemoteSource {
  final SupabaseClient supabase;
  late UsersQueries usersQueries;

  PosthogRemoteSourceImpl({required this.supabase});

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
        DateTime.now().difference(params.sessionStartTime).inSeconds / 60;
    if (durationInMinutes < 5) return;
    await Posthog().capture(
      eventName: END_SESSION,
      properties: {
        "duration_minutes": durationInMinutes,
        "number_of_collaborators": params.numberOfCollaborators,
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
        },
      );

  @override
  identifyUser() async {
    usersQueries = UsersQueries(supabase: supabase);
    final fullNameRes = await usersQueries.getFullName();
    await posthog.identify(
      userId: supabase.auth.currentUser!.id,
      userProperties: {
        "email": supabase.auth.currentUser!.email ?? '',
        "name": fullNameRes,
      },
    );
  }

  @override
  captureScreen(String screenRoute) async {
    await posthog.capture(eventName: formatRoute(screenRoute));
  }

  @override
  Future<void> captureCreateDoc() async =>
      posthog.capture(eventName: CREATE_DOC);
}
