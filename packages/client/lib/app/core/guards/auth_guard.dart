import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGuard extends RouteGuard {
  final SupabaseClient supabase;

  AuthGuard({required this.supabase});

  @override
  Future<bool> canActivate(String path, ParallelRoute route) async {
    final session = supabase.auth.currentSession ?? {};
    if (session.toString() == "{}") {
      return true;
    } else {
      return false;
    }
  }

  @override
  String get redirectTo => GroupsConstants.groupPicker;
}
