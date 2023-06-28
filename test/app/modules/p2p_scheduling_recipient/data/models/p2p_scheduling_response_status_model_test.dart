import 'package:flutter_test/flutter_test.dart';
import '../../constants/return/respond/response_status_models.dart';
import '../../constants/sample_data.dart';
import 'package:primala/app/modules/p2p_scheduling_recipient/data/models/p2p_scheduling_response_status_model.dart';

void main() {
  test("`fromSupabase` should return entity w/ false if empty array is given",
      () {
    final res = P2PSchedulingResponseStatusModel.fromSupabase([]);

    expect(res, ConstantResponseStatusModels.notSuccessCase);
  });
  test("`fromSupabase` should return false if value isn't set properly", () {
    final res = P2PSchedulingResponseStatusModel.fromSupabase(
        [SampleData.notSuccessRespondRes]);

    expect(res, ConstantResponseStatusModels.notSuccessCase);
  });
  test("`fromSupabase` should return true if proper response is given", () {
    final res = P2PSchedulingResponseStatusModel.fromSupabase([
      SampleData.successRespondRes,
    ]);

    expect(res, ConstantResponseStatusModels.successCase);
  });
}
