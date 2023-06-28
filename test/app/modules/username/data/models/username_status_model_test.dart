// * Primala Data Import
import 'package:primala/app/modules/username/data/models/username_status_model.dart';
// * Testing & Mocking Libs
import 'package:flutter_test/flutter_test.dart';
import '../constants/username_data_constants.dart';

void main() {
  const UsernameStatusModel falseUsernameModel =
      UsernameStatusModel(isCreated: false);
  const UsernameStatusModel trueUsernameModel =
      UsernameStatusModel(isCreated: true);
  test("`fromSupabase` should return false if empty array is given", () async {
    final res = UsernameStatusModel.fromSupabase([]);

    expect(res, falseUsernameModel);
  });
  test("`fromSupabase` should return false if empty array is given", () async {
    final res = UsernameStatusModel.fromSupabase(
      UsernameDataConstants.usernameQueryResponse,
    );

    expect(res, trueUsernameModel);
  });
}
