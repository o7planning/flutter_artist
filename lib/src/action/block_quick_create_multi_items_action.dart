import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_fa_core.dart';
import 'base_action.dart';

abstract class BlockQuickCreateMultiItemsAction<
    ID extends Object, //
    ITEM extends Object,
    ITEM_DETAIL extends Object,
    FILTER_CRITERIA extends FilterCriteria> extends BaseAction {
  const BlockQuickCreateMultiItemsAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<PageData<ITEM>>> callApiQuickCreateMultiItems({
    required Object? parentBlockItem,
    required FILTER_CRITERIA filterCriteria,
  });
}
