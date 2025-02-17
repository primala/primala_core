import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nokhte/app/modules/auth/auth.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:nokhte/app/core/utilities/misc_algos.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

abstract class AuthRemoteSource {
  Future<bool> signInWithGoogle();
  Future<bool> signInWithApple();
  Future<List> signUp(SignUpParams params);
  Future<List> logIn(LogInParams params);
  Stream<bool> getAuthState();
  Future<List> addName({String theName = ""});
  Future<Map> getUserInfo();
  Future<bool> versionIsUpToDate();
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  final SupabaseClient supabase;

  AuthRemoteSourceImpl({required this.supabase});

  @override
  signInWithGoogle() async {
    await dotenv.load();
    String bundleID = dotenv.env["APP_ID"] ?? '';
    if (kDebugMode && Platform.isAndroid) {
      bundleID = dotenv.env["ANDROID_APP_ID"] ?? '';
    }
    final res = await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      authScreenLaunchMode: LaunchMode.externalApplication,
      scopes: 'email profile openid',
      redirectTo: kIsWeb ? null : '$bundleID://login-callback',
    );
    return res;
  }

  @override
  signUp(SignUpParams params) async {
    // try {
    await supabase.auth.signUp(
      email: params.email,
      password: params.password,
    );

    final email = supabase.auth.currentUser?.email ?? '';
    final queries = UsersQueries(supabase: supabase);
    return await queries.insertUserInfo(
      fullName: params.fullName,
      email: email,
    );
  }

  @override
  signInWithApple() async {
    final rawNonce = MiscAlgos.generateRandomString();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );
    final firstName = credential.givenName ?? '';
    final lastName = credential.familyName ?? '';
    final idToken = credential.identityToken ?? '';

    final authRes = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );

    final email = authRes.user?.email ?? '';
    final queries = UsersQueries(supabase: supabase);

    await queries.insertUserInfo(
        fullName: '$firstName $lastName'.trim().isEmpty
            ? 'Nokhte User'
            : '$firstName $lastName',
        email: email);
    return authRes.user?.id.isNotEmpty ?? false;
  }

  @override
  getAuthState() => supabase.auth.onAuthStateChange
      .map((e) => e.session?.accessToken.isNotEmpty ?? false);

  @override
  addName({String theName = ""}) async {
    final queries = UsersQueries(supabase: supabase);
    final Map nameCheck = await queries.getUserInfo();
    String fullName;
    if (nameCheck.isEmpty) {
      if (theName.isEmpty) {
        fullName = supabase.auth.currentUser?.userMetadata?["full_name"] ??
            supabase.auth.currentUser?.userMetadata?["name"] ??
            supabase.auth.currentUser?.userMetadata?["email"];
      } else {
        fullName = theName;
      }
      if (fullName.trim().isEmpty) {
        fullName = 'Nokhte User';
      }

      final email = supabase.auth.currentUser?.email ?? '';

      return await queries.insertUserInfo(
        fullName: fullName,
        email: email,
      );
    } else {
      return [];
    }
  }

  @override
  getUserInfo() async {
    final queries = UsersQueries(supabase: supabase);
    return await queries.getUserInfo();
  }

  @override
  versionIsUpToDate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return (await supabase.rpc('get_valid_app_versions')).contains(version);
  }

  @override
  logIn(params) async {
    await supabase.auth.signInWithPassword(
      email: params.email,
      password: params.password,
    );
    return [];
  }
}
