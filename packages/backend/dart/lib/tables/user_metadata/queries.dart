import 'constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserMetadataQueries extends UserMetadataConstants {
  final SupabaseClient supabase;
  String userUID;

  UserMetadataQueries({
    required this.supabase,
  }) : userUID = supabase.auth.currentUser?.id ?? '';

  Future<List> getUserMetadata() async =>
      await supabase.from(TABLE).select().eq(UID, userUID);
}
