import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'posthog.dart';
export 'constants/constants.dart';
export 'data/data.dart';
export 'domain/domain.dart';

class PosthogModule extends Module {
  @override
  @override
  exportedBinds(i) {
    i.add<PosthogRemoteSourceImpl>(
      () => PosthogRemoteSourceImpl(
        supabase: Modular.get<SupabaseClient>(),
      ),
    );
    i.add<PosthogContractImpl>(
      () => PosthogContractImpl(
        remoteSource: i<PosthogRemoteSourceImpl>(),
        networkInfo: Modular.get<NetworkInfoImpl>(),
      ),
    );
    i.add<CaptureScreen>(
      () => CaptureScreen(
        contract: Modular.get<PosthogContractImpl>(),
      ),
    );
    i.add<CaptureSessionEnd>(
      () => CaptureSessionEnd(
        contract: Modular.get<PosthogContractImpl>(),
      ),
    );
    i.add<CaptureSessionStart>(
      () => CaptureSessionStart(
        contract: Modular.get<PosthogContractImpl>(),
      ),
    );
    i.add<IdentifyUser>(
      () => IdentifyUser(
        contract: Modular.get<PosthogContractImpl>(),
      ),
    );
  }
}
