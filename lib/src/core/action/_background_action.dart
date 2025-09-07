import 'package:flutter_artist_core/flutter_artist_core.dart';

import '_action.dart';

abstract class BackgroundAction extends Action {
  BackgroundAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<void>> run();
}
