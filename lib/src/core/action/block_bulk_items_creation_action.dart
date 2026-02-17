import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/core.dart';
import '_action.dart';

// BlockQuickItem CreationAction --> BlockBulkItemsCreationAction
// call ApiQuickCreateMultiItems --> performBulkCreateItems
abstract class BlockBulkItemsCreationAction<
    ID extends Object, //
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>,
    FILTER_CRITERIA extends FilterCriteria> extends Action {
  const BlockBulkItemsCreationAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<PageData<ITEM>>> performBulkCreateItems({
    required Object? parentBlockItem,
    required FILTER_CRITERIA filterCriteria,
  });
}
