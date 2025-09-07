import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/core.dart';
import '_action.dart';

abstract class BlockQuickItemCreationAction<
    ID extends Object, //
    ITEM extends Object,
    ITEM_DETAIL extends Object,
    FILTER_CRITERIA extends FilterCriteria> extends Action {
  const BlockQuickItemCreationAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<ITEM_DETAIL>> callApiQuickCreateItem({
    required Object? parentBlockItem,
    required FILTER_CRITERIA filterCriteria,
  });
}
