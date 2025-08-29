import 'package:flutter/material.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '_quick_action.dart';

abstract class ScalarQuickExtraDataLoadAction<DATA extends Object>
    extends QuickAction {
  const ScalarQuickExtraDataLoadAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<DATA>?> callApiLoadExtraData();

  Future<void> doWithExtraData(
    BuildContext context, {
    required bool success,
    required DATA? extraData,
  });
}
