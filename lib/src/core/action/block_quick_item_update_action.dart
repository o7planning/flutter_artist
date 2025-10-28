import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/core.dart';
import '_action.dart';

abstract class BlockQuickItemUpdateAction<
    ID extends Object, //
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>,
    FILTER_CRITERIA extends FilterCriteria> extends Action {
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
