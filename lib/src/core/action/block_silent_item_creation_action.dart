import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/core.dart';
import '_quick_action.dart';

abstract class BlockSilentItemCreationAction<
    ID extends Object, //
    ITEM extends Object,
    ITEM_DETAIL extends Object,
    FILTER_CRITERIA extends FilterCriteria> extends QuickAction {
  const BlockSilentItemCreationAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<void>> callApiSilentlyCreateItem({
    required Object? parentBlockItem,
    required FILTER_CRITERIA filterCriteria,
  });
}
