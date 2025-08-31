import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/core.dart';
import '../enums/after_silent_action.dart';
import '_quick_action.dart';

abstract class BlockSilentItemCreationAction<
    ID extends Object, //
    ITEM extends Object,
    ITEM_DETAIL extends Object,
    FILTER_CRITERIA extends FilterCriteria> extends QuickAction {
  final BlockSilentItemCreationActionConfig config;

  const BlockSilentItemCreationAction({
    required this.config,
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<void>> callApiSilentlyCreateItem({
    required Object? parentBlockItem,
    required FILTER_CRITERIA filterCriteria,
  });
}

class BlockSilentItemCreationActionConfig {
  final AfterBlockSilentAction afterSilentAction;

  const BlockSilentItemCreationActionConfig({
    this.afterSilentAction = AfterBlockSilentAction.none,
  });
}
