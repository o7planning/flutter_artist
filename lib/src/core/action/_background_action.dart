import 'package:flutter_artist_core/flutter_artist_core.dart';

import '_quick_action.dart';

abstract class BackgroundAction extends QuickAction {
  BackgroundAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<void>> run();
}
