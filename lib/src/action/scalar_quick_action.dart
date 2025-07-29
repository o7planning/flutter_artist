import 'package:flutter/material.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import 'base_action.dart';

abstract class ScalarQuickAction<DATA extends Object> extends BaseAction {
  final List<Type> affectedItemTypes;

  const ScalarQuickAction({
    required super.needToConfirm,
    required super.actionInfo,
    required this.affectedItemTypes,
  });

  Future<ApiResult<DATA>?> callApi();
}
