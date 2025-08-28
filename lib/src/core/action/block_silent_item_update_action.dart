import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/core.dart';
import '_quick_action.dart';

abstract class BlockSilentItemUpdateAction<
    ID extends Object, //
    ITEM extends Object,
    ITEM_DETAIL extends Object,
    FILTER_CRITERIA extends FilterCriteria> extends QuickAction {
  final BlockSilentItemUpdateActionConfig config;
  final ITEM item;

  const BlockSilentItemUpdateAction({
    required this.item,
    required this.config,
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<void>> callApiSilentUpdateItem({
    required Object? parentBlockItem,
    required FILTER_CRITERIA filterCriteria,
  });
}

class BlockSilentItemUpdateActionConfig {
  final bool errorIfItemNotInTheBlock;

  BlockSilentItemUpdateActionConfig({required this.errorIfItemNotInTheBlock});
}
