import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/core.dart';
import '_action.dart';

///
///
///
// TODO: Hoàn thành logic.
abstract class BlockQuickItemReplacementAction<
    ID extends Object, //
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>,
    FILTER_CRITERIA extends FilterCriteria> extends Action {
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
