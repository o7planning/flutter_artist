import 'package:flutter_artist_core/flutter_artist_core.dart';

import 'base_action.dart';

abstract class BackgroundAction extends BaseAction {
  BackgroundAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<void>> callApi();
}
