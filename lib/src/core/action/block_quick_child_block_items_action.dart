import 'package:flutter_artist_core/flutter_artist_core.dart';

import '_quick_action.dart';

abstract class BlockQuickChildBlockItemsAction<
ITEM extends Object, //
ITEM_DETAIL extends Object> extends QuickAction {
  final ITEM item;

  const BlockQuickChildBlockItemsAction({
    required this.item,
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<ITEM_DETAIL>> callApiChildBlockItems();
}
