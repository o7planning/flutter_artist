import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/core.dart';
import '../enums/after_silent_action.dart';
import '_action.dart';

abstract class BlockSilentItemUpdateAction<
    ID extends Object, //
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>,
    FILTER_CRITERIA extends FilterCriteria> extends Action {
  final BlockSilentItemUpdateActionConfig config;
  final ITEM item;

  const BlockSilentItemUpdateAction({
    required this.item,
    required this.config,
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<ID>> callApiSilentlyUpdateItem({
    required Object? parentBlockItem,
    required FILTER_CRITERIA filterCriteria,
  });
}

class BlockSilentItemUpdateActionConfig {
  final AfterBlockSilentAction afterSilentAction;
  final bool errorIfItemNotInTheBlock;

  const BlockSilentItemUpdateActionConfig({
    required this.errorIfItemNotInTheBlock,
    this.afterSilentAction = AfterBlockSilentAction.none,
  });
}
