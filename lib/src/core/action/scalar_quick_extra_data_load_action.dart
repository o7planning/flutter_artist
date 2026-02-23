import 'package:flutter/material.dart' hide Action;
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '_action.dart';

abstract class ScalarQuickExtraDataLoadAction<DATA extends Object>
    extends Action {
  const ScalarQuickExtraDataLoadAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<DATA>?> performLoadExtraData();

  Future<void> onExtraDataLoaded(
    BuildContext context, {
    required bool success,
    required DATA? extraData,
  });
}
