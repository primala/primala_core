// * Testing & Mocking Libs
import 'package:flutter_test/flutter_test.dart';
import 'package:primala/app/modules/p2p_request_recipient/data/models/p2p_recipient_response_status_model.dart';

import '../../constants/models.dart';

void main() {
  test('`fromSupabase should return false when given an empty array', () {
    final res = P2PRequestRecipientResponseStatusModel.fromSupabase([]);
    expect(res, ConstantModels.unwrappedNotSuccessfulP2PRecipReqResStatusModel);
  });

  test('`fromSupabase should return true when given an non-empty array', () {
    final res = P2PRequestRecipientResponseStatusModel.fromSupabase([{}]);
    expect(res, ConstantModels.unwrappedSuccessfulP2PRecipReqResStatusModel);
  });
}
