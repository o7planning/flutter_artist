import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/core.dart';
import '_quick_action.dart';

abstract class BlockQuickItemUpdateAction<
    ID extends Object, //
    ITEM extends Object,
    ITEM_DETAIL extends Object,
    FILTER_CRITERIA extends FilterCriteria> extends QuickAction {
  final BlockQuickItemUpdateActionConfig config;
  final ITEM item;

  const BlockQuickItemUpdateAction({
    required this.item,
    required this.config,
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<ITEM_DETAIL>> callApiQuickUpdateItem({
    required Object? parentBlockItem,
    required FILTER_CRITERIA filterCriteria,
  });
}

class BlockQuickItemUpdateActionConfig {
  final bool errorIfItemNotInTheBlock;

  BlockQuickItemUpdateActionConfig({required this.errorIfItemNotInTheBlock});
}
