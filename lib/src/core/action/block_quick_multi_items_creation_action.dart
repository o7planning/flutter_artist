import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/core.dart';
import '_action.dart';

abstract class BlockQuickMultiItemsCreationAction<
    ID extends Object, //
    ITEM extends Object,
    ITEM_DETAIL extends Object,
    FILTER_CRITERIA extends FilterCriteria> extends Action {
  const BlockQuickMultiItemsCreationAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<PageData<ITEM>>> callApiQuickCreateMultiItems({
    required Object? parentBlockItem,
    required FILTER_CRITERIA filterCriteria,
  });
}
