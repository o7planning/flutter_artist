import 'package:flutter/material.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import 'base_action.dart';

abstract class ScalarLoadExtraDataQuickAction<DATA extends Object>
    extends BaseAction {
  const ScalarLoadExtraDataQuickAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<DATA>?> callApiLoadExtraData();

  Future<void> doWithExtraData(BuildContext context, {
    required bool success,
    required DATA? extraData,
  });
}
