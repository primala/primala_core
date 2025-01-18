import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nokhte/app/core/modules/hive/mixin/mixin.dart';
import 'package:nokhte/app/core/modules/hive/types/boxes.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/modules/auth/domain/domain.dart';
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
  Future<List> getUserInfo();
  Future<bool> versionIsUpToDate();
}

class AuthRemoteSourceImpl with HiveBoxUtils implements AuthRemoteSource {
  final SupabaseClient supabase;
  late UserInformationRemoteSourceImpl userInfoRemoteSource;

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

    final firstName = params.fullName.split(' ')[0];
    final lastName = params.fullName.split(' ')[1];
    final email = supabase.auth.currentUser?.email ?? '';
    final queries = UsersQueries(supabase: supabase);
    return await queries.insertUserInfo(
        firstName: firstName, lastName: lastName, email: email);
    // } catch (e) {
    //   throw Left(SupabaseFailure(
    //     message: e.toString(),
    //     failureCode: e.toString(),
    //   ));
    // }
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
        firstName: firstName, lastName: lastName, email: email);
    return authRes.user?.id.isNotEmpty ?? false;
  }

  @override
  getAuthState() => supabase.auth.onAuthStateChange
      .map((e) => e.session?.accessToken.isNotEmpty ?? false);

  @override
  addName({String theName = ""}) async {
    final queries = UsersQueries(supabase: supabase);
    final List nameCheck = await queries.getUserInfo();
    List insertRes;
    String fullName;
    if (nameCheck.isEmpty) {
      if (theName.isEmpty) {
        fullName = supabase.auth.currentUser?.userMetadata?["full_name"] ??
            supabase.auth.currentUser?.userMetadata?["name"] ??
            supabase.auth.currentUser?.userMetadata?["email"];
      } else {
        fullName = theName;
      }
      final [firstName, lastName] = MiscAlgos.returnSplitName(fullName);

      final email = supabase.auth.currentUser?.email ?? '';

      insertRes = await queries.insertUserInfo(
        firstName: firstName,
        lastName: lastName,
        email: email,
      );
      return updateBox(
        data: insertRes.first,
        name: HiveBoxes.userInformation.toString(),
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
