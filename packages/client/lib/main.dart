import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nokhte/app/app_module.dart';
import 'package:nokhte/app/app_widget.dart';
import 'package:nokhte/app/core/modules/quick_actions/constants/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  Modular.setInitialRoute('/login/');

  await Hive.initFlutter();

  late String supabaseUrl;
  late String supabaseAnonKey;
  if (kDebugMode) {
    supabaseUrl = dotenv.env["DEV_SUPABASE_URL"] ?? '';
    supabaseAnonKey = dotenv.env["DEV_SUPABASE_ANON_KEY"] ?? '';

    // supabaseUrl = dotenv.env["PROD_SUPABASE_URL"] ?? '';
    // supabaseAnonKey = dotenv.env["PROD_SUPABASE_ANON_KEY"] ?? '';

    // supabaseUrl = dotenv.env["STAGING_SUPABASE_URL"] ?? '';
    // supabaseAnonKey = dotenv.env["STAGING_SUPABASE_ANON_KEY"] ?? '';
  } else {
    supabaseUrl = dotenv.env["STAGING_SUPABASE_URL"] ?? '';
    supabaseAnonKey = dotenv.env["STAGING_SUPABASE_ANON_KEY"] ?? '';

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version.replaceAll(".", "_");
    final isEnabled = await Posthog().isFeatureEnabled('release_v$version');

    if (isEnabled) {
      supabaseUrl = dotenv.env["PROD_SUPABASE_URL"] ?? '';
      supabaseAnonKey = dotenv.env["PROD_SUPABASE_ANON_KEY"] ?? '';
    }
  }
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  await QuickActionsConstants.initQuickActions();

  runApp(
    ModularApp(
      debugMode: true,
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}
