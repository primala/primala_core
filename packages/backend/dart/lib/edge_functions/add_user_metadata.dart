import 'package:nokhte_backend/tables/user_metadata/queries.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddUserMetadata extends UserMetadataQueries {
  AddUserMetadata({required super.supabase});

  Future<FunctionResponse> invoke() async {
    final checkRes = await getUserMetadata();
    if (checkRes.isEmpty) {
      return await supabase.functions.invoke(
        "add-user-metadata",
        body: {
          'userUID': userUID,
        },
      );
    } else {
      return FunctionResponse(
        status: 200,
        data: {"status": 200, "message": 'metadata already exists'},
      );
    }
  }
}
