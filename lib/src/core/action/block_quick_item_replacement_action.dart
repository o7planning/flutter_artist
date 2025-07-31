import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/core.dart';
import '_quick_action.dart';

///
///
///
// TODO: Hoàn thành logic.
abstract class BlockQuickItemReplacementAction<
    ID extends Object, //
    ITEM extends Object,
    ITEM_DETAIL extends Object,
    FILTER_CRITERIA extends FilterCriteria> extends QuickAction {
  final ITEM item;

  const BlockQuickItemReplacementAction({
    required this.item,
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<ITEM_DETAIL>> callApiQuickReplaceItem({
    required Object? parentBlockItem,
    required FILTER_CRITERIA filterCriteria,
  });
}
