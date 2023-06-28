import 'package:flutter_test/flutter_test.dart';
import '../../constants/return/confirm/confirm_scheduling_time_status_models.dart';
import 'package:primala/app/modules/p2p_scheduling_sender/data/models/confirm_p2p_scheduling_time_status_model.dart';

import '../../constants/sample_data.dart';

void main() {
  test("`fromSupabase` should return entity w/ false if empty array is given",
      () {
    final res = ConfirmP2PSchedulingTimeStatusModel.fromSupabase([]);

    expect(res, ConstantConfirmSchedulingTimeStatusModels.notSuccessCase);
  });
  test("`fromSupabase` should return true if array with values are given", () {
    final res = ConfirmP2PSchedulingTimeStatusModel.fromSupabase(
        [SampleData.successConfirmResponse]);

    expect(res, ConstantConfirmSchedulingTimeStatusModels.successCase);
  });
}
