import 'package:flutter/material.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_fa_core.dart';
import 'base_action.dart';

abstract class BlockQuickCreateItemAction<
ID extends Object, //
ITEM extends Object,
ITEM_DETAIL extends Object,
FILTER_CRITERIA extends FilterCriteria> extends BaseAction {
  const BlockQuickCreateItemAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<ITEM_DETAIL>> callApiQuickCreateItem({
    required Object? parentBlockItem,
    required FILTER_CRITERIA filterCriteria,
  });
}
