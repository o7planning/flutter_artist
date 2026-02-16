import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/core.dart';
import '_action.dart';

abstract class BlockQuickItemCreationAction<
    ID extends Object, //
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>,
    FILTER_CRITERIA extends FilterCriteria> extends Action {
  const BlockQuickItemCreationAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<ITEM_DETAIL>> performQuickCreateItem({
    required Object? parentBlockItem,
    required FILTER_CRITERIA filterCriteria,
  });
}
