import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/core.dart';
import '_action.dart';

///
///
///
@Deprecated("TODO: Do it?")
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

  Future<ApiResult<ITEM_DETAIL>> performQuickReplaceItem({
    required Object? parentBlockItem,
    required FILTER_CRITERIA filterCriteria,
  });
}
